from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.sql import func
from database import Base
import uuid


def generate_tracking_id():
    return f"DCSC{uuid.uuid4().hex[:6].upper()}"

class Shipment(Base):
    __tablename__ = "shipments"

    

    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    tracking_id = Column(String, unique=True, index=True, nullable=False, default=generate_tracking_id,)
    customer_name = Column(String, nullable=False)
    customer_phone = Column(String, nullable=False)
    pickup_address = Column(String, nullable=False)
    delivery_address = Column(String, nullable=False)
    status = Column(String, default="Pending", nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())