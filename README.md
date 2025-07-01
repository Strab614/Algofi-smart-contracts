# Algofi Tracker - Real-time DeFi Analytics

A comprehensive web platform for tracking Algofi protocol metrics on the Algorand blockchain.

## Features

- **Real-time Protocol Metrics**: TVL, volume, active users, and more
- **Market Data**: Lending/borrowing rates, liquidity pools, asset prices
- **Governance Tracking**: Active proposals, voting status, participation
- **Portfolio Management**: Connect wallet to track positions and transactions
- **Advanced Analytics**: Yield optimization, risk assessment, historical data

## Local Development Setup

### Prerequisites
- Node.js 18+ 
- npm or yarn

### Quick Start

1. **Install dependencies and start both frontend and backend:**
   ```bash
   npm install
   npm run dev
   ```

2. **Access the application:**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8000

### Development Scripts

- `npm run dev` - Start both frontend and backend servers
- `npm run client` - Start only the frontend (Vite dev server)
- `npm run server` - Start only the backend server
- `npm run build` - Build for production

## Architecture

### Frontend (React + Vite)
- **Framework**: React 18 with modern hooks
- **Styling**: Tailwind CSS with dark/light mode
- **Charts**: Recharts for data visualization
- **State Management**: Context API + Zustand
- **Real-time**: Socket.IO client for live updates
- **Routing**: React Router for navigation

### Backend (Node.js + Express)
- **Server**: Express.js with Socket.IO
- **Data**: Mock data service (easily replaceable with real APIs)
- **Real-time**: WebSocket connections for live updates
- **Security**: CORS, rate limiting, helmet

### Blockchain Integration
- **SDK**: Algorand JavaScript SDK
- **Network**: Testnet (configurable for mainnet)
- **Wallets**: Pera Wallet, Exodus support
- **Contracts**: PyTeal smart contract integration ready

## Local Development Notes

**Current Setup**: The backend server provides mock data for local development and testing. This allows you to:

- Test all frontend features without external dependencies
- Develop and iterate quickly
- Simulate real-time data updates
- Test error handling and edge cases

**For Production**: Replace the mock data service with actual Algofi API calls and Algorand node connections.

## Project Structure

```
├── src/                    # Frontend React application
│   ├── components/         # Reusable UI components
│   ├── contexts/          # React contexts for state management
│   ├── pages/             # Main application pages
│   ├── services/          # API and external service integrations
│   └── styles/            # CSS and styling files
├── server/                # Backend Node.js server
│   ├── routes/            # API route handlers
│   ├── services/          # Business logic and data services
│   └── index.js           # Server entry point
├── contracts/             # Smart contract code (PyTeal)
└── public/                # Static assets
```

## Key Features Implementation

### Real-time Data Updates
- WebSocket connections for live protocol metrics
- Automatic reconnection handling
- Optimistic UI updates

### Responsive Design
- Mobile-first approach
- Dark/light theme support
- Accessible UI components

### Performance Optimization
- Component lazy loading
- Efficient re-rendering with React.memo
- Optimized bundle size with Vite

### Error Handling
- Graceful API error handling
- User-friendly error messages
- Retry mechanisms for failed requests

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the GNU General Public License v3.0 - see the LICENSE file for details.