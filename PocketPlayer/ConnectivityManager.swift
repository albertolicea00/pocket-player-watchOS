import Foundation
import WatchConnectivity
import Combine

class ConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = ConnectivityManager()
    
    @Published var isWatchReachable = false
    @Published var activeTransfers: [URL: Double] = [:]
    
    private var session: WCSession = .default
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func transferFile(_ fileURL: URL, metadata: [String: Any]? = nil) {
        guard session.activationState == .activated else {
            print("WCSession not activated")
            return
        }
        
        _ = session.transferFile(fileURL, metadata: metadata)
        activeTransfers[fileURL] = 0.0
        
        // In a real app, you would observe progress via transfer.progress
    }
    
    // MARK: - WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            self.isWatchReachable = session.isReachable
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isWatchReachable = session.isReachable
        }
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    #endif
    
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        DispatchQueue.main.async {
            self.activeTransfers.removeValue(forKey: fileTransfer.file.fileURL)
            if let error = error {
                print("File transfer failed: \(error.localizedDescription)")
            } else {
                print("File transfer finished successfully")
            }
        }
    }
}
