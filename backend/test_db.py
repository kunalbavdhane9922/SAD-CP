from pymongo import MongoClient
import sys

MONGO_URI = (
    "mongodb+srv://Sushant:XAWTYBB"
    "@cluster0.nel3fd9.mongodb.net/"
    "?retryWrites=true&w=majority&appName=Cluster0"
)

try:
    print("Attempting to connect to MongoDB as 'Sushant' with new password...")
    client = MongoClient(MONGO_URI, serverSelectionTimeoutMS=5000)
    client.admin.command("ping")
    print("SUCCESS: Connection successful!")
except Exception as e:
    print(f"ERROR: Connection failed: {e}")
    sys.exit(1)
