import AVFoundation

class AudioManager {
    
    
    
    //MARK:- Properties
    
    static var currentMusic: Music?
    
    
    
    //MARK:- Init
    
    private init() {}    
    
    
    
    //MARK:- Structs
    
    struct Music: Equatable {
        
        private var player: AVAudioPlayer?
        
        static let main = Music(fileName: "PatrickLieberkind - Futuristic Rhythmic Game Ambience", ofType: "m4a")
        
        fileprivate init(fileName: String, ofType type: String) {
            guard let filePath = Bundle.main.path(forResource: fileName, ofType: type) else { return }
            self.player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
        }
        
        fileprivate func pause() {
            guard let isPlaying = player?.isPlaying, isPlaying else { return }
            player?.pause()
        }
        
        fileprivate func resume() {
            guard let isPlaying = player?.isPlaying, !isPlaying else { return }
            player?.play()
        }
        
        fileprivate func setVolume(_ volume: Float, fadeDuration: TimeInterval = 0) {
            player?.setVolume(volume, fadeDuration: fadeDuration)
        }
        
        fileprivate func start() {
            currentMusic?.stop()
            currentMusic = self
            player?.numberOfLoops = -1
            player?.volume = 0
            player?.play()
            player?.setVolume(1, fadeDuration: 6)
        }
        
        fileprivate func stop() {
            if currentMusic == self { currentMusic = nil }
            player?.setVolume(0, fadeDuration: 6)
            player?.stop()
        }
        
    }
    
    struct SoundEffect {
        
        private var player: AVAudioPlayer?
        private var volume: Float?
        
        static let action = SoundEffect(fileName: "TheAtomicBrain - Computer Chimes - Program Start", ofType: "m4a")
        static let cancel = SoundEffect(fileName: "Raclure - Cancel--miss chime", ofType: "m4a")
        static let damage = SoundEffect(fileName: "OwlStorm - Retro video game sfx - Ouch", ofType: "m4a")
        static let loss = SoundEffect(fileName: "cabled_mess - Lose_C_01", ofType: "m4a")
        static let next = SoundEffect(fileName: "GameAudio - Beep Space Button", ofType: "m4a")
        static let newWave = SoundEffect(fileName: "Beetlemuse - Alert (1)", ofType: "m4a", volume: 0.2)
        static let powerup = SoundEffect(fileName: "Mellau - Button Click 3", ofType: "m4a")
        static let success = SoundEffect(fileName: "EVRetro - 'Win' Video Game Sound", ofType: "m4a")
        
        fileprivate init(fileName: String, ofType type: String, volume: Float = 1) {
            guard let filePath = Bundle.main.path(forResource: fileName, ofType: type) else { return }
            self.player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
            self.volume = volume
        }
        
        fileprivate func play(_ completion: (() -> ())? = nil) {
            player?.numberOfLoops = 0
            player?.volume = volume ?? 1
            currentMusic?.setVolume(0, fadeDuration: (player?.duration ?? 2) / 2)
            player?.play()
            currentMusic?.setVolume(1, fadeDuration: (player?.duration ?? 2) / 2)
            completion?()
        }
        
    }
    
    
    
    //MARK:- Methods
    
    static func pauseMusic(_ music: Music) {
        music.pause()
    }
    
    static func resumeMusic(_ music: Music) {
        music.resume()
    }
    
    static func playSoundEffect(_ soundEffect: SoundEffect) {
        currentMusic?.setVolume(0.5)
        soundEffect.play { currentMusic?.setVolume(1) }
    }
    
    static func startMusic(_ music: Music) {
        music.start()
    }
    
    static func stopMusic(_ music: Music) {
        music.stop()
    }
    
}
