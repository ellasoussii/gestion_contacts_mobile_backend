from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import User
from schemas import UserCreate, UserLogin, UserOut

router = APIRouter(prefix="/users", tags=["Users"])

@router.post("", response_model=UserOut)
def add_user(data: UserCreate, db: Session = Depends(get_db)):
    # Vérifier si email existe déjà
    existing = db.query(User).filter(User.email == data.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Cet email existe déjà.")
    new_user = User(name=data.name, email=data.email, password=data.password)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

@router.post("/login", response_model=UserOut)
def login(data: UserLogin, db: Session = Depends(get_db)):
    user = db.query(User).filter(
        User.email == data.email,
        User.password == data.password
    ).first()
    if not user:
        raise HTTPException(status_code=401, detail="Email ou mot de passe incorrect.")
    return user
