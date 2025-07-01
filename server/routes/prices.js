import express from 'express'
import { algofiDataService } from '../services/algofiDataService.js'

const router = express.Router()

router.get('/', async (req, res) => {
  try {
    const prices = await algofiDataService.getPrices()
    res.json(prices)
  } catch (error) {
    console.error('Error fetching prices:', error)
    res.status(500).json({ error: 'Failed to fetch prices' })
  }
})

export default router