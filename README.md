# DrowsiGuard — Real-Time Driver Drowsiness Detection System

A comprehensive mobile and backend solution for detecting driver drowsiness in real-time using computer vision and machine learning. The system combines a Flutter mobile app with a FastAPI backend to provide live monitoring, alerts, and safety notifications.

**Current Status**: Release v1.0.0 (Active Development)  
**Repository**: [kunalbavdhane9922/SAD-CP](https://github.com/kunalbavdhane9922/SAD-CP)  
**Primary Branch**: `release/v1.0.0`

---

## Project Overview

DrowsiGuard is a real-time driver monitoring system designed to detect and alert drivers when drowsiness is detected while driving. The system uses the device's front-facing camera to analyze eye aspect ratio (EAR), detect eye closures, and classify drowsiness states through a sophisticated state machine.

### Key Features

- **Real-Time Detection**: Continuous camera-based monitoring at ~5 FPS
- **Multi-Alert System**: Sound alarms (looping audio) + vibration patterns for immediate driver feedback
- **WebSocket Communication**: Live streaming of camera frames to backend for low-latency processing
- **Advanced Algorithm**: Eye Aspect Ratio (EAR) calculation with state machine-based blink filtering
- **Connection Status Monitoring**: Real-time indicator of backend connectivity
- **User Profile Management**: Store and manage driver information (name, email, vehicle details, emergency contacts)
- **Settings Panel**: Configure alert preferences, sensitivity levels, and server endpoints

---

## Architecture

### System Architecture Overview

```
┌─────────────────────────────────────┐
│       Flutter Mobile App (lib/)      │
│  ┌─────────────────────────────────┐ │
│  │    Detection Screen             │ │
│  │  (Camera Preview + Live Results)│ │
│  └─────────────────────────────────┘ │
│  ┌─────────────────────────────────┐ │
│  │    Services Layer               │ │
│  │  • Camera Service               │ │
│  │  • WebSocket Service            │ │
│  │  • Alert Service (Audio/Haptic) │ │
│  │  • App Settings (Singleton)     │ │
│  └─────────────────────────────────┘ │
└─────────────────────────────────────┘
                  │
        WebSocket (JSON + base64)
                  │
                  ▼
┌─────────────────────────────────────┐
│   FastAPI Backend (backend/)        │
│  ┌─────────────────────────────────┐ │
│  │    WebSocket Endpoint (/ws)     │ │
│  │  • Receives base64 frames       │ │
│  │  • Processes with MediaPipe     │ │
│  │  • Runs drowsiness logic        │ │
│  │  • Returns JSON results         │ │
│  └─────────────────────────────────┘ │
│  ┌─────────────────────────────────┐ │
│  │    Drowsiness Detection Engine  │ │
│  │  • EAR Calculator               │ │
│  │  • Eye State Tracker            │ │
│  │  • State Machine (5 states)     │ │
│  └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

### Data Flow

1. **Capture**: Flutter camera service captures frames at ~5 FPS (200ms interval)
2. **Encode**: Frames converted to base64-encoded JPEG format
3. **Transmit**: WebSocket sends JSON message: `{"frame": "<base64_data>"}`
4. **Process**: Backend decodes frame, extracts facial landmarks via MediaPipe
5. **Analyze**: Drowsiness engine calculates EAR and determines drowsiness state
6. **Respond**: Backend returns detection result (EAR, status, %, blink count, etc.)
7. **Alert**: Frontend plays audio/vibration if drowsy state detected

---

## Tech Stack

### Frontend (Flutter)

- **Framework**: Flutter 3.x
- **Language**: Dart
- **Key Packages**:
  - `camera` (0.11.4) — Front camera access and preview
  - `web_socket_channel` (3.0.2) — WebSocket client
  - `audioplayers` (6.1.0) — Audio alerts
  - `vibration` (2.1.0) — Haptic feedback
  - `flutter_lints` — Code quality & linting

### Backend (Python)

- **Framework**: FastAPI
- **Server**: Uvicorn
- **ML/CV**: MediaPipe (face mesh detection)
- **Dependencies**:
  - `mediapipe` — Face landmark detection
  - `opencv-python-headless` — Image processing
  - `numpy` — Numerical computations
  - `pydantic` — Data validation

### Deployment

- **Mobile**: Android (API 21+), iOS (12+), Web, Linux, macOS, Windows
- **Backend**: FastAPI on Uvicorn (can run on any Python 3.8+ environment)

---

## Project Structure

```
drowsiness_detection/
│
├── lib/                                 # Flutter Frontend
│   ├── main.dart                        # App entry point & Material theme
│   │
│   ├── models/
│   │   ├── user_model.dart              # User data (name, email, vehicle info)
│   │   └── detection_result_model.dart  # WebSocket response model (EAR, status, %)
│   │
│   ├── screens/
│   │   ├── login_page.dart              # Authentication (mock, ready for MongoDB)
│   │   ├── home_page.dart               # Dashboard hub (2×3 feature grid)
│   │   ├── detection_screen.dart        # Live monitoring UI (camera + results)
│   │   ├── profile_page.dart            # User profile display
│   │   ├── edit_profile_page.dart       # Profile edit form
│   │   ├── settings_page.dart           # App settings (alerts, sensitivity)
│   │   └── placeholder_page.dart        # Coming-soon pages
│   │
│   ├── services/
│   │   ├── camera_service.dart          # Camera lifecycle & frame capture
│   │   ├── websocket_service.dart       # WebSocket client (singleton)
│   │   ├── alert_service.dart           # Audio alarms + vibration (singleton)
│   │   └── app_settings.dart            # Global settings singleton
│   │
│   ├── widgets/
│   │   └── home_option_card.dart        # Reusable dashboard card
│   │
│   └── assets/
│       └── alarm.mp3                    # Alert sound (looping)
│
├── backend/                             # FastAPI Backend
│   ├── main.py                          # FastAPI app & WebSocket endpoint
│   │
│   ├── services/
│   │   └── drowsiness_logic.py          # Core detection engine
│   │       ├── EARCalculator            # Stateless EAR math
│   │       ├── EyeStateTracker          # State machine (5 states)
│   │       └── DrowsinessLogic          # Orchestrator
│   │
│   ├── models/
│   │   └── detection_result.py          # DetectionResult dataclass
│   │
│   ├── config/
│   │   └── constants.py                 # All tunable parameters
│   │
│   └── requirements.txt                 # Python dependencies
│
├── android/                             # Android build config
├── ios/                                 # iOS build config
├── web/                                 # Web build
├── linux/, macos/, windows/             # Desktop builds
│
├── pubspec.yaml                         # Flutter dependencies
├── analysis_options.yaml                # Dart linter config
└── README.md                            # This file
```

---

## Getting Started

### Prerequisites

- **Flutter**: 3.0+ ([Install Flutter](https://flutter.dev/docs/get-started/install))
- **Python**: 3.8+ ([Install Python](https://www.python.org/downloads/))
- **Android SDK** or **Xcode** (for mobile builds)
- **Git**: For version control

### Backend Setup

1. **Navigate to backend folder**:

   ```bash
   cd backend
   ```

2. **Create a Python virtual environment**:

   ```bash
   python -m venv venv
   source venv/bin/activate    # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**:

   ```bash
   pip install -r requirements.txt
   ```

4. **Run the backend server**:
   ```bash
   python main.py
   ```

   - Server starts on `http://0.0.0.0:8000`
   - WebSocket available at `ws://0.0.0.0:8000/ws`
   - API docs at `http://localhost:8000/docs` (Swagger UI)

### Frontend Setup

1. **Navigate to project root**:

   ```bash
   cd ..
   ```

2. **Get Flutter dependencies**:

   ```bash
   flutter pub get
   ```

3. **Run on Android**:

   ```bash
   flutter run
   ```

   Or on a specific device:

   ```bash
   flutter run -d <device_id>
   ```

4. **Build APK**:
   ```bash
   flutter build apk --release
   ```

---

## Usage

### Running the App

1. **Start the backend** (Python FastAPI server running on your machine or accessible IP)
2. **Launch the Flutter app** on your Android device or emulator
3. **Login** with demo credentials:
   - Email: `test@email.com`
   - Password: `123456`
4. **Navigate to "Start Detection"** from the home dashboard
5. **Tap "Start Monitoring"** to begin real-time detection
6. **Connect to backend** by entering server IP (default: `10.85.124.202:8000`)

### Key Screens

#### Home Page

- 6-card grid dashboard:
  - Start Detection → Live monitoring screen
  - Drive History → Placeholder (ready for implementation)
  - Live Alerts → Placeholder
  - Profile → User profile management
  - Settings → Configure app behavior
  - Help & Support → Placeholder

#### Detection Screen

- **Live Camera Preview**: Real-time video feed from front camera
- **Status Indicators**: Connection state (dot color), EAR value, drowsiness percentage
- **Control Buttons**: Start/Stop/Reset monitoring
- **Alerts**: Visual pulsing for drowsy state, audio + vibration notifications
- **Results Display**: Current state (Awake/Warning/Drowsy), blink count, closed eye frames

#### Settings

- **Sound Alerts**: Enable/disable looping alarm
- **Vibration**: Toggle haptic feedback
- **Sensitivity**: Select Low/Medium/High detection thresholds
- **Dark Mode**: UI theme toggle (placeholder)

---

## Drowsiness Detection Algorithm

### Eye Aspect Ratio (EAR)

The system calculates EAR from facial landmarks detected by MediaPipe:

```
EAR = ||p2 - p6|| + ||p3 - p5|| / (2 × ||p1 - p4||)
```

Where p1-p6 are eye landmark coordinates. EAR drops below ~0.21 when eyes close.

### State Machine (5 States)

1. **Open** — Eyes open, EAR above threshold
2. **Closing** — Transitional state, EAR declining
3. **Closed** — Eyes closed, EAR below threshold
4. **Reopening** — Transitional state, EAR rising
5. **Blink Detected** — Normal blink (filtered out, not counted as drowsy)

### Drowsiness Classification

- **Awake**: Drowsiness % = 0–30% (mostly open eyes, occasional blinks)
- **Warning**: Drowsiness % = 30–60% (frequent eye closures, slower blinks)
- **Drowsy**: Drowsiness % = 60%+ (prolonged eye closure, imminent risk)

### Key Parameters (Tuned for 5 FPS)

| Parameter                | Value | Purpose                                 |
| ------------------------ | ----- | --------------------------------------- |
| EAR_THRESHOLD            | 0.21  | Eye closure detection cutoff            |
| EAR_SMOOTHING_WINDOW     | 3     | Reduce noise with moving average        |
| BLINK_MAX_FRAMES         | 2     | Normal blink duration (~400ms at 5 FPS) |
| DROWSY_MIN_CLOSED_FRAMES | 4     | Drowsy threshold (~800ms)               |
| SLIDING_WINDOW_SIZE      | 15    | History for drowsiness % (~3 seconds)   |

---

## API Contract

### WebSocket Endpoint: `/ws`

#### Client → Server (Frame Request)

```json
{
  "frame": "base64_encoded_jpeg_image"
}
```

#### Server → Client (Detection Result)

```json
{
  "ear": 0.24,
  "smoothed_ear": 0.239,
  "eye_closed": false,
  "state": "Open",
  "is_drowsy": false,
  "closed_eye_frames": 0,
  "total_frames": 142,
  "drowsiness_percentage": 15.5,
  "status": "Awake",
  "blink_count": 8,
  "error": null
}
```

#### Error Response (No Face Detected)

```json
{
  "error": "No face detected",
  "status": "Warning",
  "state": "Unknown",
  "drowsiness_percentage": 0,
  "ear": 0
}
```

---

## Configuration & Tuning

### Adjusting Sensitivity

Edit `backend/config/constants.py`:

```python
# Lower = more sensitive, faster detection
EAR_THRESHOLD = 0.21

# Higher = smoother, less reaction noise
EAR_SMOOTHING_WINDOW = 3

# Lower = shorter blink tolerance
BLINK_MAX_FRAMES = 2

# Lower = faster drowsy classification
DROWSY_MIN_CLOSED_FRAMES = 4
```

### Camera Resolution

Edit `lib/services/camera_service.dart`:

```dart
ResolutionPreset.low,    # Current (smaller payload, faster)
// ResolutionPreset.medium,  # Higher quality (larger payload)
// ResolutionPreset.high,    # Best quality (slowest)
```

---

## Known Issues & TODOs

### Production Gaps

- [ ] **Authentication**: Currently mock-based; ready for MongoDB integration
- [ ] **Data Persistence**: User profiles not saved to database
- [ ] **Auto-Reconnect**: WebSocket doesn't auto-reconnect on network loss
- [ ] **Multi-User Backend**: Global `drowsiness_engine` not thread-safe
- [ ] **Frame Validation**: No confidence filtering for low-quality landmarks
- [ ] **Error Recovery**: User must manually restart detection after disconnect

### Feature Placeholders

- [ ] **Drive History**: UI ready, backend logging not implemented
- [ ] **Dark Mode**: Toggle exists, theme switching not wired
- [ ] **Forgot Password**: LoginPage placeholder
- [ ] **Analytics Dashboard**: For fleet management (future)

### Code Quality

- [ ] Add unit/widget tests (test/widget_test.dart is empty)
- [ ] Implement proper signing config for Android release builds
- [ ] Network resilience (frame skipping, compression for slow connections)
- [ ] Logging and crash reporting

---

## Recent Changes (v1.0.0)

### Commit History

1. **364ecf9** — `fix(lib): resolve analyzer issues and modernize deprecated APIs`
   - Replaced deprecated `withOpacity()` with `withValues(alpha: ...)`
   - Fixed `activeColor` → `activeThumbColor` for Switch widget
   - Removed unused fields/methods in HomePage
   - Converted dangling doc comments to regular comments
   - Result: **0 analyzer issues in lib/**

2. **ebd9bd9** — `feat(backend): optimize drowsiness detection constants and frame processing for 5 FPS camera stream`
   - Tuned all constants for 5 FPS (lowered thresholds and window sizes)
   - Updated comments to reflect 5 FPS timing
   - Improved frame capture robustness with `_isCapturing` flag
   - Enhanced error handling in WebSocket with try-catch blocks
   - Added comprehensive logging for debugging

---

## Contributing

### Development Workflow

1. **Create a feature branch** from `release/v1.0.0`:

   ```bash
   git checkout release/v1.0.0
   git checkout -b feature/your-feature-name
   ```

2. **Make changes** and test locally

3. **Commit with clear messages**:

   ```bash
   git commit -m "feat(component): short description"
   git commit -m "fix(lib): issue description"
   git commit -m "docs: update documentation"
   ```

4. **Push and create a Pull Request** to `release/v1.0.0`

### Code Style

- **Dart/Flutter**: Follow `flutter_lints` rules (run `flutter analyze`)
- **Python**: Follow PEP 8 (use `black` or `pylint` for formatting)
- **Comments**: Inline comments for complex logic; doc comments for public APIs

---

## Testing

### Manual Testing Checklist

- [ ] App launches without errors
- [ ] Camera preview displays on DetectionScreen
- [ ] WebSocket connects to backend
- [ ] Detection results update in real-time
- [ ] Audio alert plays when drowsy
- [ ] Vibration triggers on alert
- [ ] Settings toggle alerts on/off
- [ ] Profile displays user info
- [ ] App handles disconnects gracefully

### Backend Testing

```bash
# Test WebSocket endpoint with curl or wscat
wscat -c ws://localhost:8000/ws

# Swagger UI for endpoint documentation
http://localhost:8000/docs
```

---

## Security & Privacy

**Current Status**: Development/Testing Only

- **No Data Encryption**: WebSocket frames sent unencrypted
- **Local Storage**: No sensitive data persisted to device
- **Camera Permissions**: Requested at app startup
- **Backend Access**: Currently open (no authentication)

**Production Recommendations**:

- Use `wss://` (WebSocket Secure) for encrypted communication
- Implement JWT-based authentication
- Add rate limiting and DDoS protection
- Encrypt stored user data
- Regular security audits

---

## Support & Contact

- **Issues**: Report bugs on [GitHub Issues](https://github.com/kunalbavdhane9922/SAD-CP/issues)
- **Repository**: [kunalbavdhane9922/SAD-CP](https://github.com/kunalbavdhane9922/SAD-CP)
- **Branch**: `release/v1.0.0` (primary development branch)

---

## License

[Add License Info Here]

---

## Future Roadmap

- **v1.1.0**: MongoDB integration for user profiles and drive history
- **v1.2.0**: Multi-user backend with thread-safe engine
- **v1.3.0**: Analytics dashboard and fleet management
- **v2.0.0**: ML model improvements, multi-face detection, offline mode

---

**Last Updated**: April 27, 2026  
**Current Release**: v1.0.0 (release/v1.0.0)
