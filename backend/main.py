from fastapi import FastAPI
from routes import users, contacts
from models import Base
from database import engine

app = FastAPI(title="Contacts API")

# Créer les tables si elles n'existent pas
Base.metadata.create_all(bind=engine)

app.include_router(users.router)
app.include_router(contacts.router)
