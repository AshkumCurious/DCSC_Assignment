from pydantic import BaseModel, field_validator
from typing import List, Optional
from datetime import datetime
from enum import Enum


class ShipmentStatus(str, Enum):
    pending = "Pending"
    in_transit = "In Transit"
    out_for_delivery = "Out for Delivery"
    delivered = "Delivered"

class StatusUpdateResponse(BaseModel):
    tracking_id: str
    status: str
    updated_at: Optional[datetime]

class ShipmentCreate(BaseModel):
    customer_name: str
    customer_phone: str
    pickup_address: str
    delivery_address: str

    @field_validator("customer_name")
    @classmethod
    def customer_name_must_not_be_empty(cls, v):
        if not v.strip():
            raise ValueError("customer name must not be empty")
        return v.strip()
    
    @field_validator("customer_phone")
    @classmethod
    def customer_number_must_be_valid(cls, v):
        v = v.strip()
        if not v:
          raise ValueError("customer phone must not be empty")
        if not v.isdigit():
          raise ValueError("customer phone must contain digits only")
        if len(v) != 10:
          raise ValueError("customer phone must be exactly 10 digits")
        return v


class StatusUpdate(BaseModel):
    status: ShipmentStatus


class ShipmentResponse(BaseModel):
    id: int
    tracking_id: str
    customer_name: str
    customer_phone: str
    pickup_address: str
    delivery_address: str
    status: str
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    model_config = {"from_attributes": True}


class PaginatedShipments(BaseModel):
    total: int
    page: int
    page_size: int
    total_pages: int
    shipments: List[ShipmentResponse]