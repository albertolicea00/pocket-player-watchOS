import Foundation

struct AppConstants {
    static let appName = "Pocket Player"
    static let appGroupIdentifier = "group.com.pocketplayer.shared"
    static let watchAppBundleId = "com.pocketplayer.watchapp"
    
    struct Notifications {
        static let newSongReceived = Notification.Name("newSongReceived")
        static let transferProgressUpdate = Notification.Name("transferProgressUpdate")
    }
}
