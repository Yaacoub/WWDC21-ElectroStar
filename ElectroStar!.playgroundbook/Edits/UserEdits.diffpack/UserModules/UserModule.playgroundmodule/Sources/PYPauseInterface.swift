import SpriteKit

final class PYPauseInterface: SKNode {
    
    
    
    //MARK:- Private Properties
    
    private var buttonBack = SKButtonNode(iconName: .iconBack, size: CGSize(width: 50, height: 50), style: .blueMain)
    private var buttonPausePlay = SKButtonNode(iconName: .iconPause, size: CGSize(width: 50, height: 50), style: .blueMain)
    private var buttonRestart = SKButtonNode(iconName: .iconRestart, size: CGSize(width: 50, height: 50), style: .blueMain)
    
    private var buttonsStack = SKStackNode(axis: .horizontal, spacing: 20)
    
    
    
    //MARK:- Properties
    
    private(set) var isPausingScene = false
    
    
    
    //MARK:- Init
    
    override init() {
        super.init()
        setupButtonBack()
        setupButtonRestart()
        setupButtonPausePlay()
        setupStacks()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK:- Override
    
    override var frame: CGRect {
        calculateAccumulatedFrame()
    }
    
    
    
    //MARK:- Private Methods
    
    private func pause() {
        let pausableNodes = scene?.children.filter { $0 != self }
        AudioManager.pauseMusic(.main)
        isPausingScene = true
        buttonBack.isHidden = false
        buttonRestart.isHidden = false
        scene?.physicsWorld.speed = 0
        buttonPausePlay.setIcon(named: .iconPlay)
        pausableNodes?.forEach { $0.isPaused = true }
    }
    
    private func play() {
        let pausableNodes = scene?.children.filter { $0 != self }
        AudioManager.resumeMusic(.main)
        isPausingScene = false
        buttonBack.isHidden = true
        buttonRestart.isHidden = true
        scene?.physicsWorld.speed = 1
        buttonPausePlay.setIcon(named: .iconPause)
        pausableNodes?.forEach { $0.isPaused = false }
    }
    
    private func setupButtonBack() {
        buttonBack.action = { [weak self] in
            guard let view = self?.scene?.view else { return }
            AudioManager.resumeMusic(.main)
            AudioManager.playSoundEffect(.cancel)
            view.presentScene(TitleScene(size: view.frame.size), transition: .fade(withDuration: 2.0))
        }
        buttonBack.isHidden = true
    }
    
    private func setupButtonPausePlay() {
        buttonPausePlay.action = { [weak self] in
            guard let self = self else { return }
            AudioManager.playSoundEffect(.next)
            !self.isPausingScene ? self.pause() : self.play()
        }
    }
    
    private func setupButtonRestart() {
        buttonRestart.action = { [weak self] in
            guard let scene = self?.scene, let view = scene.view else { return }
            AudioManager.resumeMusic(.main)
            AudioManager.playSoundEffect(.cancel)
            view.presentScene(type(of: scene).init(size: scene.size), transition: .fade(withDuration: 2.0))
        }
        buttonRestart.isHidden = true
    }
    
    private func setupStacks() {
        buttonsStack.setSubviews([buttonBack, buttonRestart, buttonPausePlay])
        buttonsStack.zPosition = 10
        addChild(buttonsStack)
    }
    
    
    
    //MARK:- Methods
    
    func stopScene() {
        pause()
        buttonPausePlay.isHidden = true
    }
    
}
