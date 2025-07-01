class SocketManager {
  constructor() {
    this.io = null
    this.connectedClients = new Set()
  }

  initialize(io) {
    this.io = io
    console.log('SocketManager initialized')
  }

  broadcast(event, data) {
    if (this.io) {
      this.io.emit(event, data)
    }
  }

  broadcastToRoom(room, event, data) {
    if (this.io) {
      this.io.to(room).emit(event, data)
    }
  }

  getConnectedClientsCount() {
    return this.connectedClients.size
  }

  addClient(socketId) {
    this.connectedClients.add(socketId)
  }

  removeClient(socketId) {
    this.connectedClients.delete(socketId)
  }
}

export const socketManager = new SocketManager()