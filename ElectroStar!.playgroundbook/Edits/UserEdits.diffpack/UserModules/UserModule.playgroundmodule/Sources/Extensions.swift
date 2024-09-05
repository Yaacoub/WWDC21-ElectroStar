import SpriteKit
import UIKit

extension SKButtonNode {
    
    convenience init(iconName: ImageName, size: CGSize, style: Style = .default) {
        self.init(iconName: iconName.name, size: size, style: style)
    }
    
    func setIcon(named iconName: ImageName) {
        setIcon(named: iconName.name)
    }
    
}

extension SKButtonNode.Style {
    
    static let blueDashboard = SKButtonNode.Style(color: .glaucous, cornerCurve: 0.25, font: .caption2, fontColor: .ghostWhite, strokeColor: .ghostWhite, strokeWidth: 5)
    static let blueMain = SKButtonNode.Style(color: .glaucous, cornerCurve: 0.25, font: .body, fontColor: .ghostWhite, strokeColor: .ghostWhite, strokeWidth: 5)
    
}

extension SKLabelNode {
    
    convenience init(font: UIFont) {
        self.init(fontNamed: font.fontName)
        fontSize = font.pointSize
    }
    
    convenience init(text: String, font: UIFont) {
        self.init(text: text)
        fontName = font.fontName
        fontSize = font.pointSize
    }
    
}

extension SKSpriteNode {
    
    convenience init(image name: ImageName) {
        self.init(imageNamed: name.name)
    }
    
    func setImage(_ name: ImageName) {
        texture = SKTexture(imageNamed: name.name)
    }
    
}

extension UIColor {
    
    static let bluePigment = UIColor(red: 54 / 255, green: 38 / 255, blue: 167 / 255, alpha: 1)
    static let ghostWhite = UIColor(red: 251 / 255, green: 251 / 255, blue: 255 / 255, alpha: 1)
    static let glaucous = UIColor(red: 101 / 255, green: 126 / 255, blue: 212 / 255, alpha: 1)
    static let redRYB = UIColor(red: 255 / 255, green: 51 / 255, blue: 31 / 255, alpha: 1)
    static let xiketic = UIColor(red: 13 / 255, green: 1 / 255, blue: 6 / 255, alpha: 1)
    
    static func blend(_ color1: UIColor, with color2: UIColor, factor: CGFloat) -> UIColor? {
        guard let rgba1 = color1.rgba(), let rgba2 = color2.rgba() else { return nil }
        let red = rgba1.red * factor + rgba2.red * (1 - factor)
        let green = rgba1.green * factor + rgba2.green * (1 - factor)
        let blue = rgba1.blue * factor + rgba2.blue * (1 - factor)
        let alpha = rgba1.alpha * factor + rgba2.alpha * (1 - factor)
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func rgba() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }
        return (red: red, green: green, blue: blue, alpha: alpha)
    }
    
}

extension UIFont {
    
    static let body = UIFont(name: "Menlo-Bold", size: 33)!
    static let caption = UIFont(name: "Menlo-Bold", size: 25)!
    static let caption2 = UIFont(name: "Menlo-Bold", size: 16)!
    static let title = UIFont(name: "Menlo-Bold", size: 77)!
    
}
