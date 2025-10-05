# Quick Start Guide - ORCCortex Flutter App

## 🚀 Quick Setup (5 minutes)

### Step 1: Install Dependencies
```bash
flutter pub get
```

### Step 2: Configure Backend URL

Open `lib/utils/app_config.dart` and update line 4:

```dart
static const String apiBaseUrl = 'http://YOUR_BACKEND_URL/api/v1';
```

**Choose based on your test device:**
- iOS Simulator: `http://localhost:8000/api/v1`
- Android Emulator: `http://10.0.2.2:8000/api/v1`  
- Real Device: `http://192.168.1.XXX:8000/api/v1` (your computer's IP)

### Step 3: Start Backend Server

In a separate terminal, start your FastAPI backend:
```bash
cd backend_directory
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Step 4: Run the App
```bash
flutter run
```

## 📱 Basic Usage

1. **Upload PDF**: Tap the red PDF button → Select PDF → Wait for processing
2. **View Results**: Tap on any problem card to see extracted text and math
3. **Solve**: Tap "Solve Problem" button to get step-by-step solutions
4. **Delete**: Swipe or tap delete icon to remove problems

## 🔧 Common Issues

### Can't connect to backend?
- Check if backend is running: `curl http://localhost:8000/docs`
- Android emulator? Use `10.0.2.2` instead of `localhost`
- Real device? Backend must use `--host 0.0.0.0`

### PDF upload fails?
- Check file size (max 50MB)
- Verify backend is accessible
- Check terminal logs for errors

## 📝 Testing Without Backend

The app requires a backend. To test the UI only:
1. Comment out API calls in `lib/services/problem_service.dart`
2. Add mock data directly to `_problems` list
3. Run the app to see UI/UX

## 🎯 Next Steps

- Read `FLUTTER_SETUP.md` for detailed documentation
- See `detail.md` for backend API specifications
- Check `backend_example.py` for backend implementation

## 💡 Tips

- Keep backend terminal open while using the app
- Check "Processing" → "Completed" status before solving
- Use refresh icon to reload problems from server
- Solutions appear after tapping "Solve Problem" button
