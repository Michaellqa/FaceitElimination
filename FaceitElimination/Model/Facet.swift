
import UIKit

class Facet {
    var points: [Point3D]
    
    init(withPoints p: [Point3D]) {
        points = p
    }
}

extension Facet {
    var edges: [Edge] {
        guard points.count > 1 else { return [] }
        var edges = [Edge]()
        
        for index in 0..<points.count-1 {
            edges.append(Edge(start: points[index], end: points[index+1]))
        }
        edges.append(Edge(start: points.last!, end: points.first!))
        return edges
    }
}
