import SpriteKit

final class PYDashboard: SKNode {
    
    
    
    //MARK:- Private Properties
    
    private var decreaseArrow1 = SKSpriteNode(image: .iconArrowDown)
    private var decreaseArrow2 = SKSpriteNode(image: .iconArrowDown)
    private var equationLeftSideLabel = SKLabelNode(font: .caption)
    private var equationMiddleLabel = SKLabelNode(font: .caption)
    private var equationRightSideLabel = SKLabelNode(font: .caption)
    private var healthBar = SKShapeNode(rectOf: CGSize(width: 120, height: 20), cornerRadius: 1)
    private var healthBarColor = SKSpriteNode()
    private var healthBarLabel = SKLabelNode(font: .caption2)
    private var recalibrateButton = SKButtonNode(title: "Recalibrate", size: CGSize(width: 120, height: 30), style: .blueDashboard)
    
    private var dashboardStack = SKStackNode(axis: .vertical, spacing: 20)
    private var equationStack = SKStackNode(axis: .horizontal, spacing: 15)
    private var healthStack = SKStackNode(axis: .vertical, spacing: 10)
    
    
    
    //MARK:- Properties
    
    private(set) var health = 100
    var recalibrationSubject: SKNode? = nil
    
    
    
    //MARK:- Init
    
    override init() {
        super.init()
        setup()
        setupDecreaseArrows()
        setupEquationLabels()
        setupHealthBar()
        setupRecalibrateButton()
        setupStacks()
        continuoulsyGainHealth()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK:- Override
    
    override var frame: CGRect {
        calculateAccumulatedFrame()
    }
    
    
    
    //MARK:- Private Methods
    
    private func continuoulsyGainHealth() {
        run(.repeatForever(.sequence([
            .wait(forDuration: 2),
            .run { [weak self] in
                guard let self = self, self.health ?? 100 < 100 else { return }
                self.health += 1
                self.setHealth(self.health, completion: nil)
            }
        ])))
    }
    
    private func setup() {
        zPosition = 10
    }
    
    private func setupDecreaseArrows() {
        decreaseArrow1.alpha = 0
        decreaseArrow1.size = CGSize(width: 10, height: 10)
        decreaseArrow2.alpha = 0
        decreaseArrow2.size = CGSize(width: 10, height: 10)
    }
    
    private func setupEquationLabels() {
        for label in [equationLeftSideLabel, equationMiddleLabel, equationRightSideLabel] {
            label.fontColor = .ghostWhite
            label.horizontalAlignmentMode = .center
            label.verticalAlignmentMode = .center
        }
        equationLeftSideLabel.text = "F"
        equationMiddleLabel.text = "="
        equationRightSideLabel.text = "qE"
    }
    
    private func setupHealthBar() {
        let stroke: CGFloat = 2
        let height = healthBar.frame.height - 2 * stroke
        let width = healthBar.frame.width - 2 * stroke
        healthBar.fillColor = .xiketic
        healthBar.strokeColor = .ghostWhite
        healthBar.lineWidth = stroke
        healthBarColor.anchorPoint = CGPoint(x: 0, y: 0.5)
        healthBarColor.color = .bluePigment
        healthBarColor.position = CGPoint(x: -healthBar.frame.width / 2 + stroke, y: 0)
        healthBarColor.size = CGSize(width: width, height: height)
        healthBarLabel.fontColor = .ghostWhite
        healthBarLabel.horizontalAlignmentMode = .center
        healthBarLabel.position = CGPoint(x: 0, y: 0)
        healthBarLabel.text = "Health (100)"
        healthBarLabel.verticalAlignmentMode = .center
        healthBar.addChild(healthBarColor)
    }
    
    private func setupRecalibrateButton() {
        recalibrateButton.action = { [weak self] in
            AudioManager.playSoundEffect(.next)
            self?.recalibrationSubject?.zRotation = 0
        }
    }
    
    private func setupStacks() {
        equationStack.setSubviews([decreaseArrow1, equationLeftSideLabel, equationMiddleLabel,
                                   equationRightSideLabel, decreaseArrow2])
        healthStack.setSubviews([healthBarLabel, healthBar])
        dashboardStack.setSubviews([equationStack, healthStack, recalibrateButton])
        addChild(dashboardStack)
    }
    
    
    
    //MARK:- Functions
    
    func temporarilyDecreaseCharge(action: @escaping (_ hasEnded: Bool) -> ()) {
        run(.sequence([
            .run { [weak self] in
                self?.decreaseArrow1.run(.fadeIn(withDuration: 1))
                self?.decreaseArrow2.run(.fadeIn(withDuration: 1))
                action(false)
            },
            .wait(forDuration: 60),
            .run { [weak self] in
                self?.decreaseArrow1.run(.fadeOut(withDuration: 1))
                self?.decreaseArrow2.run(.fadeOut(withDuration: 1))
                action(true)
            }
        ]))
    }
    
    func setHealth(_ health: Int, completion: ((_ isAlive: Bool) -> ())?) {
        self.health = health
        if health > 0 {
            let percent = CGFloat(health) / 100
            let initialWidth = healthBar.frame.width - 2 * healthBar.lineWidth
            healthBarColor.color = UIColor.blend(.bluePigment, with: .redRYB, factor: percent) ?? .bluePigment
            healthBarColor.size.width = initialWidth * percent
            healthBarLabel.text = "Health (\(health))"
            completion?(true)
        } else {
            healthBarColor.size.width = 0
            healthBarLabel.text = "Health (0)"
            completion?(false)
        }
    }
    
}
