
import UIKit

class DrawerView: UIView {
    
    var zAngle = CGFloat.pi / 180 * 64
    var shape: Shape?
    var color: UIColor = .blue
    
    override func draw(_ rect: CGRect) {
//        color.set()
//        if shape != nil {
//            for face in visibleFaceits() {
//                UIColor.blue.set()
//                let path = pathForFaceit(face)
//                path.stroke()
//            }
//        }
        
        drawEdges()
    }
    
    func pathForFaceit(_ face: Facet) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 2.0
        path.move(to: projector(point: face.points.last!))
        for point in face.points {
            path.addLine(to: projector(point: point))
        }
        return path
    }
    
    func projector(point: Point3D) -> CGPoint {
        let x = point.x + 0.5 * point.y * sin(zAngle)
        let y = -point.z - 0.5 * point.y * cos(zAngle)
        return CGPoint(x: x, y: y)
    }
    // X
    func drawEdges() {
        color.set()
        for edge in visibleEdges() {
            let path = UIBezierPath()
            path.lineWidth = 2.0
            path.move(to: projector(point: edge.start))
            path.addLine(to: projector(point: edge.end))
            path.stroke()
        }
    }
    
    // X
    func visibleEdges() -> [Edge] {
        let aVisibleFacets = visibleFacets() // to rename
        var edges = Shape.edges(of: aVisibleFacets)
        
        func checkEdge(edge: Edge) {
            for facet in aVisibleFacets {
                if let intersections = facetIntersectionPoints(facet, edge: edge) {
                    var t1 = tParam(edge: edge, point: intersections.p1)
                    var t2 = tParam(edge: edge, point: intersections.p2)
                    if t1 > t2 { swap(&t1, &t2) } // X
                    
                    if (t2 < 0) || (1 < t1) { continue } // no intersection for edge
                    if isFacetCloserToTheScreen(edge, than: facet) {
                        if (t1 < 0 && 1 < t2) {
                            if let index = edges.index(of: edge) { edges.remove(at: index) }
                        }
                        else if (0 < t1 && 1 < t2) {
                            if let index = edges.index(of: edge) { edges.remove(at: index) }
                            edges.append(contentsOf: edge.cut(range: t1...1))
                        }
                        else if (t1 < 0 && t2 < 1) {
                            if let index = edges.index(of: edge) { edges.remove(at: index) }
                            edges.append(contentsOf: edge.cut(range: 0...t2))
                        }
                        else if (0 < t1 && t2 < 1 && t1 <= t2) {
                            if let index = edges.index(of: edge) { edges.remove(at: index) }
                            edges.append(contentsOf: edge.cut(range: t1...t2))
                        }
                    }
                }
            }
        }
        
        for edge in edges {
            checkEdge(edge: edge)
        }
        
        return edges
    }
    
    // X
    func isFacetCloserToTheScreen(_ edge: Edge, than facet: Facet) -> Bool {
        // TODO
        let ep = (edge.start + edge.end) * 0.5
        let fp = (facet.points[0] + facet.points[1] + facet.points[2] + facet.points[3]) * 0.25
        let edgeProj = ep.y - 1/2 * ep.x*sin(zAngle) - 1/2 * ep.z*cos(zAngle)
        let facetProj = fp.y - 1/2 * fp.x*sin(zAngle) - 1/2 * fp.z*cos(zAngle)
        return facetProj - edgeProj < -0.000001
    }
    
    typealias IntersectCouple = (p1: CGPoint, p2: CGPoint)
    //X
    func facetIntersectionPoints(_ facet: Facet, edge: Edge) -> IntersectCouple? {
        var intersections = [CGPoint]()
        for shapeEdge in facet.edges {
            if let point = edgesIntersectionPoint(of: edge, and: shapeEdge) {
                intersections.append(point)
            }
        }
        if intersections.count == 2 {
            return (intersections[0], intersections[1])
        }
        return nil
    }
    
    func visibleFacets() -> [Facet] {
        var visibleFacets = [Facet]()
        
        for face in (shape?.faceits)! {
            let p1 = face.points[0]
            let p2 = face.points[1]
            let p3 = face.points[2]
            
            let faceMatrix: [[CGFloat]] = [
                [p1.x, p1.y, p1.z],
                [p2.x, p2.y, p2.z],
                [p3.x, p3.y, p3.z]
            ]
            let d: [[CGFloat]] = [[-1], [-1], [-1]]
            
            if let inversed = Matrix.inverse(matrix: faceMatrix) {
                let coefficients = Matrix.multiply(inversed, by: d)
                if isVisible(x: coefficients[0][0], y: coefficients[1][0], z: coefficients[2][0]) {
                    visibleFacets.append(face)
                }
            }
        }
        return visibleFacets
    }
    
    func isVisible(x: CGFloat, y: CGFloat, z: CGFloat) -> Bool{
        let deviation: CGFloat = -0.000001
        let projection = y - 1/2 * x*sin(zAngle) - 1/2 * z*cos(zAngle)
        return projection < deviation
    }
    
    func coefForEdge(_ edge: Edge, point: Point3D) -> CGFloat {
        // F(x, y) = (yb-ya)*(x-xa) - (xb-xa)*(y-ya)
        let A = projector(point: edge.start)
        let B = projector(point: edge.end)
        let p = projector(point: point)

        return (B.y - A.y)*(p.x - A.x) - (B.x - A.x)*(p.y - A.y)
    }
    
    func edgesIntersectionPoint(of edge1: Edge, and edge2: Edge) -> CGPoint? {
        let coef1 = coefForEdge(edge1, point: edge2.start)
        let coef2 = coefForEdge(edge1, point: edge2.end)
        if coef1*coef2 < 0 {
            // x = x[i] - s*(x[i+1] - x[1])
            let a = projector(point: edge2.start)
            let b = projector(point: edge2.end)

            let s = coef1 / (coef1 - coef2)
            let x = a.x + s * (b.x - a.x)
            let y = a.y + s * (b.y - a.y)
            return CGPoint(x: x, y: y)
        }
        return nil
    }
    // X
    func tParam(edge: Edge, point: CGPoint) -> CGFloat {
        let A = projector(point: edge.start)
        let B = projector(point: edge.end)
        let t: CGFloat
        if abs(B.y - A.y) > abs(B.x - A.x) {
            t = (point.y - A.y) / (B.y - A.y)
        } else {
            t = (point.x - A.x) / (B.x - A.x)
        }
        return t
    }
}





















