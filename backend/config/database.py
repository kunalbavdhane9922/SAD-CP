# ==============================================================
# DATABASE — MongoDB Atlas Connection
# ==============================================================
# Connects to MongoDB Atlas cluster using pymongo.
# Provides collection handles for users and drive sessions.
# ==============================================================

from pymongo import MongoClient
import logging

logger = logging.getLogger(__name__)

# MongoDB Atlas connection string (Updated with user 'Sushant' and new password)
MONGO_URI = (
    "mongodb+srv://Sushant:XAWTYBB"
    "@cluster0.nel3fd9.mongodb.net/"
    "?retryWrites=true&w=majority&appName=Cluster0"
)

# Database name
DB_NAME = "drowsiguard"

# Create MongoDB client
try:
    client = MongoClient(MONGO_URI, serverSelectionTimeoutMS=5000)
    # Test connection
    client.admin.command("ping")
    logger.info("✅ Connected to MongoDB Atlas successfully!")
except Exception as e:
    logger.error(f"❌ Failed to connect to MongoDB: {e}")
    client = None

# Get database reference
db = client[DB_NAME] if client else None

# ── Collection References ──
# Users collection: stores user profiles and credentials
users_collection = db["users"] if db is not None else None

# Drive sessions collection: stores driving session history
sessions_collection = db["drive_sessions"] if db is not None else None
