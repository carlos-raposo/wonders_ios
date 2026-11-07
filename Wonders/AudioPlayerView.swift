import SwiftUI
import AVKit

struct AudioPlayerView: View {
    let cardId: String
    let currentLang: String
    let isDarkMode: Bool
    let isPremium: Bool
    var onFreeUserTap: (() -> Void)?
    
    @StateObject private var playerManager = AudioPlayerManager()
    
    var body: some View {
        HStack(spacing: 6) {
            // 1. Botão Play / Pause Integrado
            Button(action: {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                
                playerManager.togglePlay(cardId: cardId, currentLang: currentLang)
            }) {
                ZStack {
                    Circle()
                        .fill(Color.accentColor)
                        .frame(width: 30, height: 30)
                    
                    if playerManager.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.7)
                    } else {
                        Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .offset(x: playerManager.isPlaying ? 0 : 1)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 34, height: 34)
            
            // 2. Tempo Decorrido
            Text(formatDuration(playerManager.position))
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(isDarkMode ? .white : .black.opacity(0.87))
            
            // 3. Slider de Progresso (limitado a 15s para Free)
            Slider(value: Binding(
                get: { min(playerManager.position, limitDuration) },
                set: { newPosition in
                    playerManager.seek(to: newPosition)
                }
            ), in: 0...max(1, limitDuration))
            .accentColor(isDarkMode ? .red : .accentColor)
            
            // 4. Tempo Total (Limitado a 15s para Free)
            Text(formatDuration(limitDuration))
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(isDarkMode ? .white : .black.opacity(0.87))
        }
        .padding(.leading, 4)
        .padding(.trailing, 10)
        .padding(.vertical, 3)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isDarkMode ? Color.white.opacity(0.15) : Color.black.opacity(0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isDarkMode ? Color.white.opacity(0.2) : Color.clear, lineWidth: 1)
        )
        .padding(.bottom, 10)
        .onDisappear {
            playerManager.stop()
        }
        .onChange(of: playerManager.position) { newPos in
            if !isPremium && newPos >= 15.0 {
                playerManager.pause()
                playerManager.seek(to: 0)
                onFreeUserTap?()
            }
        }
    }
    
    private var limitDuration: Double {
        if !isPremium && playerManager.duration > 15 {
            return 15.0
        }
        return playerManager.duration > 0 ? playerManager.duration : 1.0
    }
    
    private func formatDuration(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

// MARK: - Controller de Áudio com AVPlayer
class AudioPlayerManager: ObservableObject {
    @Published var isPlaying = false
    @Published var isLoading = false
    @Published var position: Double = 0.0
    @Published var duration: Double = 0.0
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    
    func togglePlay(cardId: String, currentLang: String) {
        if isPlaying {
            pause()
        } else {
            if player == nil {
                let langFolder = String(currentLang.prefix(2)).lowercased()
                let urlString = "https://firebasestorage.googleapis.com/v0/b/wonders7-59420.firebasestorage.app/o/audio%2F\(langFolder)%2F\(cardId).mp3?alt=media"
                
                guard let url = URL(string: urlString) else { return }
                
                isLoading = true
                let playerItem = AVPlayerItem(url: url)
                player = AVPlayer(playerItem: playerItem)
                
                timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: .main) { [weak self] time in
                    guard let self = self else { return }
                    self.position = time.seconds
                    
                    let dur = playerItem.duration.seconds
                    if !dur.isNaN && !dur.isInfinite {
                        self.duration = dur
                        self.isLoading = false
                    }
                }
            }
            
            player?.play()
            isPlaying = true
        }
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func stop() {
        player?.pause()
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
        player = nil
        isPlaying = false
        position = 0
    }
    
    func seek(to seconds: Double) {
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        player?.seek(to: time)
    }
}