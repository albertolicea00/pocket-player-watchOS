import Foundation
import WatchConnectivity
import UserNotifications

class WatchConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchConnectivityManager()
    
    private var session: WCSession = .default
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    // MARK: - WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Watch WCSession activated: \(activationState.rawValue)")
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(file.fileURL.lastPathComponent)
        
        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.moveItem(at: file.fileURL, to: destinationURL)
            
            notifyNewSong(name: file.fileURL.lastPathComponent)
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: AppConstants.Notifications.newSongReceived, object: nil)
            }
        } catch {
            print("Error saving received file: \(error.localizedDescription)")
        }
    }
    
    private func notifyNewSong(name: String) {
        let content = UNMutableNotificationContent()
        content.title = "New Song Received"
        content.body = "\(name) is ready to play."
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}
