
import UIKit

class Shape {
    var faceits = [Facet]()
    var center = Point3D(x: 0, y: 0, z: 0)
}

extension Shape {
    static func edges(of faces: [Facet]) -> [Edge] {
        var allEdges = [Edge]()
        for faceit in faces {
            for edge in faceit.edges {
                guard let index = allEdges.index(where: { $0 == edge }) else { continue }
                allEdges[index] = edge
            }
        }
        return allEdges
    }
}
