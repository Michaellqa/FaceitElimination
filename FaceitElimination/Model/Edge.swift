
import UIKit

struct Edge: Comparable {
    let start: Point3D
    let end: Point3D
    
    static func <(lhs: Edge, rhs: Edge) -> Bool {
        return false // cap
    }
    static func ==(lhs: Edge, rhs: Edge) -> Bool {
        return (lhs.start == rhs.start && lhs.end == rhs.end) ? true : false
    }
}
