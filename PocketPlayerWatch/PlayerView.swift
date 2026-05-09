import SwiftUI

struct PlayerView: View {
    let song: Song
    @StateObject private var playerManager = AudioPlayerManager.shared
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(song.title)
                .font(.headline)
                .lineLimit(1)
            
            Text(song.artist)
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: { /* Previous */ }) {
                    Image(systemName: "backward.fill")
                        .font(.title3)
                }
                .buttonStyle(.plain)
                
                Button(action: {
                    if playerManager.currentSong?.id == song.id {
                        playerManager.togglePlayPause()
                    } else {
                        playerManager.play(song: song)
                    }
                }) {
                    Image(systemName: (playerManager.isPlaying && playerManager.currentSong?.id == song.id) ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
                
                Button(action: { /* Next */ }) {
                    Image(systemName: "forward.fill")
                        .font(.title3)
                }
                .buttonStyle(.plain)
            }
            
            Spacer()
            
            if playerManager.currentSong?.id == song.id {
                VStack {
                    ProgressView(value: playerManager.currentTime, total: playerManager.duration)
                        .progressViewStyle(.linear)
                    
                    HStack {
                        Text(formatTime(playerManager.currentTime))
                        Spacer()
                        Text(formatTime(playerManager.duration))
                    }
                    .font(.system(size: 8))
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            if playerManager.currentSong?.id != song.id {
                playerManager.play(song: song)
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
