import SpriteKit

final class PYParticle: SKNode {
    
    
    
    //MARK:- Private Properties
    
    private let initContactTestBitMask: UInt32
    
    private var image: ImageName {
        switch type {
        case .negative: return .particleNegative
        case .positive: return .particlePositive
        case .powerupQ: return .powerupQ
        }
    }
    
    private var multiplier: CGFloat {
        switch type {
        case .negative: return -1
        case .positive: return 1
        default: return 0
        }
    }
    
    private var particle = SKSpriteNode()
    
    
    
    //MARK:- Properties
    
    let chargeMultiplier: CGFloat
    let type: ParticleType
    
    var checkToRemoveDuration = 2.0
    var isRemovedAutomatically = true
    
    
    
    //MARK:- Enums
    
    enum ParticleType {
        case negative, positive, powerupQ
    }
    
    
    
    //MARK:- Init
    
    init(type: ParticleType, chargeMultiplier: CGFloat, contactTestBitMask: UInt32 = 0) {
        self.type = type
        self.chargeMultiplier = chargeMultiplier
        self.initContactTestBitMask = contactTestBitMask
        super.init()
        setup()
        setupParticle()
        continuouslyCheckToRemove()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK:- Private Methods
    
    private func continuouslyCheckToRemove() {
        run(.repeatForever(.sequence([
            .wait(forDuration: checkToRemoveDuration),
            .run { [weak self] in
                guard let self = self, let parent = self.parent, self.isRemovedAutomatically else { return }
                let radius = sqrt(pow(parent.frame.width, 2) + pow(parent.frame.height, 2)) / 2
                guard (self.frame.minX > parent.frame.midX + radius + 50 && self.frame.minY > parent.frame.midY + radius + 50) ||
                        (self.frame.minX > parent.frame.midX + radius + 50 && self.frame.maxY < parent.frame.midY - radius - 50) ||
                        (self.frame.maxX < parent.frame.midX - radius - 50 && self.frame.maxY < parent.frame.midY - radius - 50) ||
                        (self.frame.maxX < parent.frame.midX - radius - 50 && self.frame.minY > parent.frame.midY + radius + 50)
                else { return }
                self.removeFromParent()
            }
        ])))
    }
    
    private func setup() {
        physicsBody = SKPhysicsBody(circleOfRadius: 25)
        physicsBody?.contactTestBitMask = initContactTestBitMask
        physicsBody?.isDynamic = true
        physicsBody?.usesPreciseCollisionDetection = true
        switch type {
            case .negative, .positive:
                physicsBody?.affectedByGravity = false
                physicsBody?.charge = 2 * multiplier * chargeMultiplier
            default:
                physicsBody?.affectedByGravity = true
                physicsBody?.charge = 0
                physicsBody?.linearDamping = 10
        }
    }
    
    private func setupParticle() {
        particle.position = .zero
        particle.size = CGSize(width: 50, height: 50)
        particle.setImage(image)
        addChild(particle)
    }
    
    
    
    //MARK:- Methods
    
    func spawn(around parent: SKNode, direction: CGFloat) {
        let radius = sqrt(pow(parent.frame.width, 2) + pow(parent.frame.height, 2)) / 2
        let xOffset = (radius + parent.frame.size.width) * multiplier * cos(direction)
        let yOffset = (radius + parent.frame.size.height) * multiplier * sin(direction)
        switch type {
        case .negative, .positive:
            position = CGPoint(x: parent.frame.midX + xOffset, y: parent.frame.midY + yOffset)
        default:
            let y = parent.frame.maxY + particle.size.height / 2
            position = CGPoint(x: parent.frame.midX, y: y)
        }
        parent.addChild(self)
    }
    
    func disintegrate() {
        let action = SKAction.group([
            .scale(by: 1.5, duration: 1),
            .fadeOut(withDuration: 1),
            .run { [weak self] in self?.physicsBody = nil }
        ])
        run(.sequence([action, .removeFromParent()]))
    }
    
}
