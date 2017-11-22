
import UIKit

class Shape {
    var faceits = [Facet]()
    var center = Point3D(x: 0, y: 0, z: 0)
}

extension Shape {
    static func edges(of faces: [Facet]) -> [Edge] {
        var allEdges = [Edge]()
        for facet in faces {
            for edge in facet.edges {
                if let index = allEdges.index(where: { $0 == edge }) { continue }
                allEdges.append(edge)
            }
        }
        return allEdges // return empty array all the time
    }
}
