from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import Contact
from schemas import ContactCreate, ContactOut

router = APIRouter(prefix="/contacts", tags=["Contacts"])

@router.get("/{user_id}", response_model=list[ContactOut])
def get_contacts(user_id: int, db: Session = Depends(get_db)):
    return db.query(Contact).filter(Contact.user_id == user_id).all()

@router.post("", response_model=ContactOut)
def add_contact(data: ContactCreate, db: Session = Depends(get_db)):
    new_contact = Contact(**data.dict())
    db.add(new_contact)
    db.commit()
    db.refresh(new_contact)
    return new_contact

@router.put("/{contact_id}", response_model=ContactOut)
def update_contact(contact_id: int, data: ContactCreate, db: Session = Depends(get_db)):
    contact = db.query(Contact).filter(Contact.id == contact_id).first()
    if not contact:
        raise HTTPException(status_code=404, detail="Contact introuvable.")
    for k, v in data.dict().items():
        setattr(contact, k, v)
    db.commit()
    db.refresh(contact)
    return contact

@router.delete("/{contact_id}")
def delete_contact(contact_id: int, db: Session = Depends(get_db)):
    contact = db.query(Contact).filter(Contact.id == contact_id).first()
    if not contact:
        raise HTTPException(status_code=404, detail="Contact introuvable.")
    db.delete(contact)
    db.commit()
    return {"message": "Contact supprimé"}
