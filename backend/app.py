from flask import Flask, jsonify, request
from flask_cors import CORS
from datetime import datetime
import os

app = Flask(__name__)

# Enable CORS for all routes
try:
    from flask_cors import CORS
    CORS(app)
except ImportError:
    print("flask-cors not installed, CORS may not work")

# Configuration
app.config['JSON_SORT_KEYS'] = False
DEBUG = os.getenv('DEBUG', 'False').lower() == 'true'

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.utcnow().isoformat(),
        'service': 'Python Backend API'
    }), 200

@app.route('/api/data', methods=['GET'])
def get_data():
    """Get sample data from backend"""
    return jsonify({
        'message': '✓ Successfully connected to Python Backend',
        'timestamp': datetime.utcnow().isoformat(),
        'service': 'Python Backend API',
        'version': '1.0.0',
        'environment': os.getenv('ENVIRONMENT', 'production'),
        'data': {
            'application': 'Kubernetes Deployment',
            'frontend': 'Angular',
            'backend': 'Python Flask',
            'deployment': 'Kubernetes',
            'cloud': 'Azure'
        }
    }), 200

@app.route('/api/status', methods=['GET'])
def get_status():
    """Get API status"""
    return jsonify({
        'status': 'running',
        'timestamp': datetime.utcnow().isoformat(),
        'uptime': 'OK',
        'database': 'Connected',
        'cache': 'Connected'
    }), 200

@app.route('/api/data', methods=['POST'])
def post_data():
    """Handle POST requests to create data"""
    data = request.get_json()
    
    if not data:
        return jsonify({'error': 'No data provided'}), 400
    
    return jsonify({
        'message': 'Data received successfully',
        'timestamp': datetime.utcnow().isoformat(),
        'received_data': data
    }), 201

@app.route('/api/process', methods=['POST'])
def process_data():
    """Process data from frontend"""
    try:
        data = request.get_json()
        
        # Sample processing logic
        processed = {
            'original': data,
            'processed': True,
            'timestamp': datetime.utcnow().isoformat(),
            'message': 'Data processed successfully'
        }
        
        return jsonify(processed), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/info', methods=['GET'])
def get_info():
    """Get application information"""
    return jsonify({
        'application': 'Kubernetes-Azure Integration',
        'version': '1.0.0',
        'description': 'Python Backend API running on Kubernetes',
        'endpoints': {
            'health': '/health',
            'data_get': '/api/data [GET]',
            'data_post': '/api/data [POST]',
            'status': '/api/status',
            'process': '/api/process [POST]',
            'info': '/api/info'
        },
        'technologies': [
            'Flask',
            'Python 3.11',
            'Docker',
            'Kubernetes',
            'Azure'
        ]
    }), 200

@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    return jsonify({
        'error': 'Endpoint not found',
        'message': 'The requested endpoint does not exist',
        'timestamp': datetime.utcnow().isoformat()
    }), 404

@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    return jsonify({
        'error': 'Internal server error',
        'message': str(error),
        'timestamp': datetime.utcnow().isoformat()
    }), 500

if __name__ == '__main__':
    app.run(
        host='0.0.0.0',
        port=5000,
        debug=DEBUG
    )
