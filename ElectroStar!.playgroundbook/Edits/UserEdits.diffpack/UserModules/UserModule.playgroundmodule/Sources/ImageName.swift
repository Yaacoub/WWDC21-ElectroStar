struct ImageName {
    
    
    
    //MARK:- Properties
    
    let name: String
    
    static let background = ImageName("Background_1.png")
    static let backgroundStars = ImageName("Background_Stars.png")
    static let iconArrowDown = ImageName("Icon_Arrow_Down.png")
    static let iconBack = ImageName("Icon_Back.png")
    static let iconIPadRotateLeft = ImageName("Icon_iPad_Rotate_Left.png")
    static let iconIPadRotateRight = ImageName("Icon_iPad_Rotate_Right.png")
    static let iconLockRotation = ImageName("Icon_Lock_Rotation.png")
    static let iconPause = ImageName("Icon_Pause.png")
    static let iconPlay = ImageName("Icon_Play.png")
    static let iconRestart = ImageName("Icon_Restart.png")
    static let iconSkip = ImageName("Icon_Skip.png")
    static let particleNegative = ImageName("Particle_Negative.png")
    static let particlePositive = ImageName("Particle_Positive.png")
    static let powerupQ = ImageName("Powerup_q.png")
    static let robot = ImageName("Robot.png")
    
    
    
    //MARK:- Init
    
    private init(_ name: String) {
        self.name = name
    }
    
}
