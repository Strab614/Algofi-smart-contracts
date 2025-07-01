import express from 'express'
import { createServer } from 'http'
import { Server } from 'socket.io'
import cors from 'cors'

// Simple mock data service for local development
const mockData = {
  protocolMetrics: {
    tvl: 125000000,
    totalBorrowed: 45000000,
    totalSupplied: 180000000,
    activeUsers: 12500,
    volume24h: 8500000,
    loading: false
  },
  markets: [
    {
      assetId: 'algo',
      name: 'Algorand',
      symbol: 'ALGO',
      supplyApy: 4.2,
      borrowApy: 6.8,
      totalSupply: 50000000,
      totalBorrow: 15000000,
      utilization: 30,
      price: 0.25
    },
    {
      assetId: 'usdc',
      name: 'USD Coin',
      symbol: 'USDC',
      supplyApy: 3.5,
      borrowApy: 5.2,
      totalSupply: 75000000,
      totalBorrow: 25000000,
      utilization: 33.3,
      price: 1.00
    },
    {
      assetId: 'usdt',
      name: 'Tether USD',
      symbol: 'USDT',
      supplyApy: 3.2,
      borrowApy: 4.9,
      totalSupply: 60000000,
      totalBorrow: 20000000,
      utilization: 33.3,
      price: 1.00
    }
  ],
  governance: [
    {
      id: 1,
      title: 'Increase ALGO Supply Cap',
      description: 'Proposal to increase the ALGO supply cap to 100M',
      status: 'active',
      votesFor: 1250000,
      votesAgainst: 350000,
      totalVotes: 1600000,
      quorum: 1000000,
      endDate: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString()
    },
    {
      id: 2,
      title: 'Add USDT Market',
      description: 'Proposal to add USDT as a new lending market',
      status: 'passed',
      votesFor: 2100000,
      votesAgainst: 450000,
      totalVotes: 2550000,
      quorum: 1000000,
      endDate: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000).toISOString()
    }
  ],
  prices: {
    ALGO: 0.25,
    USDC: 1.00,
    USDT: 1.00,
    BANK: 0.15
  }
}

const app = express()
const server = createServer(app)
const io = new Server(server, {
  cors: {
    origin: ["http://localhost:3000"],
    methods: ["GET", "POST"]
  }
})

// Middleware
app.use(cors())
app.use(express.json())

// Routes
app.get('/api/protocol/metrics', (req, res) => {
  res.json({ data: mockData.protocolMetrics })
})

app.get('/api/markets', (req, res) => {
  res.json({ data: mockData.markets })
})

app.get('/api/governance/proposals', (req, res) => {
  res.json({ data: mockData.governance })
})

app.get('/api/portfolio/:address', (req, res) => {
  res.json({
    data: {
      totalSupplied: 10000,
      totalBorrowed: 3000,
      netWorth: 7000,
      healthFactor: 2.5,
      positions: [
        {
          asset: 'ALGO',
          supplied: 5000,
          borrowed: 1000,
          apy: 4.2
        }
      ]
    }
  })
})

app.get('/api/analytics', (req, res) => {
  res.json({
    data: {
      tvlHistory: Array.from({ length: 30 }, (_, i) => ({
        date: new Date(Date.now() - (29 - i) * 24 * 60 * 60 * 1000).toISOString(),
        value: 120000000 + Math.random() * 10000000
      }))
    }
  })
})

app.get('/api/prices', (req, res) => {
  res.json({ data: mockData.prices })
})

// Health check
app.get('/api/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    message: 'Local development server running'
  })
})

// Socket.IO connection handling
io.on('connection', (socket) => {
  console.log('Client connected:', socket.id)
  
  // Send initial data
  socket.emit('protocolUpdate', mockData.protocolMetrics)
  socket.emit('marketsUpdate', mockData.markets)
  socket.emit('priceUpdate', mockData.prices)
  socket.emit('governanceUpdate', mockData.governance)
  
  socket.on('disconnect', () => {
    console.log('Client disconnected:', socket.id)
  })
})

// Simulate real-time updates every 30 seconds
setInterval(() => {
  // Add some random variation to the data
  const updatedMetrics = {
    ...mockData.protocolMetrics,
    tvl: mockData.protocolMetrics.tvl + (Math.random() - 0.5) * 1000000,
    volume24h: mockData.protocolMetrics.volume24h + (Math.random() - 0.5) * 500000
  }
  
  io.emit('protocolUpdate', updatedMetrics)
}, 30000)

const PORT = process.env.PORT || 8000

server.listen(PORT, () => {
  console.log(`🚀 Local Development Server running on port ${PORT}`)
  console.log(`📊 Mock data endpoints available`)
  console.log(`🔗 WebSocket server ready`)
  console.log(`💡 This is a local development setup - can be commented out for production`)
})