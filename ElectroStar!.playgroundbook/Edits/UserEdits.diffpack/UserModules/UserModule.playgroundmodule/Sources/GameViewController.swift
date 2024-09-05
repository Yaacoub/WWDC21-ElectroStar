import AVFoundation
import SpriteKit
import UIKit

public class GameViewController: UIViewController {
    
    
    
    //MARK:- Override Methods
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public override var shouldAutorotate: Bool {
        return false
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        setupView()
    }
    
    
    
    //MARK:- Private Methods
    
    private func setupAudio() {
        AudioManager.startMusic(.main)
    }
    
    private func setupView() {
        view = SKView(frame: view.frame)
        guard let view = view as! SKView? else { return }
        let scene = TitleScene(size: view.frame.size)
//          let scene = Level1Scene(size: view.frame.size)
        view.ignoresSiblingOrder = true
//          view.showsFPS = true
//          view.showsNodeCount = true
//          view.showsPhysics = true
        view.presentScene(scene)
    }
    
}
