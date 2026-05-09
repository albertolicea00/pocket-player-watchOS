# Pocket Player - watchOS

**Pocket Player** is an independent Apple Watch application designed to play music locally without the need for a connected iPhone. It focuses on a simple, familiar file-explorer user experience, enabling easy transfers of audio files from an iPhone and cloud services.

## Objective
- **Independent Playback:** Play music on Apple Watch without relying on the iPhone.
- **Easy Transfer:** Seamlessly transfer songs from the iPhone and cloud storage (iCloud Drive / Google Drive).
- **Simple UX:** A clean, familiar, Finder-like user interface for file management and playback.

## Architecture
The project is built with a dual-platform architecture:
- **Standalone watchOS App:** Acts as the local media player and file manager.
- **Companion iOS App:** Handles file transfers, audio compression, and cloud service integration.
- **WCSession:** Manages seamless file synchronization between the iPhone and Apple Watch.
- **Sandbox Storage:** Uses the watchOS local sandbox for media storage.

## Features

### iPhone App (Companion)
- **File Sharing:** Enable File Sharing and Files app integration.
- **iCloud Drive:** Dedicated app folder in iCloud Drive.
- **Google Drive (Upcoming):** Optional integration via Google Drive API.
- **Audio Optimization:** On-device compression/conversion to AAC/MP3 before transfer.
- **Sync:** Automatic file transfers via `WCSession.transferFile`.
- **User Interface:** Folder-style UI indicating transfer progress and available space.

### Watch App
- **Audio Player:** Built around `AVAudioPlayer` with background execution support.
- **File Manager:** Lists stored songs cleanly.
- **Minimalist UI:** Simple list display, basic playback controls, swipe-to-delete, and tap-to-play.
- **Notifications:** Alerts upon receiving new files from the iPhone.
- **Storage Management:** Built-in storage indicator showing used/free space.

### Cloud Integration Flow
1. User uploads a file to the designated cloud folder.
2. iPhone companion app detects the new file.
3. iPhone app compresses/converts the file to optimize Watch storage.
4. File is sent to the Apple Watch via WCSession.

## Optimization Goals
- Full support for `.aac` and `.mp3` formats.
- Implementation of simple playlists.
- Search-by-name functionality.
- Efficient battery usage and storage space management on the Watch.

## Roadmap & Status
Currently, the codebase contains the core Swift logic for UI (`MainView.swift`, `LibraryView.swift`), connectivity (`ConnectivityManager.swift`, `WatchConnectivityManager.swift`), and basic audio playback (`AudioPlayerManager.swift`). 
Future work includes finalizing the Xcode project structure, Google Drive OAuth2 integration, and audio conversion services.
