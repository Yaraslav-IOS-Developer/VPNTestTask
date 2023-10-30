import Foundation

enum ConnectionStatus: String {
  case disconnected, connecting, connected
  
  var title: String {
    switch self {
    case .disconnected:
      return "Disconnected"
    case .connecting:
      return "Connecting..."
    case .connected:
      return "Connected"
    }
  }
  
  var icon: String {
    switch self {
    case .disconnected:
      return "Main_Disconnected"
    case .connecting:
      return "Main_Connecting"
    case .connected:
      return "Main_connected"
    }
  }
}
