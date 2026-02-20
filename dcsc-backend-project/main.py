from fastapi import FastAPI, HTTPException, Depends, Query
from sqlalchemy.orm import Session
from typing import List, Optional
import math
import uuid

from database import get_db, engine
import models
import schema

models.Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="DCSC Shipment Tracking API",
    description="API for managing and tracking shipments",
    version="1.0.0"
)


@app.post("/shipments", response_model=schema.ShipmentResponse, status_code=201)
def create_shipment(shipment: schema.ShipmentCreate, db: Session = Depends(get_db)):
    """Create a new shipment."""
    db_shipment = models.Shipment(
    **shipment.model_dump(exclude={"status"}),
    status=schema.ShipmentStatus.pending
    )
    db.add(db_shipment)
    db.commit()
    db.refresh(db_shipment)
    return db_shipment


@app.get("/shipments", response_model=schema.PaginatedShipments)
def list_shipments(
    page: int = Query(1, ge=1, description="Page number"),
    page_size: int = Query(10, ge=1, le=100, description="Items per page"),
    db: Session = Depends(get_db)
):
    """List all shipments with pagination."""
    total = db.query(models.Shipment).count()
    offset = (page - 1) * page_size
    shipments = db.query(models.Shipment).offset(offset).limit(page_size).all()

    return {
        "total": total,
        "page": page,
        "page_size": page_size,
        "total_pages": math.ceil(total / page_size) if total > 0 else 0,
        "shipments": shipments
    }


@app.get("/shipments/{tracking_id}", response_model=schema.ShipmentResponse)
def get_shipment(tracking_id: str, db: Session = Depends(get_db)):
    """Get details of a specific shipment by tracking ID."""
    shipment = db.query(models.Shipment).filter(
        models.Shipment.tracking_id == tracking_id
    ).first()
    if not shipment:
        raise HTTPException(status_code=404, detail=f"Shipment with tracking ID '{tracking_id}' not found.")
    return shipment


@app.put("/shipments/{tracking_id}/status", response_model=schema.StatusUpdateResponse)
def update_shipment_status(
    tracking_id: str,
    status_update: schema.StatusUpdate,
    db: Session = Depends(get_db)
):
    """Update the status of a shipment."""
    shipment = db.query(models.Shipment).filter(
        models.Shipment.tracking_id == tracking_id
    ).first()
    if not shipment:
        raise HTTPException(status_code=404, detail=f"Shipment with tracking ID '{tracking_id}' not found.")

    shipment.status = status_update.status
    db.commit()
    db.refresh(shipment)
    return shipment


@app.delete("/shipments/{tracking_id}", status_code=200)
def delete_shipment(tracking_id: str, db: Session = Depends(get_db)):
    """Delete a shipment by tracking ID."""
    shipment = db.query(models.Shipment).filter(
        models.Shipment.tracking_id == tracking_id
    ).first()
    if not shipment:
        raise HTTPException(status_code=404, detail=f"Shipment with tracking ID '{tracking_id}' not found.")

    db.delete(shipment)
    db.commit()
    return {"message": f"Shipment '{tracking_id}' deleted successfully."}