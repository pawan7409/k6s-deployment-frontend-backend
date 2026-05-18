#!/bin/bash
# setup.sh - Project Setup Script

set -e

echo "🚀 Kubernetes App Deployment - Setup Script"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
check_prerequisites() {
    echo -e "${YELLOW}✓ Checking prerequisites...${NC}"
    
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.js not found. Please install Node.js 18+${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Node.js found${NC}"
    
    if ! command -v python &> /dev/null; then
        echo -e "${RED}❌ Python not found. Please install Python 3.11+${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Python found${NC}"
    
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker not found. Please install Docker${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Docker found${NC}"
}

# Setup Frontend
setup_frontend() {
    echo ""
    echo -e "${YELLOW}📦 Setting up Frontend...${NC}"
    cd frontend
    npm install
    cd ..
    echo -e "${GREEN}✓ Frontend setup complete${NC}"
}

# Setup Backend
setup_backend() {
    echo ""
    echo -e "${YELLOW}🐍 Setting up Backend...${NC}"
    cd backend
    
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        python -m venv venv
        venv\Scripts\activate
    else
        python -m venv venv
        source venv/bin/activate
    fi
    
    pip install -r requirements.txt
    cp .env.example .env
    cd ..
    echo -e "${GREEN}✓ Backend setup complete${NC}"
}

# Main execution
main() {
    check_prerequisites
    setup_frontend
    setup_backend
    
    echo ""
    echo -e "${GREEN}✅ Setup complete!${NC}"
    echo ""
    echo "📝 Next steps:"
    echo "1. Configure backend/.env with your Azure settings"
    echo "2. Build Docker images: docker-compose build"
    echo "3. Start local development: docker-compose up"
    echo "4. Access Frontend: http://localhost:4200"
    echo "5. Access Backend: http://localhost:5000"
}

main
