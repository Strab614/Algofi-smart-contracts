import express from 'express'
import { algofiDataService } from '../services/algofiDataService.js'

const router = express.Router()

router.get('/:address', async (req, res) => {
  try {
    const { address } = req.params
    const portfolio = await algofiDataService.getPortfolioData(address)
    res.json(portfolio)
  } catch (error) {
    console.error('Error fetching portfolio:', error)
    res.status(500).json({ error: 'Failed to fetch portfolio data' })
  }
})

export default router