from pydantic import BaseModel
# Users
class UserCreate(BaseModel):
    name: str
    email: str
    password: str

class UserLogin(BaseModel):
    email: str
    password: str

class UserOut(BaseModel):
    id: int
    name: str
    email: str

    class Config:
        orm_mode = True

# Contacts
class ContactCreate(BaseModel):
    user_id: int
    name: str
    surname: str | None = None
    phone: str
    birthdate: str | None = None
    photo: str | None = None

class ContactOut(BaseModel):
    id: int
    user_id: int
    name: str
    surname: str | None
    phone: str
    birthdate: str | None
    photo: str | None

    class Config:
        orm_mode = True
