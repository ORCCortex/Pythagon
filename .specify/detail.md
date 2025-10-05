
# ORCCortex - OCR Math Solver

A powerful Python-based OCR math solver application with FastAPI backend and Firebase integration. This application can extract mathematical expressions from PDF documents and solve them automatically using advanced OCR and symbolic math capabilities.

![ORCCortex](./image.png)

## Features

- **PDF Upload & Processing**: Upload PDF files containing mathematical problems
- **OCR Text Extraction**: Extract text and mathematical expressions using multiple OCR engines
- **Math Problem Solving**: Solve mathematical expressions using SymPy
- **Firebase Integration**: Authentication and cloud storage support
- **RESTful API**: Clean REST API with comprehensive documentation
- **Background Processing**: Asynchronous processing of uploads and solutions
- **User Authentication**: Secure user management with Firebase Auth

## Architecture

```
app/
├── routers/           # API endpoints
│   ├── upload.py      # PDF upload handling
│   ├── problems.py    # Problem management
│   └── solve.py       # Math solving endpoints
├── services/          # Business logic
│   ├── firebase_service.py    # Firebase integration
│   ├── ocr_service.py         # OCR processing
│   └── math_service.py        # Math solving
├── models/            # Data models
│   ├── user.py        # User models
│   ├── problem.py     # Problem models
│   └── solution.py    # Solution models
└── utils/             # Utilities
    ├── config.py      # Configuration
    └── exceptions.py  # Custom exceptions
```

## API Endpoints

### Upload

- `POST /api/v1/upload` - Upload PDF file for processing
- `GET /api/v1/upload/status/{problem_id}` - Check processing status

### Problems

- `GET /api/v1/problems/{user_id}` - Get user's problems
- `GET /api/v1/problems/{user_id}/{problem_id}` - Get specific problem details
- `DELETE /api/v1/problems/{user_id}/{problem_id}` - Delete a problem

### Solve

- `POST /api/v1/solve/{problem_id}` - Solve math problems from a PDF
- `POST /api/v1/solve/expression` - Solve a single math expression
- `GET /api/v1/solve/{problem_id}/solutions` - Get problem solutions
- `GET /api/v1/solve/solution/{solution_id}` - Get solution details