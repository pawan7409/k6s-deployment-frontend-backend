# Backend Development Guide

## Project Setup

### Prerequisites
- Python 3.11+
- pip

### Virtual Environment

```bash
python -m venv venv

# Activate
# Windows
venv\Scripts\activate

# Linux/Mac
source venv/bin/activate
```

### Installation

```bash
pip install -r requirements.txt
```

### Running the Server

```bash
python app.py
```

Server runs on `http://localhost:5000`

### Environment Configuration

Copy `.env.example` to `.env` and configure:

```bash
cp .env.example .env
```

## Project Structure

```
backend/
├── app.py                 # Flask application
├── config.py             # Configuration
├── azure_integration.py  # Azure services
├── requirements.txt      # Dependencies
└── .env.example         # Environment template
```

## API Endpoints

### Health Check
- `GET /health`
- Returns: `{ status: 'healthy', timestamp, service }`

### Get Data
- `GET /api/data`
- Returns: Application data and backend info

### Create Data
- `POST /api/data`
- Body: JSON object
- Returns: `{ message, timestamp, received_data }`

### Get Status
- `GET /api/status`
- Returns: `{ status, uptime, database, cache }`

### Process Data
- `POST /api/process`
- Body: JSON object to process
- Returns: `{ original, processed, timestamp }`

### Application Info
- `GET /api/info`
- Returns: Application metadata and endpoints

## Azure Integration

The `azure_integration.py` module provides:

- **Blob Storage**: Upload/download files
- **Key Vault**: Retrieve secrets
- **Managed Identity**: Automatic authentication

### Usage

```python
from azure_integration import AzureIntegration

azure = AzureIntegration()

# Get secret
secret = azure.get_secret('my-secret')

# Upload blob
azure.upload_blob('container', 'blob.txt', b'data')

# Download blob
data = azure.download_blob('container', 'blob.txt')
```

## Error Handling

API returns error responses:

```json
{
  "error": "Error type",
  "message": "Detailed message",
  "timestamp": "ISO timestamp"
}
```

Status codes:
- 200: Success
- 201: Created
- 400: Bad request
- 404: Not found
- 500: Server error

## Building Docker Image

```bash
docker build -t python-backend:latest .
docker run -p 5000:5000 python-backend:latest
```

## Testing

Create `test_app.py`:

```python
import pytest
from app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_health(client):
    response = client.get('/health')
    assert response.status_code == 200
    assert response.json['status'] == 'healthy'

def test_get_data(client):
    response = client.get('/api/data')
    assert response.status_code == 200
    assert 'message' in response.json
```

Run tests:
```bash
pip install pytest pytest-cov
pytest --cov=. --cov-report=html
```

## Dependencies

Key packages:
- **Flask**: Web framework
- **python-dotenv**: Environment variables
- **requests**: HTTP client
- **azure-identity**: Azure authentication
- **azure-storage-blob**: Blob storage
- **azure-keyvault-secrets**: Key Vault access

## Logging

Configure logging:

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

logger.info('Application started')
```

## Kubernetes Deployment

See main README.md for deployment instructions.

## Performance Tips

1. Use connection pooling for databases
2. Cache frequently accessed data
3. Implement request timeouts
4. Use async operations for long tasks
5. Monitor resource usage

## Security

1. Use environment variables for secrets
2. Validate all inputs
3. Use HTTPS in production
4. Implement rate limiting
5. Add authentication/authorization
6. Use CORS properly

## CORS Configuration

Currently enabled for all origins in development. For production:

```python
CORS(app, resources={
    r"/api/*": {"origins": ["https://yourdomain.com"]}
})
```

## Monitoring

Azure Application Insights automatically tracks:
- Request/response times
- Dependencies
- Exceptions
- Custom events

## Troubleshooting

### Import Errors
- Ensure virtual environment is activated
- Run `pip install -r requirements.txt`

### Port Already in Use
- Change port: `python app.py --port 5001`
- Or kill existing process on port 5000

### Azure Errors
- Check environment variables
- Verify Azure credentials
- Review Azure SDK documentation
