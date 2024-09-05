import SpriteKit

class SKStackNode: SKNode {
    
    
    
    //MARK:- Properties
    
    let axis: Axis
    let spacing: CGFloat
    
    private(set) var subviews: [SKNode]
    
    
    
    //MARK:- Enums
    
    enum Axis {
        case horizontal, vertical
    }
    
    
    
    //MARK:- Init
    
    init(subviews: [SKNode]? = nil, axis: Axis, spacing: CGFloat) {
        self.axis = axis
        self.spacing = spacing
        self.subviews = subviews ?? []
        super.init()
        if !self.subviews.isEmpty { setup() }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK:- Override
    
    override var frame: CGRect {
        calculateAccumulatedFrame()
    }
    
    
    
    //MARK:- Private Methods
    
    private func setup() {
        switch axis {
        case .vertical: setupVertical()
        case .horizontal: setupHorizontal()
        }
    }
    
    private func setupHorizontal() {
        let maxWidth = subviews.reduce(into: CGFloat(0)) { $0 += $1.calculateAccumulatedFrame().width } + spacing * CGFloat(max(0, subviews.count - 1))
        var usedWidth: CGFloat = 0
        for subview in subviews {
            let width = subview.frame.width
            subview.position = CGPoint(x: -((maxWidth - width) / 2 - usedWidth), y: 0)
            usedWidth += width + spacing
            addChild(subview)
        }
    }
    
    private func setupVertical() {
        let maxHeight = subviews.reduce(into: CGFloat(0)) { $0 += $1.calculateAccumulatedFrame().height } + spacing * CGFloat(max(0, subviews.count - 1))
        var usedHeight: CGFloat = 0
        for subview in subviews {
            let height = subview.frame.height
            subview.position = CGPoint(x: 0, y: (maxHeight - height) / 2 - usedHeight)
            usedHeight += height + spacing
            addChild(subview)
        }
    }
    
    
    
    //MARK:- Methods
    
    func insertSubview(_ subview: SKNode, at index: Int) {
        var subviews = self.subviews
        subviews.insert(subview, at: index)
        setSubviews(subviews)
    }
    
    func removeSubview(at index: Int) {
        subviews.remove(at: index)
        setSubviews(subviews)
    }
    
    func setSubviews(_ subviews: [SKNode]) {
        self.subviews = subviews
        setup()
    }
    
}
