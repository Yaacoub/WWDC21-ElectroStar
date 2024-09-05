import SpriteKit

public final class Level1Scene: SKScene {
    
    
    
    //MARK:- Private Properties
    
    private let contactBitMask: UInt32 = 0x1 << 0
    
    private var globalChargeMultiplier: CGFloat = 1
    private var levelState = LevelState.wave1
    
    private var background = SKSpriteNode(image: .background)
    private var backgroundStars = SKSpriteNode(image: .backgroundStars)
    private var dashboard = PYDashboard()
    private var levelStateLabel = SKLabelNode(font: .body)
    private var pausable = SKNode()
    private var pauseInterface = PYPauseInterface()
    private var robot = PYRobot()
    
    
    
    //MARK:- Enums
    
    private enum LevelState: Int {
        
        case gameOverLoss = 0
        case wave1, wave2, wave3, wave4
        case gameOverSuccess
        
        static let negatives = [LevelState.wave2, wave4]
        static let positives = [LevelState.wave1, wave3]
        static let withPowerup = [LevelState.wave2]
        
        func next() -> LevelState? {
            guard let next = LevelState(rawValue: rawValue + 1) else { return nil }
            return next
        }
        
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
        setup()
        setupBackground()
        setupDashboard()
        setupLevelStateLabel()
        setupPauseInterface()
        setupRobot()
        adjustLevel(for: levelState)
        continuouslyCheckLevelState()
    }
    
    public override func update(_ currentTime: TimeInterval) {
        guard !pauseInterface.isPausingScene else { return }
        backgroundStars.updateParallax(parallaxEffect: .high)
        robot.updateGyroRotation()
    }    
    
    
    
    //MARK:- Private Methods (Setup)
    
    private func setup() {
        physicsWorld.contactDelegate = self
        addChild(pausable)
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
    
    private func setupDashboard() {
        let x = frame.maxX - dashboard.frame.width / 2 - 20
        let y = frame.minY + dashboard.frame.height / 2 + 100
        dashboard.recalibrationSubject = robot
        dashboard.position = CGPoint(x: x, y: y)
        addChild(dashboard)
    }
    
    private func setupLevelStateLabel() {
        levelStateLabel.fontColor = .ghostWhite
        levelStateLabel.horizontalAlignmentMode = .center
        levelStateLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        levelStateLabel.verticalAlignmentMode = .center
        addChild(levelStateLabel)
    }
    
    private func setupPauseInterface() {
        let x = frame.maxX - pauseInterface.frame.width / 2 - 20
        let y = frame.maxY - 100
        pauseInterface.position = CGPoint(x: x, y: y)
        addChild(pauseInterface)
    }
    
    private func setupRobot() {
        robot.physicsBody?.contactTestBitMask = contactBitMask
        robot.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(robot)
    }
    
    
    
    //MARK:- Private Methods (Setup)
    
    private func adjustLevel(for state: LevelState) {
        levelState = state
        switch levelState {
        case .gameOverLoss:
            AudioManager.playSoundEffect(.loss)
            levelStateLabel.text = "GAME OVER"
            pauseInterface.stopScene()
        case .gameOverSuccess:
            AudioManager.playSoundEffect(.success)
            levelStateLabel.text = "SUCCESS!"
            pauseInterface.stopScene()
        default:
            if levelState != .wave1 { AudioManager.playSoundEffect(.newWave) }
            levelStateLabel.text = "WAVE \(levelState.rawValue)"
            startWave(for: levelState)
        }
    }
    
    private func continuouslyCheckLevelState() {
        pausable.run(.repeatForever(.sequence([
            .wait(forDuration: 2),
            .run { [weak self] in
                guard let self = self, !self.children.contains(where: { $0 is PYParticle }),
                      self.levelState != .gameOverLoss, let state = self.levelState.next() else { return }
                self.adjustLevel(for: state)
            }
        ])))
    }
    
    private func startWave(for state: LevelState) {
        let multiplier = CGFloat(state.rawValue) * 2.5 * globalChargeMultiplier
        let type = state.rawValue % 2 == 0 ? PYParticle.ParticleType.negative : .positive
        let spawnParticles = SKAction.repeat(.sequence([
            .run { [weak self] in
                guard let self = self else { return }
                PYParticle(type: type, chargeMultiplier: multiplier, contactTestBitMask: self.contactBitMask)
                    .spawn(around: self, direction: self.robot.zRotation)
            },
            .wait(forDuration: 2)
        ]), count: 10)
        let spawnPowerup = SKAction.run { [weak self] in
            guard let self = self, LevelState.withPowerup.contains(state) else { return }
            PYParticle(type: .powerupQ, chargeMultiplier: 0, contactTestBitMask: self.contactBitMask)
                .spawn(around: self, direction: self.robot.zRotation)
        }
        robot.adjustFieldStrength(for: type)
        pausable.run(.sequence([spawnParticles, spawnPowerup]))
    }
    
}



//MARK:- Extensions

extension Level1Scene: SKPhysicsContactDelegate {
    
    public func didBegin(_ contact: SKPhysicsContact) {
        let nodes = [contact.bodyA.node, contact.bodyB.node].compactMap { $0 }
        guard let particle = nodes.first(where: { $0 is PYParticle }) as? PYParticle,
              let robot = nodes.first(where: { $0 is PYRobot }) as? PYRobot else { return }
        switch particle.type {
        case .negative, .positive:
            AudioManager.playSoundEffect(.damage)
            dashboard.setHealth(dashboard.health - 20) { [weak self] (isAlive) in
                guard !isAlive else { return }
                self?.adjustLevel(for: .gameOverLoss)
            }
            robot.animateDamage()
        default:
            AudioManager.playSoundEffect(.powerup)
            dashboard.temporarilyDecreaseCharge { [weak self] (hasEnded) in
                self?.globalChargeMultiplier /= hasEnded ? 1 : 2
            }
        }
        particle.disintegrate()
    }
    
}
