import SwiftUI

struct LibraryView: View {
    @State private var songs: [Song] = []
    @StateObject private var playerManager = AudioPlayerManager.shared
    @StateObject private var connectivityManager = WatchConnectivityManager.shared
    
    var body: some View {
        List {
            if songs.isEmpty {
                Text("No songs found. Add them from your iPhone.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                ForEach(songs) { song in
                    NavigationLink(destination: PlayerView(song: song)) {
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .font(.body)
                            Text(song.artist)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteSong(song)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
            
            Section(header: Text("Storage")) {
                StorageIndicatorView()
            }
        }
        .navigationTitle("Library")
        .onAppear(perform: loadSongs)
        .onReceive(NotificationCenter.default.publisher(for: AppConstants.Notifications.newSongReceived)) { _ in
            loadSongs()
        }
    }
    
    private func loadSongs() {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let files = try FileManager.default.contentsOfDirectory(at: documents, includingPropertiesForKeys: nil)
            songs = files.filter { $0.pathExtension == "mp3" || $0.pathExtension == "m4a" }.map { url in
                Song(id: UUID(),
                     title: url.deletingPathExtension().lastPathComponent,
                     artist: "Unknown Artist",
                     fileName: url.lastPathComponent,
                     duration: 0,
                     fileSize: 0)
            }
        } catch {
            print("Failed to load songs: \(error)")
        }
    }
    
    private func deleteSong(_ song: Song) {
        if let url = song.localURL {
            try? FileManager.default.removeItem(at: url)
            loadSongs()
        }
    }
}

struct StorageIndicatorView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Free Space")
                .font(.system(size: 10))
            // Minimalist storage indicator logic here
            ProgressView(value: 0.7) // Mock value
                .progressViewStyle(.linear)
        }
    }
}
