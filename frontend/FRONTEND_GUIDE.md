# Frontend Development Guide

## Project Setup

### Prerequisites
- Node.js 18+ 
- npm or yarn

### Installation

```bash
npm install
```

### Development Server

```bash
npm start
```

Server runs on `http://localhost:4200`

### Building

#### Development Build
```bash
npm run build
```

#### Production Build
```bash
npm run build:prod
```

### Testing

```bash
npm test
```

### Linting

```bash
npm run lint
```

## Project Structure

```
src/
├── app/
│   ├── app.component.ts       # Root component
│   ├── app.component.html     # Root template
│   ├── app.component.css      # Component styles
│   ├── app.service.ts         # HTTP service
├── main.ts                    # Bootstrap file
├── index.html                 # HTML entry point
└── styles.css                 # Global styles
```

## Components

### AppComponent
- Root component displaying dashboard
- Fetches data from backend API
- Shows connection status

### AppService
- Handles HTTP communication with backend
- Base API URL: `/api`
- Methods:
  - `getData()` - GET /api/data
  - `getStatus()` - GET /api/status
  - `postData(data)` - POST /api/data

## Styling

- Bootstrap 5 CDN for UI components
- CSS Grid and Flexbox for layouts
- Responsive design principles

## Building Docker Image

```bash
docker build -t angular-frontend:latest .
docker run -p 4200:4200 angular-frontend:latest
```

## Environment Configuration

Configure backend URL in environment files:

```typescript
// For different environments
const baseUrl = environment.production 
  ? 'https://api.production.com' 
  : 'http://localhost:5000';
```

## Kubernetes Deployment

See main README.md for deployment instructions.
