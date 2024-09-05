import SpriteKit

final class PYRobot: SKNode {
    
    
    
    //MARK:- Private Properties
    
    private var robotSize = CGSize(width: 200, height: 200)
    
    private var robot = SKSpriteNode(image: .robot)
    private var fieldNegative = SKFieldNode.electricField()
    private var fieldPositive = SKFieldNode.electricField()
    
    
    
    //MARK:- Init
    
    override init() {
        super.init()
        setup()
        setupRobot()
        setupFields()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK:- Private Methods
    
    private func setup() {
        guard let texture = robot.texture else { return }
        physicsBody = SKPhysicsBody(texture: texture, size: robotSize)
        physicsBody?.affectedByGravity = false
        physicsBody?.isDynamic = false
        physicsBody?.usesPreciseCollisionDetection = true
    }
    
    private func setupRobot() {
        robot.position = .zero
        robot.size = robotSize
        addChild(robot)
    }
    
    private func setupFields() {
        fieldNegative.falloff = 0
        fieldNegative.position = CGPoint(x: 100, y: 0)
        fieldNegative.strength = -0.2
        fieldPositive.falloff = 0
        fieldPositive.position = CGPoint(x: -100, y: 0)
        fieldPositive.strength = 0.2
        robot.addChild(fieldNegative)
        robot.addChild(fieldPositive)
    }
    
    
    
    //MARK:- Methods
    
    func adjustFieldStrength(for type: PYParticle.ParticleType) {
        fieldNegative.strength = type == .negative ? -0.09 : -0.1
        fieldPositive.strength = type == .negative ? 0.1 : 0.09
    }
    
    func animateDamage() {
        guard let contactBitMask = physicsBody?.contactTestBitMask else { return }
        let action = SKAction.sequence([
            .run { [weak self] in self?.physicsBody?.contactTestBitMask = 0 },
            .fadeOut(withDuration: 0.5),
            .fadeIn(withDuration: 0.5),
            .fadeOut(withDuration: 0.5),
            .fadeIn(withDuration: 0.5),
            .run { [weak self] in self?.physicsBody?.contactTestBitMask = contactBitMask }
        ])
        run(action)
    }
    
}
