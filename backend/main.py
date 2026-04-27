# ==============================================================
# MAIN — FastAPI WebSocket Server for Drowsiness Detection
# ==============================================================
#
# Entry point for the drowsiness detection backend.
#
# Responsibilities:
#   1. Expose a WebSocket endpoint at /ws
#   2. Accept base64-encoded JPEG frames from the Flutter app
#   3. Decode each frame with OpenCV
#   4. Run MediaPipe face mesh to extract eye landmarks
#   5. Pass landmarks to DrowsinessLogic for EAR analysis
#   6. Send the DetectionResult back to Flutter as JSON
#
# Start the server:
#   python main.py
#   — or —
#   uvicorn main:app --host 0.0.0.0 --port 8000
#
# WebSocket endpoint:
#   ws://<server-ip>:8000/ws
#
# Frame message format (Flutter → server):
#   { "frame": "<base64-encoded JPEG string>" }
#
# Result message format (server → Flutter):
#   { "ear": 0.28, "smoothed_ear": 0.27, "eye_closed": false,
#     "state": "Open", "is_drowsy": false, "closed_eye_frames": 0,
#     "total_frames": 45, "drowsiness_percentage": 0.0,
#     "status": "Awake", "blink_count": 3, "error": null }
#
# ==============================================================

import base64
import json
import sys
import os

import cv2
import numpy as np
import mediapipe as mp
import uvicorn
from fastapi import FastAPI, WebSocket, WebSocketDisconnect

# Add this directory to path so imports from config/, models/,
# and services/ resolve correctly when running from backend/
sys.path.insert(0, os.path.dirname(__file__))

from config.constants import HOST, PORT
from models.detection_result import DetectionResult
from services.drowsiness_logic import DrowsinessLogic

# ─────────────────────────────────────────────────────────────
# FastAPI app
# ─────────────────────────────────────────────────────────────

app = FastAPI(title="Drowsiness Detection Server")

# ─────────────────────────────────────────────────────────────
# MediaPipe Face Mesh — one shared instance (thread-safe for
# read-only inference; each WebSocket gets its own DrowsinessLogic)
# ─────────────────────────────────────────────────────────────

_mp_face_mesh = mp.solutions.face_mesh
_face_mesh = _mp_face_mesh.FaceMesh(
    static_image_mode=False,
    max_num_faces=1,
    refine_landmarks=True,
    min_detection_confidence=0.5,
    min_tracking_confidence=0.5,
)


def _decode_frame(base64_str: str) -> np.ndarray | None:
    """
    Decode a base64-encoded JPEG string into an OpenCV BGR image.

    Args:
        base64_str: Base64-encoded JPEG from the Flutter camera.

    Returns:
        numpy.ndarray (BGR image) or None if decoding fails.
    """
    try:
        img_bytes = base64.b64decode(base64_str)
        img_array = np.frombuffer(img_bytes, dtype=np.uint8)
        frame = cv2.imdecode(img_array, cv2.IMREAD_COLOR)
        return frame
    except Exception:
        return None


def _extract_landmarks(frame: np.ndarray) -> list | None:
    """
    Run MediaPipe face mesh on a BGR frame and return the first
    face's landmarks as a list of dicts with 'x', 'y', 'z' keys.

    Args:
        frame: OpenCV BGR image.

    Returns:
        list of 468 landmark dicts, or None if no face detected.
    """
    rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = _face_mesh.process(rgb)

    if not results.multi_face_landmarks:
        return None

    face = results.multi_face_landmarks[0]
    return [{"x": lm.x, "y": lm.y, "z": lm.z} for lm in face.landmark]


# ─────────────────────────────────────────────────────────────
# WebSocket endpoint
# ─────────────────────────────────────────────────────────────

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    """
    Main WebSocket handler for one Flutter client session.

    Each connection gets its own DrowsinessLogic instance so that
    per-session state (EAR buffer, blink count, sliding window)
    is isolated and resets cleanly on reconnect.

    Protocol:
      Receive: JSON  {"frame": "<base64 JPEG>"}
      Send:    JSON  DetectionResult.to_dict()
    """
    await websocket.accept()

    # Fresh detection engine for this session
    logic = DrowsinessLogic()

    try:
        while True:
            # ── Receive a frame message ───────────────────────
            raw_message = await websocket.receive_text()

            try:
                payload = json.loads(raw_message)
                base64_frame = payload.get("frame", "")
            except (json.JSONDecodeError, AttributeError):
                await websocket.send_json(
                    DetectionResult(error="invalid_message_format").to_dict()
                )
                continue

            # ── Decode the JPEG frame ─────────────────────────
            frame = _decode_frame(base64_frame)
            if frame is None:
                await websocket.send_json(
                    DetectionResult(error="frame_decode_failed").to_dict()
                )
                continue

            # ── Extract face landmarks ────────────────────────
            landmarks = _extract_landmarks(frame)
            if landmarks is None:
                await websocket.send_json(DetectionResult.no_face().to_dict())
                continue

            # ── Run drowsiness detection ──────────────────────
            result = logic.process_landmarks(landmarks)

            # ── Send result back to Flutter ───────────────────
            await websocket.send_json(result.to_dict())

    except WebSocketDisconnect:
        # Client disconnected cleanly — nothing to do
        pass


# ─────────────────────────────────────────────────────────────
# Entry point
# ─────────────────────────────────────────────────────────────

if __name__ == "__main__":
    uvicorn.run("main:app", host=HOST, port=PORT, reload=False)
