# Backend API Example for Pythagon
# This is a reference implementation showing the expected endpoints
# You'll need to implement these endpoints in your actual backend server

from fastapi import FastAPI, UploadFile, File, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import firebase_admin
from firebase_admin import credentials, auth
import uuid
from typing import List, Optional
import json

app = FastAPI(title="Pythagon API", version="1.0.0")

# CORS middleware for web app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify your domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Firebase setup (you'll need to add your service account key)
# cred = credentials.Certificate("path/to/your/firebase-service-account-key.json")
# firebase_admin.initialize_app(cred)

security = HTTPBearer()

# Mock data storage (use a real database in production)
problems_db = {}
solutions_db = {}

async def verify_token(credentials: HTTPAuthorizationCredentials = Depends(security)):
    """Verify Firebase ID token"""
    try:
        # Uncomment when you have Firebase setup
        # decoded_token = auth.verify_id_token(credentials.credentials)
        # return decoded_token['uid']
        
        # Mock verification for testing
        return "mock_user_id"
    except Exception as e:
        raise HTTPException(status_code=401, detail="Invalid authentication token")

@app.post("/upload")
async def upload_pdf(
    file: UploadFile = File(...),
    user_id: str = Depends(verify_token)
):
    """
    Upload and process PDF file
    Expected behavior:
    1. Receive PDF file
    2. Extract text from each page
    3. Identify math expressions
    4. Return problem objects with status 'processing' or 'completed'
    """
    if file.content_type != "application/pdf":
        raise HTTPException(status_code=400, detail="File must be a PDF")
    
    # Mock processing - replace with your actual PDF processing logic
    file_content = await file.read()
    
    # Simulate processing multiple pages
    mock_problems = []
    total_pages = 3  # This would be determined by actual PDF analysis
    
    for page_num in range(1, total_pages + 1):
        problem_id = str(uuid.uuid4())
        problem = {
            "id": problem_id,
            "page_number": page_num,
            "status": "completed",  # or "processing"
            "extracted_text": f"Sample math problem text from page {page_num}:\n2x + 5 = 15\nSolve for x.",
            "math_expressions": [f"2x + 5 = 15", f"x = ?"]
        }
        problems_db[problem_id] = problem
        mock_problems.append(problem)
    
    return {
        "message": "PDF uploaded successfully",
        "total_pages": total_pages,
        "problems": mock_problems
    }

@app.get("/problem/{problem_id}/status")
async def get_problem_status(
    problem_id: str,
    user_id: str = Depends(verify_token)
):
    """Get processing status of a specific problem"""
    if problem_id not in problems_db:
        raise HTTPException(status_code=404, detail="Problem not found")
    
    return problems_db[problem_id]

@app.post("/solve/{problem_id}")
async def solve_problem(
    problem_id: str,
    user_id: str = Depends(verify_token)
):
    """
    Start solving a math problem
    Returns a solution ID for status tracking
    """
    if problem_id not in problems_db:
        raise HTTPException(status_code=404, detail="Problem not found")
    
    problem = problems_db[problem_id]
    if problem["status"] != "completed":
        raise HTTPException(status_code=400, detail="Problem not ready for solving")
    
    solution_id = str(uuid.uuid4())
    solution = {
        "id": solution_id,
        "problem_id": problem_id,
        "status": "solving",
        "math_expression": None,
        "solution_steps": None,
        "final_answer": None
    }
    
    solutions_db[solution_id] = solution
    
    # Simulate async solving process
    # In real implementation, this would trigger your math solving algorithm
    
    return {"id": solution_id, "status": "solving"}

@app.get("/solve/{solution_id}/status")
async def get_solution_status(
    solution_id: str,
    user_id: str = Depends(verify_token)
):
    """Get status of a solution in progress"""
    if solution_id not in solutions_db:
        raise HTTPException(status_code=404, detail="Solution not found")
    
    solution = solutions_db[solution_id]
    
    # Mock completion for demo - replace with actual logic
    if solution["status"] == "solving":
        solution.update({
            "status": "completed",
            "math_expression": "2x + 5 = 15",
            "solution_steps": {
                "step1": "2x + 5 = 15",
                "step2": "2x = 15 - 5",
                "step3": "2x = 10",
                "step4": "x = 10/2",
                "step5": "x = 5"
            },
            "final_answer": "x = 5"
        })
    
    return solution

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "service": "Pythagon API"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)

# To run this server:
# pip install fastapi uvicorn python-multipart firebase-admin
# uvicorn backend_example:app --reload --host 0.0.0.0 --port 8000