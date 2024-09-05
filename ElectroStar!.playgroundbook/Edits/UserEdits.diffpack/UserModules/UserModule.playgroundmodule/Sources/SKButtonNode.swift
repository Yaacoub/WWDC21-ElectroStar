import SpriteKit

class SKButtonNode: SKNode {
    
    
    
    //MARK:- Private Properties
    
    private var cancelledTouches = Set<UITouch>()
    private var image: SKSpriteNode? = nil
    private var label: SKLabelNode? = nil
    private var shape: SKShapeNode? = nil
    
    
    
    //MARK:- Properties
    
    let size: CGSize
    let style: Style
    
    private(set) var iconName: String?
    private(set) var title: String?
    var action: (() -> ())? = nil
    
    
    
    //MARK:- Structs
    
    struct Style {
        
        let color: UIColor
        let cornerCurve: CGFloat
        let font: UIFont?
        let fontColor: UIColor
        let strokeColor: UIColor
        let strokeWidth: CGFloat
        
        static let `default` = Style(color: .white, cornerCurve: 0.25, font: nil, fontColor: .black, strokeColor: .black, strokeWidth: 0)
        
    }
    
    
    
    //MARK:- Init
    
    init(iconName: String, size: CGSize, style: Style = .default) {
        self.title = nil
        self.iconName = iconName
        self.size = size
        self.style = style
        super.init()
        setupWithIcon()
    }
    
    init(title: String, size: CGSize, style: Style = .default) {
        self.title = title
        self.iconName = nil
        self.size = size
        self.style = style
        super.init()
        setupWithTitle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK:- Override
    
    override var frame: CGRect {
        CGRect(origin: position, size: size)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let spring = 1 - pow(50, 1 / 2) / pow(max(size.width, size.height), 1 / 2) / 5
        let action = SKAction.scale(to: spring, duration: 0.1)
        cancelledTouches = []
        shape?.run(action)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        let spring = 1 + pow(50, 1 / 2) / pow(max(size.width, size.height), 1 / 2) / 10
        let actions = [SKAction.scale(to: spring, duration: 0.1), .scale(to: 1.0, duration: 0.1)]
        shape?.run(SKAction.sequence(actions))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let cancelledTouches = self.cancelledTouches
        self.cancelledTouches = []
        guard touches.intersection(cancelledTouches).isEmpty else { return }
        let spring = 1 + pow(50, 1 / 2) / pow(max(size.width, size.height), 1 / 2) / 10
        let actions = [SKAction.scale(to: spring, duration: 0.1), .scale(to: 1.0, duration: 0.1)]
        shape?.run(SKAction.sequence(actions))
        action?()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let shape = shape else { return }
        for t in touches {
            if !shape.frame.contains(t.location(in: self)) {
                let action = SKAction.scale(to: 1.0, duration: 0.1)
                cancelledTouches.insert(t)
                shape.run(action)
            }
        }
    }
    
    
    
    //MARK:- Private Methods
    
    private func setupWithIcon() {
        guard let iconName = iconName else { return }
        let cornerRadius = size.height * style.cornerCurve
        image = SKSpriteNode(imageNamed: iconName)
        shape = SKShapeNode(rectOf: size, cornerRadius: cornerRadius)
        guard let image = image, let shape = shape else { return }
        image.size = size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
        shape.fillColor = style.color
        shape.strokeColor = style.strokeColor
        shape.lineWidth = style.strokeWidth
        shape.addChild(image)
        isUserInteractionEnabled = true
        addChild(shape)
    }
    
    private func setupWithTitle() {
        guard let title = title else { return }
        let cornerRadius = size.height * style.cornerCurve
        label = SKLabelNode(text: title)
        shape = SKShapeNode(rectOf: size, cornerRadius: cornerRadius)
        guard let label = label, let shape = shape else { return }
        label.fontColor = style.fontColor
        label.fontName = style.font?.fontName ?? label.fontName
        label.fontSize = style.font?.pointSize ?? label.fontSize
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        shape.fillColor = style.color
        shape.strokeColor = style.strokeColor
        shape.lineWidth = style.strokeWidth
        shape.addChild(label)
        isUserInteractionEnabled = true
        addChild(shape)
    }
    
    
    
    //MARK:- Methods
    
    func setIcon(named iconName: String) {
        self.iconName = iconName
        image?.texture = SKTexture(imageNamed: iconName)
    }
    
    func setTitle(_ title: String) {
        self.title = title
        label?.text = title
    }
    
}
