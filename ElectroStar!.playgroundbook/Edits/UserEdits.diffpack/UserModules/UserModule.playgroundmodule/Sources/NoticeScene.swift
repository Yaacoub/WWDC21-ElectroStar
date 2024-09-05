import SpriteKit

public final class NoticeScene: SKScene {
    
    
    
    //MARK:- Private Properties
    
    private var backButton = SKButtonNode(iconName: .iconBack, size: CGSize(width: 50, height: 50), style: .blueMain)
    private var background = SKSpriteNode(image: .background)
    private var iconIPadRotate = SKSpriteNode(image: .iconIPadRotateLeft)
    private var iconLockRotation = SKSpriteNode(image: .iconLockRotation)
    private var playButton = SKButtonNode(iconName: .iconPlay, size: CGSize(width: 50, height: 50), style: .blueMain)
    private var textIPadRotate = SKLabelNode(font: .caption)
    private var textLockRotation = SKLabelNode(font: .caption)
    
    private var iPadRotateStack = SKStackNode(axis: .vertical, spacing: 40)
    private var lockRotationStack = SKStackNode(axis: .vertical, spacing: 40)
    private var buttonsStack = SKStackNode(axis: .horizontal, spacing: 20)
    private var noticeStack = SKStackNode(axis: .horizontal, spacing: 80)
    private var mainStack = SKStackNode(axis: .vertical, spacing: 80)
    
    
    
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
        setupBackButton()
        setupBackground()
        setupIconIPadRotate()
        setupIconLockRotation()
        setupPlayButton()
        setupTextIPadRotate()
        setupTextLockRotation()
        setupIPadRotateStack()
        setupLockRotationStack()
        setupButtonsStack()
        setupNoticeStack()
        setupMainStack()
    }
    
    public override func update(_ currentTime: TimeInterval) {
        mainStack.updateParallax(parallaxEffect: .medium)
    }
    
    
    
    //MARK:- Private Methods
    
    private func setupBackButton() {
        backButton.action = { [weak self] in
            guard let view = self?.view else { return }
            AudioManager.playSoundEffect(.cancel)
            view.presentScene(IntroScene(size: view.frame.size), transition: .fade(withDuration: 2.0))
        }
    }
    
    private func setupBackground() {
        let maxSide = max(size.width, size.height)
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.size = CGSize(width: maxSide, height: maxSide)
        background.zPosition = -1
        addChild(background)
    }
    
    private func setupIconIPadRotate() {
        let actions = [
            SKAction.rotate(byAngle: .pi, duration: 4),
            .wait(forDuration: 2),
            .run { [weak self] in self?.iconIPadRotate.setImage(.iconIPadRotateRight) },
            .rotate(byAngle: -1 * .pi, duration: 4),
            .wait(forDuration: 2),
            .run { [weak self] in self?.iconIPadRotate.setImage(.iconIPadRotateLeft) },
        ]
        iconIPadRotate.size = CGSize(width: 150, height: 150)
        iconIPadRotate.position = CGPoint(x: 0, y: iconIPadRotate.frame.height / 2)
        iconIPadRotate.run(.repeatForever(.sequence(actions)))
    }
    
    private func setupIconLockRotation() {
        let actions = [
            SKAction.rotate(byAngle: 10 * .pi / 180, duration: 0.1),
            .rotate(byAngle: -20 * .pi / 180, duration: 0.1),
            .rotate(byAngle: 20 * .pi / 180, duration: 0.1),
            .rotate(byAngle: -10 * .pi / 180, duration: 0.1),
            .wait(forDuration: 2)
        ]
        iconLockRotation.size = CGSize(width: 150, height: 150)
        iconLockRotation.position = CGPoint(x: 0, y: iconLockRotation.frame.height / 2)
        iconLockRotation.run(.repeatForever(.sequence(actions)))
    }
    
    private func setupPlayButton() {
        playButton.action = { [weak self] in
            guard let view = self?.view else { return }
            AudioManager.playSoundEffect(.action)
            view.presentScene(Level1Scene(size: view.frame.size), transition: .fade(withDuration: 2.0))
        }
    }
    
    private func setupTextIPadRotate() {
        textIPadRotate.fontColor = .ghostWhite
        textIPadRotate.horizontalAlignmentMode = .center
        textIPadRotate.numberOfLines = 0
        textIPadRotate.position = CGPoint(x: 0, y: -(iconIPadRotate.frame.height / 2))
        textIPadRotate.preferredMaxLayoutWidth = iconIPadRotate.frame.width * 2
        textIPadRotate.text = "Turn your iPad to make Star's poles rotate!"
        textIPadRotate.verticalAlignmentMode = .center
    }
    
    private func setupTextLockRotation() {
        textLockRotation.fontColor = .ghostWhite
        textLockRotation.horizontalAlignmentMode = .center
        textLockRotation.numberOfLines = 0
        textLockRotation.position = CGPoint(x: 0, y: -(iconLockRotation.frame.height / 2))
        textLockRotation.preferredMaxLayoutWidth = iconLockRotation.frame.width * 2
        textLockRotation.text = "Lock your screen rotation for the best experience!"
        textLockRotation.verticalAlignmentMode = .center
    }
    
    private func setupIPadRotateStack() {
        iPadRotateStack.setSubviews([iconIPadRotate, textIPadRotate])
    }
    
    private func setupLockRotationStack() {
        lockRotationStack.setSubviews([iconLockRotation, textLockRotation])
    }
    
    private func setupButtonsStack() {
        buttonsStack.setSubviews([backButton, playButton])
    }
    
    private func setupNoticeStack() {
        noticeStack.setSubviews([lockRotationStack, iPadRotateStack])
    }
    
    private func setupMainStack() {
        mainStack.position = CGPoint(x: frame.midX, y: frame.midY)
        mainStack.setSubviews([noticeStack, buttonsStack])
        addChild(mainStack)
    }
    
}
