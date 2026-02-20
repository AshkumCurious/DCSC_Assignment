# Shipment Tracking API

A FastAPI backend for managing and tracking shipments with full CRUD support, pagination, and Swagger documentation.

---

## Project Structure

```
shipment-api/
├── main.py          # FastAPI app and route handlers
├── database.py      # DB connection and session management
├── models.py        # SQLAlchemy ORM models
├── schemas.py       # Pydantic request/response schemas
├── requirements.txt # Python dependencies
└── README.md
```

---

## Setup & Run

### 1. Install dependencies

```bash
pip install -r requirements.txt
```

### 2. Configure Database

**SQLite (default, no setup needed):**
The app uses SQLite out of the box. The database file `shipments.db` is auto-created.

**PostgreSQL:**
Update `DATABASE_URL` in `database.py`:
```python
DATABASE_URL = "postgresql://user:password@localhost:5432/shipments_db"
```
Also remove the `connect_args={"check_same_thread": False}` line (SQLite-only).

### 3. Run the server

```bash
uvicorn main:app --reload
```

Server runs at: `http://localhost:8000`

---

## API Documentation

FastAPI auto-generates interactive docs:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

---

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/shipments` | Create a new shipment |
| GET | `/shipments` | List all shipments (paginated) |
| GET | `/shipments/{tracking_id}` | Get shipment details |
| PUT | `/shipments/{tracking_id}/status` | Update shipment status |
| DELETE | `/shipments/{tracking_id}` | Delete a shipment |

### Pagination

`GET /shipments?page=1&page_size=10`

### Valid Statuses

- `Pending`
- `In Transit`
- `Out for Delivery`
- `Delivered`

---

## Example Requests

### Create a shipment
```bash
curl -X POST http://localhost:8000/shipments \
  -H "Content-Type: application/json" \
  -d '{
    "tracking_id": "DCSC001",
    "customer_name": "John Doe",
    "customer_phone": "+1234567890",
    "pickup_address": "123 Main St, New York, NY",
    "delivery_address": "456 Oak Ave, Boston, MA",
    "status": "Pending"
  }'
```

### Update status
```bash
curl -X PUT http://localhost:8000/shipments/DCSC001/status \
  -H "Content-Type: application/json" \
  -d '{"status": "In Transit"}'
```

### List shipments (page 2)
```bash
curl "http://localhost:8000/shipments?page=2&page_size=5"
```

---

## HTTP Status Codes

| Code | Meaning |
|------|---------|
| 200 | OK |
| 201 | Created |
| 404 | Shipment not found |
| 422 | Validation error / duplicate tracking ID |