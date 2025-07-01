import algosdk from 'algosdk'

class AlgorandService {
  constructor() {
    this.algodClient = null
    this.indexerClient = null
  }

  initialize() {
    try {
      // Initialize Algorand clients
      const algodToken = ''
      const algodServer = 'https://testnet-api.algonode.cloud'
      const algodPort = 443

      const indexerToken = ''
      const indexerServer = 'https://testnet-idx.algonode.cloud'
      const indexerPort = 443

      this.algodClient = new algosdk.Algodv2(algodToken, algodServer, algodPort)
      this.indexerClient = new algosdk.Indexer(indexerToken, indexerServer, indexerPort)

      console.log('AlgorandService initialized')
    } catch (error) {
      console.error('Error initializing AlgorandService:', error)
    }
  }

  async getAccountInfo(address) {
    try {
      if (!this.algodClient) {
        throw new Error('Algorand client not initialized')
      }
      
      const accountInfo = await this.algodClient.accountInformation(address).do()
      return accountInfo
    } catch (error) {
      console.error('Error fetching account info:', error)
      throw error
    }
  }

  async getTransactions(address, limit = 10) {
    try {
      if (!this.indexerClient) {
        throw new Error('Indexer client not initialized')
      }

      const transactions = await this.indexerClient
        .lookupAccountTransactions(address)
        .limit(limit)
        .do()
      
      return transactions
    } catch (error) {
      console.error('Error fetching transactions:', error)
      throw error
    }
  }

  async getAssetInfo(assetId) {
    try {
      if (!this.algodClient) {
        throw new Error('Algorand client not initialized')
      }

      const assetInfo = await this.algodClient.getAssetByID(assetId).do()
      return assetInfo
    } catch (error) {
      console.error('Error fetching asset info:', error)
      throw error
    }
  }
}

export const algorandService = new AlgorandService()