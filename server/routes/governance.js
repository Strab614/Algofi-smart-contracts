import express from 'express'
import { algofiDataService } from '../services/algofiDataService.js'

const router = express.Router()

router.get('/proposals', async (req, res) => {
  try {
    const proposals = await algofiDataService.getGovernanceProposals()
    res.json(proposals)
  } catch (error) {
    console.error('Error fetching governance proposals:', error)
    res.status(500).json({ error: 'Failed to fetch governance proposals' })
  }
})

export default router