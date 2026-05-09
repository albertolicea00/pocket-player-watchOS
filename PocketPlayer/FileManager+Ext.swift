import Foundation
import AVFoundation

extension FileManager {
    var documentsDirectory: URL {
        urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func getAvailableDiskSpace() -> Int64 {
        do {
            let values = try documentsDirectory.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
            return values.volumeAvailableCapacityForImportantUsage ?? 0
        } catch {
            return 0
        }
    }
    
    func getTotalDiskSpace() -> Int64 {
        do {
            let values = try documentsDirectory.resourceValues(forKeys: [.volumeTotalCapacityKey])
            return Int64(values.volumeTotalCapacity ?? 0)
        } catch {
            return 0
        }
    }
    
    func copyFileToDocuments(from url: URL) -> URL? {
        let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)
        
        do {
            if fileExists(atPath: destinationURL.path) {
                try removeItem(at: destinationURL)
            }
            try copyItem(at: url, to: destinationURL)
            return destinationURL
        } catch {
            print("Error copying file: \(error.localizedDescription)")
            return nil
        }
    }
}
