import express from 'express'
import { algofiDataService } from '../services/algofiDataService.js'

const router = express.Router()

router.get('/metrics', async (req, res) => {
  try {
    const metrics = await algofiDataService.getProtocolMetrics()
    res.json(metrics)
  } catch (error) {
    console.error('Error fetching protocol metrics:', error)
    res.status(500).json({ error: 'Failed to fetch protocol metrics' })
  }
})

export default router