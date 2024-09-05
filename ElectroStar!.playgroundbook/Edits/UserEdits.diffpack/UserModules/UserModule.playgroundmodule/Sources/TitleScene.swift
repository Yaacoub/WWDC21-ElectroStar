import AVFoundation
import SpriteKit

public final class TitleScene: SKScene {
    
    
    
    //MARK:- Private Properties
    
    private var background = SKSpriteNode(image: .background)
    private var backgroundStars = SKSpriteNode(image: .backgroundStars)
    private var startButton = SKButtonNode(title: "Start", size: CGSize(width: 200, height: 50), style: .blueMain)
    private var title = SKLabelNode(font: .title)
    
    private var titleStack = SKStackNode(axis: .vertical, spacing: 40)
    
    
    
    //MARK:- Init
    
    private override init() {
        super.init()
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        scaleMode = .aspectFit
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK:- Override Methods
    
    public override func didMove(to view: SKView) {
        setupBackground()
        setupStartButton()
        setupTitle()
        setupTitleStack()
    }
    
    public override func update(_ currentTime: TimeInterval) {
        backgroundStars.updateParallax(parallaxEffect: .high)
        titleStack.updateParallax(parallaxEffect: .medium)
    }
    
    
    
    //MARK:- Private Methods
    
    private func setupBackground() {
        let maxSide = max(size.width, size.height)
        for (index, layer) in [backgroundStars, background].enumerated() {
            layer.position = CGPoint(x: frame.midX, y: frame.midY)
            layer.size = CGSize(width: maxSide, height: maxSide)
            layer.zPosition = CGFloat(-index - 1)
            addChild(layer)
        }
        backgroundStars.run(.repeatForever(.rotate(byAngle: .pi, duration: 40)))
    }
    
    private func setupStartButton() {
        startButton.action = { [weak self] in
            guard let view = self?.view else { return }
            AudioManager.playSoundEffect(.action)
            view.presentScene(IntroScene(size: view.frame.size), transition: .fade(withDuration: 2.0))
        }
    }
    
    private func setupTitle() {
        let fadeInOut = SKAction.sequence([.fadeIn(withDuration: 2.0), .fadeOut(withDuration: 2.0)])
        title.alpha = 0.0
        title.fontColor = .ghostWhite
        title.text = "ElectroStar!"
        title.run(.repeatForever(fadeInOut))
    }
    
    private func setupTitleStack() {
        titleStack.position = CGPoint(x: frame.midX, y: frame.midY)
        titleStack.setSubviews([title, startButton])
        addChild(titleStack)
    }
    
}
