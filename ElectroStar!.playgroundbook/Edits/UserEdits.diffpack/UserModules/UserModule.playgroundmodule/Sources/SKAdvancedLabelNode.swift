import SpriteKit

class SKAdvancedLabelNode: SKNode {
    
    
    
    //MARK:- Private Properties
    
    private var hiddenSprite = SKSpriteNode()
    private var label = SKLabelNode()
    private var totalText = ""
    
    
    
    //MARK:- Properties
    
    var allowsAnimationSkip = false
    var color: UIColor? = .white { didSet { label.fontColor = color } }
    var font: UIFont? = nil {
        didSet {
            label.fontName = font?.fontName ?? label.fontName
            label.fontSize = font?.pointSize ?? label.fontSize
        }
    }
    var isMultiline = false { didSet { label.numberOfLines = isMultiline ? 0 : 1 } }
    var preferredSize: CGSize = .zero {
        didSet {
            hiddenSprite.size = preferredSize
            label.preferredMaxLayoutWidth = preferredSize.width
        }
    }
    var text: String? { label.text }
    
    
    
    //MARK:- Enum
    
    enum TypingAnimation {
        case none, progressive
    }
    
    
    
    //MARK:- Init
    
    init(text: String, animation: TypingAnimation = .none) {
        super.init()
        setup()
        setText(text, animation: animation)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK:- Override
    
    override var frame: CGRect { label.frame }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard allowsAnimationSkip else { return }
        skipAnimation(text: totalText, completion: nil)
    }
    
    
    
    //MARK:- Private Methods
    
    private func setup() {
        hiddenSprite.color = .clear
        hiddenSprite.position = CGPoint(x: 0, y: 0)
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        isUserInteractionEnabled = true
        addChild(hiddenSprite)
        addChild(label)
    }
    
    private func startProgressiveAnimation(text: String, completion: (() -> ())?) {
        var index = text.startIndex
        func animate() {
            guard label.text != text, index != text.endIndex else {
                completion?()
                return
            }
            let setText = SKAction.run { [weak self] in
                guard self?.label.text != text else { return }
                self?.label.text = String(text[..<index])
            }
            index = text.index(after: index)
            run(.sequence([.wait(forDuration: 0.08), setText]), completion: animate)
        }
        animate()
    }
    
    private func skipAnimation(text: String, completion: (() -> ())?) {
        guard label.text != text else { return }
        label.text = text
        completion?()
    }
    
    
    
    //MARK:- Methods
    
    func setText(_ text: String, animation: TypingAnimation, completion: (() -> ())? = nil) {
        totalText = text
        switch animation {
        case .progressive:
            startProgressiveAnimation(text: text, completion: completion)
        default:
            skipAnimation(text: text, completion: completion)
        }
    }
    
}
