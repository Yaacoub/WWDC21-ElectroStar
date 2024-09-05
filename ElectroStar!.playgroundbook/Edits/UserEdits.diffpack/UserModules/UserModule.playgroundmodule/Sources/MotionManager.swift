import CoreMotion
import SpriteKit

class MotionManager {
    
    
    
    //MARK:- Private Properties
    
    private static let motionManager = CMMotionManager()
    private static var didSetup = false
    fileprivate static var gyroNodes = [GyroNode]()
    fileprivate static var parallaxNodes = [ParallaxNode]()
    
    
    
    //MARK:- Init
    
    private init() {}
    
    
    
    //MARK:- Classes
    
    class GyroNode {
        
        fileprivate var rotationZ: CGFloat = 0
        let node: SKNode
        
        init(_ node: SKNode) { self.node = node }
        
        fileprivate func updateGyroRotation() {
            guard let motionData = motionManager.deviceMotion else { return }
            guard abs(motionData.rotationRate.z) > 0.05 else { return }
            rotationZ = ((rotationZ * (1 - 0.25) + CGFloat(motionData.rotationRate.z) * 0.25)) / 10
            node.zRotation += rotationZ
        }
        
    }
    
    class ParallaxNode {
        
        fileprivate var initialPosition = Point.zero
        fileprivate var initialTilt = Point.zero
        fileprivate var tiltX: CGFloat = 0
        fileprivate var tiltY: CGFloat = 0
        let node: SKNode
        
        init(_ node: SKNode) { self.node = node }
        
        fileprivate func updateParallax(parallaxEffect effect: ParallaxEffect) {
            guard let motionData = motionManager.accelerometerData else { return }
            if initialPosition == .zero {
                initialPosition = Point(x: node.position.x, y: node.position.y)
            }
            tiltX = (tiltX * (1 - 0.25) + CGFloat(motionData.acceleration.x) * 0.25) - initialTilt.x
            tiltY = (tiltY * (1 - 0.25) + CGFloat(motionData.acceleration.y) * 0.25) - initialTilt.y
            if initialTilt == .zero {
                initialTilt = Point(x: tiltX, y: tiltY)
            }
            let effectValue = CGFloat(effect.rawValue)
            let newX = initialPosition.x + tiltY * effectValue * 10
            let newY = initialPosition.y + -tiltX * effectValue * 10
            node.position = CGPoint(x: newX, y: newY)
        }
        
    }
    
    
    
    //MARK:- Enum
    
    enum ParallaxEffect: Int {
        case low = 1
        case medium = 2
        case high = 4
    }
    
    
    
    //MARK:- Structs
    
    fileprivate struct Point: Hashable {
        var (x, y): (CGFloat, CGFloat)
        static let zero = Point(x: 0, y: 0)
    }
    
    
    
    //MARK:- Private Methods
    
    private static func setup() {
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates()
        motionManager.startDeviceMotionUpdates()
        didSetup = true
    }
    
    fileprivate static func updateGyroRotation(for node: SKNode) {
        if !didSetup { setup() }
        let nodes = gyroNodes.map { $0.node }
        if !nodes.contains(node) { gyroNodes.append(GyroNode(node)) }
        guard let gyroNode = gyroNodes.first(where: { $0.node == node }) else { return }
        gyroNode.updateGyroRotation()
    }
    
    fileprivate static func updateParallax(for node: SKNode, parallaxEffect effect: ParallaxEffect) {
        if !didSetup { setup() }
        let nodes = parallaxNodes.map { $0.node }
        if !nodes.contains(node) { parallaxNodes.append(ParallaxNode(node)) }
        guard let parallaxNode = parallaxNodes.first(where: { $0.node == node }) else { return }
        parallaxNode.updateParallax(parallaxEffect: effect)
    }
    
}

extension SKNode {
    
    func updateGyroRotation() {
        MotionManager.updateGyroRotation(for: self)
    }
    
    func updateParallax(parallaxEffect effect: MotionManager.ParallaxEffect) {
        MotionManager.updateParallax(for: self, parallaxEffect: effect)
    }
    
}
