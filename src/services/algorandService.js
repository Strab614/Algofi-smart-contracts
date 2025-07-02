import algosdk from 'algosdk'

class AlgorandService {
  constructor() {
    // Algorand node configuration - using latest SDK v2.7.0
    this.algodToken = ''
    this.algodServer = 'https://testnet-api.algonode.cloud'
    this.algodPort = 443
    
    this.indexerToken = ''
    this.indexerServer = 'https://testnet-idx.algonode.cloud'
    this.indexerPort = 443

    this.algodClient = new algosdk.Algodv2(this.algodToken, this.algodServer, this.algodPort)
    this.indexerClient = new algosdk.Indexer(this.indexerToken, this.indexerServer, this.indexerPort)

    // Algofi contract addresses (testnet)
    this.contracts = {
      manager: 818179346,
      governance: 818179347,
      staking: 818179348,
      // Add more contract IDs as needed
    }
  }

  // Get account information
  async getAccountInfo(address) {
    try {
      return await this.algodClient.accountInformation(address).do()
    } catch (error) {
      console.error('Error fetching account info:', error)
      throw error
    }
  }

  // Get application information
  async getApplicationInfo(appId) {
    try {
      return await this.algodClient.getApplicationByID(appId).do()
    } catch (error) {
      console.error('Error fetching application info:', error)
      throw error
    }
  }

  // Get application global state
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

  // Get account's local state for an application
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

  // Get transactions for an account
  async getAccountTransactions(address, limit = 50) {
    try {
      const response = await this.indexerClient
        .lookupAccountTransactions(address)
        .limit(limit)
        .do()
      
      return response.transactions
    } catch (error) {
      console.error('Error fetching account transactions:', error)
      throw error
    }
  }

  // Get asset information
  async getAssetInfo(assetId) {
    try {
      return await this.algodClient.getAssetByID(assetId).do()
    } catch (error) {
      console.error('Error fetching asset info:', error)
      throw error
    }
  }

  // Get application transactions
  async getApplicationTransactions(appId, limit = 100) {
    try {
      const response = await this.indexerClient
        .lookupApplications(appId)
        .includeAll(true)
        .do()
      
      return response.application
    } catch (error) {
      console.error('Error fetching application transactions:', error)
      throw error
    }
  }

  // Calculate APY from rates
  calculateAPY(rate, compoundingFrequency = 365) {
    return Math.pow(1 + rate / compoundingFrequency, compoundingFrequency) - 1
  }

  // Format microAlgos to Algos using SDK utility
  microAlgosToAlgos(microAlgos) {
    return algosdk.microAlgosToAlgos(microAlgos)
  }

  // Format Algos to microAlgos using SDK utility
  algosToMicroAlgos(algos) {
    return algosdk.algosToMicroAlgos(algos)
  }

  // Format asset amount based on decimals
  formatAssetAmount(amount, decimals) {
    return amount / Math.pow(10, decimals)
  }

  // Validate Algorand address using SDK
  isValidAddress(address) {
    try {
      algosdk.decodeAddress(address)
      return true
    } catch {
      return false
    }
  }

  // Get suggested transaction parameters
  async getSuggestedParams() {
    try {
      return await this.algodClient.getTransactionParams().do()
    } catch (error) {
      console.error('Error fetching suggested params:', error)
      throw error
    }
  }

  // Submit transaction
  async submitTransaction(signedTxn) {
    try {
      const { txId } = await this.algodClient.sendRawTransaction(signedTxn).do()
      return await this.waitForConfirmation(txId)
    } catch (error) {
      console.error('Error submitting transaction:', error)
      throw error
    }
  }

  // Wait for transaction confirmation
  async waitForConfirmation(txId, timeout = 10) {
    try {
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

  // Enhanced methods for latest SDK features
  async getBlock(round) {
    try {
      return await this.algodClient.block(round).do()
    } catch (error) {
      console.error('Error fetching block:', error)
      throw error
    }
  }

  async getSupply() {
    try {
      return await this.algodClient.supply().do()
    } catch (error) {
      console.error('Error fetching supply:', error)
      throw error
    }
  }

  async getStatus() {
    try {
      return await this.algodClient.status().do()
    } catch (error) {
      console.error('Error fetching status:', error)
      throw error
    }
  }

  // Transaction building helpers
  makePaymentTransaction(from, to, amount, note = undefined) {
    return algosdk.makePaymentTxnWithSuggestedParamsFromObject({
      from,
      to,
      amount,
      note: note ? new Uint8Array(Buffer.from(note)) : undefined,
      suggestedParams: this.getSuggestedParams()
    })
  }

  makeAssetTransferTransaction(from, to, assetIndex, amount, note = undefined) {
    return algosdk.makeAssetTransferTxnWithSuggestedParamsFromObject({
      from,
      to,
      assetIndex,
      amount,
      note: note ? new Uint8Array(Buffer.from(note)) : undefined,
      suggestedParams: this.getSuggestedParams()
    })
  }

  makeApplicationCallTransaction(from, appIndex, onComplete, appArgs = [], accounts = [], foreignApps = [], foreignAssets = []) {
    return algosdk.makeApplicationCallTxnFromObject({
      from,
      appIndex,
      onComplete,
      appArgs,
      accounts,
      foreignApps,
      foreignAssets,
      suggestedParams: this.getSuggestedParams()
    })
  }
}

export const algorandService = new AlgorandService()