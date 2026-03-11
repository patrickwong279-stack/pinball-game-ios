import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Properties
    var ball: SKShapeNode!
    var leftFlipper: SKShapeNode!
    var rightFlipper: SKShapeNode!
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    // MARK: - Lifecycle
    override func didMove(to view: SKView?) {
        super.didMove(to: view)
        setupPhysics()
        setupScene()
        setupUI()
    }
    
    // MARK: - Setup Methods
    private func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        physicsWorld.contactDelegate = self
    }
    
    private func setupScene() {
        backgroundColor = .black
        
        // Create ball
        ball = SKShapeNode(circleOfRadius: 8)
        ball.fillColor = .white
        ball.strokeColor = .white
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 8)
        ball.physicsBody?.affectedByGravity = true
        ball.physicsBody?.restitution = 0.8
        addChild(ball)
        
        // Create left flipper
        createFlipper(at: CGPoint(x: frame.midX - 50, y: 100), named: "leftFlipper")
        
        // Create right flipper
        createFlipper(at: CGPoint(x: frame.midX + 50, y: 100), named: "rightFlipper")
        
        // Create boundaries
        createBoundaries()
        
        // Create bumpers
        createBumpers()
    }
    
    private func createFlipper(at position: CGPoint, named name: String) {
        let flipper = SKShapeNode(rectOf: CGSize(width: 60, height: 10))
        flipper.fillColor = .yellow
        flipper.strokeColor = .yellow
        flipper.position = position
        flipper.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 10))
        flipper.physicsBody?.affectedByGravity = false
        flipper.physicsBody?.isDynamic = true
        flipper.name = name
        addChild(flipper)
    }
    
    private func createBoundaries() {
        let leftBoundary = SKShapeNode(rectOf: CGSize(width: 10, height: frame.height))
        leftBoundary.fillColor = .gray
        leftBoundary.position = CGPoint(x: 10, y: frame.midY)
        leftBoundary.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: frame.height))
        leftBoundary.physicsBody?.affectedByGravity = false
        leftBoundary.physicsBody?.isDynamic = false
        addChild(leftBoundary)
        
        let rightBoundary = SKShapeNode(rectOf: CGSize(width: 10, height: frame.height))
        rightBoundary.fillColor = .gray
        rightBoundary.position = CGPoint(x: frame.width - 10, y: frame.midY)
        rightBoundary.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: frame.height))
        rightBoundary.physicsBody?.affectedByGravity = false
        rightBoundary.physicsBody?.isDynamic = false
        addChild(rightBoundary)
    }
    
    private func createBumpers() {
        let bumper1 = SKShapeNode(circleOfRadius: 20)
        bumper1.fillColor = .red
        bumper1.position = CGPoint(x: frame.midX - 80, y: frame.midY + 150)
        bumper1.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        bumper1.physicsBody?.affectedByGravity = false
        bumper1.physicsBody?.isDynamic = false
        bumper1.name = "bumper"
        addChild(bumper1)
        
        let bumper2 = SKShapeNode(circleOfRadius: 20)
        bumper2.fillColor = .red
        bumper2.position = CGPoint(x: frame.midX + 80, y: frame.midY + 150)
        bumper2.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        bumper2.physicsBody?.affectedByGravity = false
        bumper2.physicsBody?.isDynamic = false
        bumper2.name = "bumper"
        addChild(bumper2)
    }
    
    private func setupUI() {
        scoreLabel = SKLabelNode(fontNamed: "Arial")
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.height - 50)
        scoreLabel.text = "Score: 0"
        addChild(scoreLabel)
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if location.x < frame.midX {
                activateLeftFlipper()
            } else {
                activateRightFlipper()
            }
        }
    }
    
    private func activateLeftFlipper() {
        if let flipper = childNode(withName: "leftFlipper") {
            let rotateAction = SKAction.rotate(toAngle: CGFloat.pi / 4, duration: 0.1)
            flipper.run(rotateAction)
        }
    }
    
    private func activateRightFlipper() {
        if let flipper = childNode(withName: "rightFlipper") {
            let rotateAction = SKAction.rotate(toAngle: -CGFloat.pi / 4, duration: 0.1)
            flipper.run(rotateAction)
        }
    }
    
    // MARK: - Physics Contact Delegate
    func didBegin(_ contact: SKPhysicsContact) {
        let contactBodies = [contact.bodyA, contact.bodyB]
        
        for body in contactBodies {
            if body.node?.name == "bumper" {
                score += 10
                addBumperEffect(at: body.node?.position ?? .zero)
            }
        }
    }
    
    private func addBumperEffect(at position: CGPoint) {
        let effect = SKShapeNode(circleOfRadius: 20)
        effect.fillColor = .yellow
        effect.position = position
        addChild(effect)
        
        let scaleAction = SKAction.scale(to: 0.1, duration: 0.3)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([scaleAction, removeAction])
        effect.run(sequence)
    }
}