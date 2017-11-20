
import UIKit

struct Point3D: Comparable {
    let x: CGFloat
    let y: CGFloat
    let z: CGFloat
    
    init(x: CGFloat, y: CGFloat, z: CGFloat) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    static func +(p1: Point3D, p2: Point3D) -> Point3D {
        return Point3D(x: p1.x + p2.x, y: p1.y + p2.y, z: p1.z + p2.z)
    }
    static func <(lhs: Point3D, rhs: Point3D) -> Bool {
        return false
    }
    static func ==(lhs: Point3D, rhs: Point3D) -> Bool {
        return (lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z) ? true : false
    }
}
