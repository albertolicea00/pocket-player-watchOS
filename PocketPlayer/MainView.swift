import SwiftUI
import UniformTypeIdentifiers

struct MainView: View {
    @StateObject private var cloudManager = CloudManager()
    @StateObject private var connectivityManager = ConnectivityManager.shared
    @State private var isShowingFilePicker = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Storage Info")) {
                    StorageHeaderView()
                }
                
                Section(header: Text("iCloud / Local Files")) {
                    if cloudManager.availableFiles.isEmpty {
                        Text("No audio files found")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(cloudManager.availableFiles, id: \.self) { fileURL in
                            FileRowView(fileURL: fileURL) {
                                connectivityManager.transferFile(fileURL)
                            }
                        }
                    }
                }
                
                Section(header: Text("Transfers")) {
                    ForEach(connectivityManager.activeTransfers.sorted(by: { $0.key.lastPathComponent < $1.key.lastPathComponent }), id: \.key) { fileURL, progress in
                        HStack {
                            Text(fileURL.lastPathComponent)
                            Spacer()
                            ProgressView(value: progress)
                                .progressViewStyle(.linear)
                                .frame(width: 100)
                        }
                    }
                }
            }
            .navigationTitle("Pocket Player")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isShowingFilePicker = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingFilePicker) {
                DocumentPicker(types: [.audio]) { urls in
                    for url in urls {
                        if let localURL = FileManager.default.copyFileToDocuments(from: url) {
                            connectivityManager.transferFile(localURL)
                        }
                    }
                }
            }
        }
    }
}

struct StorageHeaderView: View {
    let available = FileManager.default.getAvailableDiskSpace()
    let total = FileManager.default.getTotalDiskSpace()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Watch Storage")
                    .font(.headline)
                Spacer()
                Text("\(ByteCountFormatter.string(fromByteCount: available, countStyle: .file)) free")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: 1.0 - Double(available) / Double(total))
                .progressViewStyle(.linear)
                .accentColor(.blue)
        }
        .padding(.vertical, 8)
    }
}

struct FileRowView: View {
    let fileURL: URL
    let onTransfer: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(fileURL.lastPathComponent)
                    .font(.body)
                Text(fileURL.pathExtension.uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: onTransfer) {
                Image(systemName: "arrow.up.circle")
                    .font(.title2)
            }
            .buttonStyle(.borderless)
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    let types: [UTType]
    let onPick: ([URL]) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let onPick: ([URL]) -> Void
        
        init(onPick: @escaping ([URL]) -> Void) {
            self.onPick = onPick
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            onPick(urls)
        }
    }
}
