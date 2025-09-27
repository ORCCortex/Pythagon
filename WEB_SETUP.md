# Pythagon Web App Setup

This is the web version of the Pythagon Flutter project, converted to a standalone web application with Firebase authentication and backend API integration.

## Features

- 🔐 Firebase Authentication (Sign in/Sign up)
- 📤 PDF File Upload
- 🔍 Automatic Math Problem Detection
- 🧮 Step-by-step Math Problem Solving
- 📱 Responsive Design
- ⚡ Real-time Status Updates

## Setup Instructions

### 1. Firebase Configuration

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use existing "orccortex-543d1"
3. Enable Authentication with Email/Password
4. Update the Firebase config in `web/index.html` if needed

### 2. Backend Server

The web app expects a backend server running on `http://localhost:8000` with these endpoints:

#### Required API Endpoints:

- `POST /upload` - Upload PDF file
  - Headers: `Authorization: Bearer <firebase-token>`
  - Body: FormData with 'file' field
  - Returns: `{total_pages, problems[]}`

- `GET /problem/{problem_id}/status` - Get problem processing status
  - Headers: `Authorization: Bearer <firebase-token>`
  - Returns: `{id, status, extracted_text, math_expressions}`

- `POST /solve/{problem_id}` - Start solving a problem
  - Headers: `Authorization: Bearer <firebase-token>`
  - Returns: `{id, status}`

- `GET /solve/{solution_id}/status` - Get solution status
  - Headers: `Authorization: Bearer <firebase-token>`
  - Returns: `{status, math_expression, solution_steps, final_answer}`

#### Quick Backend Setup:

```bash
# Install dependencies
pip install fastapi uvicorn python-multipart firebase-admin

# Run the example backend
python backend_example.py
```

### 3. Web App Deployment

#### Option 1: Local Development
1. Open `web/index.html` directly in a browser
2. Or serve using a local server:
   ```bash
   cd web
   python -m http.server 3000
   ```

#### Option 2: Flutter Web Build
```bash
flutter build web --web-renderer html
flutter build web --release
```

#### Option 3: Deploy to Firebase Hosting
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login and initialize
firebase login
firebase init hosting

# Deploy
firebase deploy
```

### 4. Environment Variables

For production, consider using environment variables for:
- Firebase API key
- Backend API URL
- Other sensitive configuration

## API Integration

The web app uses the following API flow:

1. **Authentication**: User signs in with Firebase
2. **Upload**: PDF uploaded to `/upload` endpoint
3. **Processing**: App polls `/problem/{id}/status` for each page
4. **Solving**: When ready, calls `/solve/{problem_id}`
5. **Results**: Polls `/solve/{solution_id}/status` for results

## File Structure

```
web/
├── index.html          # Main web application
├── manifest.json       # PWA manifest
├── favicon.png         # App icon
├── icons/              # PWA icons
└── template.html       # Original template reference
```

## Customization

### Styling
- Main styles are in the `<style>` section of `index.html`
- Uses CSS Grid and Flexbox for responsive layout
- Color scheme based on the original template

### Authentication
- Currently uses Firebase Auth
- Easy to swap with other auth providers
- Auto-login demo credentials available in template

### Backend Integration
- Change API URLs in the fetch calls
- Modify authentication headers as needed
- Add error handling and retry logic

## Production Considerations

1. **Security**:
   - Use environment variables for API keys
   - Implement proper CORS policies
   - Add rate limiting

2. **Performance**:
   - Enable gzip compression
   - Use CDN for static assets
   - Implement caching strategies

3. **Monitoring**:
   - Add analytics tracking
   - Implement error logging
   - Monitor API performance

## Troubleshooting

### Common Issues:

1. **CORS Errors**: Ensure backend allows web app domain
2. **Auth Failures**: Check Firebase project configuration
3. **File Upload Issues**: Verify backend accepts FormData
4. **API Timeouts**: Implement retry logic for long operations

### Debug Mode:

Open browser console to see detailed logs and error messages.

## Contributing

1. Test authentication flow
2. Verify file upload works
3. Check responsive design on mobile
4. Test error handling scenarios
5. Validate API integration

## License

Same as the original Pythagon project.