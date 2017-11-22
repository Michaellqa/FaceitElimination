
import UIKit

public struct Edge: Comparable {
    let start: Point3D
    let end: Point3D
    
    public static func <(lhs: Edge, rhs: Edge) -> Bool {
        return false // cap
    }
    public static func ==(lhs: Edge, rhs: Edge) -> Bool {
        return (lhs.start == rhs.start && lhs.end == rhs.end) || (lhs.start == rhs.end && lhs.end == rhs.start) ? true : false
    }
}
// X
extension Edge {
    func cut(range: ClosedRange<CGFloat>) -> [Edge] {
        if range.lowerBound < 0 || range.upperBound > 1 { return [self] }
        if range.lowerBound >= 1 || range.upperBound <= 0 { return [self] }
        let vector = end - start
        let minCut = start + (vector * range.lowerBound)
        let maxCut = start + (vector * range.upperBound)
        if range.lowerBound == 0 { return [Edge(start: maxCut, end: end)] }
        if range.upperBound == 1 { return [Edge(start: start, end: minCut)] }
        return [Edge(start: start, end: minCut), Edge(start: maxCut, end: end)]
    }
}
