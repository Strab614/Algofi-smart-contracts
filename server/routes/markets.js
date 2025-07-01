import express from 'express'
import { algofiDataService } from '../services/algofiDataService.js'

const router = express.Router()

router.get('/', async (req, res) => {
  try {
    const markets = await algofiDataService.getMarkets()
    res.json(markets)
  } catch (error) {
    console.error('Error fetching markets:', error)
    res.status(500).json({ error: 'Failed to fetch markets' })
  }
})

export default router