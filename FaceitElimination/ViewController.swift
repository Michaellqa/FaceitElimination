
import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    let testShape: Shape3D = {
        let s = Shape3D()
        let mainWidth: CGFloat = 40
//        let neckWidth: CGFloat = 15
//        let cornWidth: CGFloat = 17
        
        // bottom
        let p0 = Point3D(x: -mainWidth, y: -mainWidth, z: -100)
        let p1 = Point3D(x: -mainWidth, y: mainWidth, z: -100)
        let p2 = Point3D(x: mainWidth, y: mainWidth, z: -100)
        let p3 = Point3D(x: mainWidth, y: -mainWidth, z: -100)
        // mid
        let p4 = Point3D(x: -mainWidth, y: -mainWidth, z: 50)
        let p5 = Point3D(x: -mainWidth, y: mainWidth, z: 50)
        let p6 = Point3D(x: mainWidth, y: mainWidth, z: 50)
        let p7 = Point3D(x: mainWidth, y: -mainWidth, z: 50)
        
        s.faceits = [
            Faceit(withPoints: [p0, p1, p2, p3]),
            Faceit(withPoints: [p0, p1, p5, p4]),
            Faceit(withPoints: [p1, p2, p6, p5]),
            Faceit(withPoints: [p2, p3, p7, p6]),
            Faceit(withPoints: [p3, p0, p4, p7])
        ]
        
//        // neck bottom
//        Point3D(x: -neckWidth, y: -neckWidth, z: 75),
//        Point3D(x: -neckWidth, y: neckWidth, z: 75),
//        Point3D(x: neckWidth, y: neckWidth, z: 75),
//        Point3D(x: neckWidth, y: -neckWidth, z: 75),
//        // neck top
//        Point3D(x: -neckWidth, y: -neckWidth, z: 120),
//        Point3D(x: -neckWidth, y: neckWidth, z: 120),
//        Point3D(x: neckWidth, y: neckWidth, z: 120),
//        Point3D(x: neckWidth, y: -neckWidth, z: 120),
//        // cork bottom
//        Point3D(x: -cornWidth, y: -cornWidth, z: 125),
//        Point3D(x: -cornWidth, y: cornWidth, z: 125),
//        Point3D(x: cornWidth, y: cornWidth, z: 125),
//        Point3D(x: cornWidth, y: -cornWidth, z: 125),
//        // cork top
//        Point3D(x: -cornWidth, y: -cornWidth, z: 145),
//        Point3D(x: -cornWidth, y: cornWidth, z: 145),
//        Point3D(x: cornWidth, y: cornWidth, z: 145),
//        Point3D(x: cornWidth, y: -cornWidth, z: 145)
        
        return s
    }()
    
    @IBAction func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: drawerView)
        ShapeChanger.move(shape: drawerView.shape!, x: translation.x, y: 0, z: -translation.y)
        drawerView.setNeedsDisplay()
        sender.setTranslation(CGPoint(x: 0, y: 0), in: drawerView)
    }
    
    @IBAction func handlePinch(_ sender: UIPinchGestureRecognizer) {
//        let scaledShape = ShapeChanger.scale(shape: drawerView.shape!, value: sender.scale)
//        drawerView.drawShape(scaledShape)
//        sender.scale = 1
    }
    
    @IBAction func handleRotation(_ sender: UIRotationGestureRecognizer) {
//        let turnedShape = ShapeChanger.rotateZ(shape: drawerView.shape!, angle: sender.rotation)
//        drawerView.drawShape(turnedShape)
//        sender.rotation = 0
    }
    
    @IBOutlet weak var drawerView: DrawerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShapeChanger.move(shape: testShape, x: view.center.x, y: 0, z: -view.center.y)
        drawerView.shape = testShape
        drawerView.setNeedsDisplay()
//        TUtuTUtuTUTU()
    }
    
    
    func TUtuTUtuTUTU() {
        animate(times: 60, withDelay: 12000) { ShapeChanger.move(shape: self.drawerView.shape!, x: 0, y: 0, z: -1) }
    }
    
    func animate(times: Int, withDelay delay: Int, foo: @escaping () -> Void) {
        DispatchQueue.global().async {
            while true {
                for _ in 1...times {
                    usleep(useconds_t(delay))
                    DispatchQueue.main.async {
                        foo()
                        self.drawerView.setNeedsDisplay()
                    }
                }
            }
        }
    }
}











