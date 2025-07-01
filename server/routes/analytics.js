import express from 'express'
import { algofiDataService } from '../services/algofiDataService.js'

const router = express.Router()

router.get('/data', async (req, res) => {
  try {
    const analytics = await algofiDataService.getAnalyticsData()
    res.json(analytics)
  } catch (error) {
    console.error('Error fetching analytics:', error)
    res.status(500).json({ error: 'Failed to fetch analytics data' })
  }
})

export default router