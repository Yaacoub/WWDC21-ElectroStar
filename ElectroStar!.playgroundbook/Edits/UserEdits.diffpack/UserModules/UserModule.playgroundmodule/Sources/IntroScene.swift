import SpriteKit

public final class IntroScene: SKScene {
    
    
    
    //MARK:- Private Properties
    
    private let dialogue = [
        Dialogue(robot: "Hey! I'm Star, nice to meet you!", user: "Hello!"),
        Dialogue(robot: "Scientists have sent me here to explore space, but it's very tricky.", user: "How can I help?"),
        Dialogue(robot: "I'm being surrounded by positive and negative particles…", user: "…"),
        Dialogue(robot: "But you can help me repel them!", user: "How?"),
        Dialogue(robot: "Well, I have positive and negative poles on me…", user: "…"),
        Dialogue(robot: "So when you rotate your device, the poles rotate too!", user: "Wow!"),
        Dialogue(robot: "You'll keep the positives away from my negative pole…", user: "…"),
        Dialogue(robot: "And the negatives away from my positive pole!", user: "Sure thing!"),
        Dialogue(robot: "QUICK, THEY'RE COMING MY WAY!!!", user: "Let's go!")
    ]
    
    private var dialogueIndex = 0
    
    private var backButton = SKButtonNode(iconName: .iconBack, size: CGSize(width: 50, height: 50), style: .blueMain)
    private var background = SKSpriteNode(image: .background)
    private var backgroundStars = SKSpriteNode(image: .backgroundStars)
    private var bubble = SKShapeNode(rectOf: CGSize(width: 500, height: 150), cornerRadius: 25)
    private var bubbleText = SKAdvancedLabelNode(text: "")
    private var continueButton = SKButtonNode(title: "", size: CGSize(width: 410, height: 50), style: .blueMain)
    private var robot = SKSpriteNode(image: .robot)
    private var skipButton = SKButtonNode(iconName: .iconSkip, size: CGSize(width: 50, height: 50), style: .blueMain)
    
    private var buttonsStack = SKStackNode(axis: .horizontal, spacing: 20)
    private var bubbleStack = SKStackNode(axis: .vertical, spacing: 20)
    private var messageStack = SKStackNode(axis: .horizontal, spacing: 0)
    
    
    
    //MARK:- Struct
    
    private struct Dialogue {
        let robot: String
        let user: String
    }
    
    
    
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
        setupBubble()
        setupBubbleText()
        setupContinueButton()
        setupRobot()
        setupSkipButton()
        setupButtonsStack()
        setupBubbleStack()
        setupMessageStack()
    }
    
    public override func update(_ currentTime: TimeInterval) {
        backgroundStars.updateParallax(parallaxEffect: .high)
        messageStack.updateParallax(parallaxEffect: .medium)
    }
    
    
    
    //MARK:- Private Methods
    
    private func setBubbleText(animation: SKAdvancedLabelNode.TypingAnimation = .progressive) {
        bubbleText.setText(dialogue[dialogueIndex].robot, animation: animation) { [weak self] in
            guard let self = self else { return }
            self.continueButton.alpha = 1
            self.continueButton.isUserInteractionEnabled = true
            self.continueButton.setTitle(self.dialogue[self.dialogueIndex].user)
        }
    }
    
    private func setupBackButton() {
        backButton.action = { [weak self] in
            guard let self = self else { return }
            AudioManager.playSoundEffect(.cancel)
            if self.dialogueIndex > 0 {
                self.dialogueIndex -= 1
                self.setBubbleText(animation: .none)
            } else if let view = self.view {
                view.presentScene(TitleScene(size: view.frame.size), transition: .fade(withDuration: 2.0))
            }
        }
    }
    
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
    
    private func setupBubble() {
        bubble.fillColor = .ghostWhite
        bubble.position = CGPoint(x: bubble.frame.width / 3, y: 0)
        bubble.strokeColor = .glaucous
        bubble.lineWidth = 10
        bubble.addChild(bubbleText)
    }
    
    private func setupBubbleText() {
        bubbleText.allowsAnimationSkip = true
        bubbleText.color = .xiketic
        bubbleText.font = .body
        bubbleText.isMultiline = true
        bubbleText.preferredSize = CGSize(width: bubble.frame.width - 40, height: bubble.frame.height)
        setBubbleText()
    }
    
    private func setupContinueButton() {
        continueButton.action = { [weak self] in
            guard let self = self else { return }
            AudioManager.playSoundEffect(.next)
            if self.dialogueIndex < self.dialogue.count - 1 {
                self.continueButton.alpha = 0.5
                self.continueButton.isUserInteractionEnabled = false
                self.dialogueIndex += 1
                self.setBubbleText()
            } else if let view = self.view {
                view.presentScene(NoticeScene(size: view.frame.size), transition: .fade(withDuration: 2.0))
            }
        }
        continueButton.alpha = 0.5
        continueButton.isUserInteractionEnabled = false
    }
    
    private func setupRobot() {
        let actions1 = SKAction.group([
            .rotate(byAngle: 10 * .pi / 180, duration: 2),
            .moveBy(x: 10, y: 10, duration: 2)
        ])
        let actions2 = SKAction.group([
            .rotate(byAngle: -10 * .pi / 180, duration: 2),
            .moveBy(x: -10, y: -10, duration: 2)
        ])
        robot.position = CGPoint(x: -(robot.frame.width / 3), y: 0)
        robot.size = CGSize(width: 350, height: 350)
        robot.zRotation = 25 * .pi / 180
        robot.run(.repeatForever(.sequence([actions1, actions2])))
    }
    
    private func setupSkipButton() {
        let x = frame.maxX - skipButton.frame.width / 2 - 20
        let y = frame.maxY - 100
        skipButton.action = { [weak self] in
            guard let view = self?.scene?.view else { return }
            AudioManager.playSoundEffect(.next)
            view.presentScene(NoticeScene(size: view.frame.size), transition: .fade(withDuration: 2.0))
        }
        skipButton.position = CGPoint(x: x, y: y)
        addChild(skipButton)
    }
    
    private func setupButtonsStack() {
        buttonsStack.setSubviews([backButton, continueButton])
    }
    
    private func setupBubbleStack() {
        bubbleStack.setSubviews([bubble, buttonsStack])
    }
    
    private func setupMessageStack() {
        messageStack.position = CGPoint(x: frame.midX, y: frame.midY)
        messageStack.setSubviews([robot, bubbleStack])
        addChild(messageStack)
    }
    
}
