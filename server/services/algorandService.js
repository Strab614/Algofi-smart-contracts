import algosdk from 'algosdk'

class AlgorandService {
  constructor() {
    this.algodClient = null
    this.indexerClient = null
  }

  initialize() {
    try {
      // Initialize Algorand clients with latest SDK
      const algodToken = ''
      const algodServer = 'https://testnet-api.algonode.cloud'
      const algodPort = 443

      const indexerToken = ''
      const indexerServer = 'https://testnet-idx.algonode.cloud'
      const indexerPort = 443

      // Using latest algosdk v2.7.0 syntax
      this.algodClient = new algosdk.Algodv2(algodToken, algodServer, algodPort)
      this.indexerClient = new algosdk.Indexer(indexerToken, indexerServer, indexerPort)

      console.log('AlgorandService initialized with algosdk v2.7.0')
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

  async getApplicationInfo(appId) {
    try {
      if (!this.algodClient) {
        throw new Error('Algorand client not initialized')
      }

      const appInfo = await this.algodClient.getApplicationByID(appId).do()
      return appInfo
    } catch (error) {
      console.error('Error fetching application info:', error)
      throw error
    }
  }

  async getSuggestedParams() {
    try {
      if (!this.algodClient) {
        throw new Error('Algorand client not initialized')
      }

      const params = await this.algodClient.getTransactionParams().do()
      return params
    } catch (error) {
      console.error('Error fetching suggested params:', error)
      throw error
    }
  }

  async submitTransaction(signedTxn) {
    try {
      if (!this.algodClient) {
        throw new Error('Algorand client not initialized')
      }

      const { txId } = await this.algodClient.sendRawTransaction(signedTxn).do()
      return await this.waitForConfirmation(txId)
    } catch (error) {
      console.error('Error submitting transaction:', error)
      throw error
    }
  }

  async waitForConfirmation(txId, timeout = 10) {
    try {
      if (!this.algodClient) {
        throw new Error('Algorand client not initialized')
      }

      const status = await this.algodClient.status().do()
      let lastRound = status['last-round']
      
      while (true) {
        const pendingInfo = await this.algodClient
          .pendingTransactionInformation(txId)
          .do()
        
        if (pendingInfo['confirmed-round'] !== null && pendingInfo['confirmed-round'] > 0) {
          return pendingInfo
        }
        
        lastRound++
        await this.algodClient.statusAfterBlock(lastRound).do()
        
        if (lastRound > status['last-round'] + timeout) {
          throw new Error('Transaction confirmation timeout')
        }
      }
    } catch (error) {
      console.error('Error waiting for confirmation:', error)
      throw error
    }
  }

  // Utility methods for latest SDK
  isValidAddress(address) {
    try {
      algosdk.decodeAddress(address)
      return true
    } catch {
      return false
    }
  }

  microAlgosToAlgos(microAlgos) {
    return algosdk.microAlgosToAlgos(microAlgos)
  }

  algosToMicroAlgos(algos) {
    return algosdk.algosToMicroAlgos(algos)
  }

  formatAssetAmount(amount, decimals) {
    return amount / Math.pow(10, decimals)
  }

  // Enhanced methods for latest SDK features
  async getApplicationGlobalState(appId) {
    try {
      const app = await this.getApplicationInfo(appId)
      const globalState = {}
      
      if (app.params['global-state']) {
        app.params['global-state'].forEach(item => {
          const key = Buffer.from(item.key, 'base64').toString()
          let value = item.value
          
          if (value.type === 1) { // bytes
            value = Buffer.from(value.bytes, 'base64').toString()
          } else if (value.type === 2) { // uint
            value = value.uint
          }
          
          globalState[key] = value
        })
      }
      
      return globalState
    } catch (error) {
      console.error('Error fetching application global state:', error)
      throw error
    }
  }

  async getAccountLocalState(address, appId) {
    try {
      const accountInfo = await this.getAccountInfo(address)
      const localState = {}
      
      if (accountInfo['apps-local-state']) {
        const appLocalState = accountInfo['apps-local-state'].find(
          app => app.id === appId
        )
        
        if (appLocalState && appLocalState['key-value']) {
          appLocalState['key-value'].forEach(item => {
            const key = Buffer.from(item.key, 'base64').toString()
            let value = item.value
            
            if (value.type === 1) { // bytes
              value = Buffer.from(value.bytes, 'base64').toString()
            } else if (value.type === 2) { // uint
              value = value.uint
            }
            
            localState[key] = value
          })
        }
      }
      
      return localState
    } catch (error) {
      console.error('Error fetching account local state:', error)
      throw error
    }
  }
}

export const algorandService = new AlgorandService()