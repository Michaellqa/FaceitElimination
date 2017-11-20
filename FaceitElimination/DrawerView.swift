
import UIKit

class DrawerView: UIView {
    
    var zAngle = CGFloat.pi / 180 * 64
    var shape: Shape?
    var color: UIColor = .blue
    
    override func draw(_ rect: CGRect) {
        color.set()
        if shape != nil {
            for face in visibleFaceits() {
                UIColor.blue.set()
                let path = pathForFaceit(face)
                path.stroke()
            }
        }
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
    func visibleEdges() -> [Edge] {
        let faceits = visibleFaceits()
        var edges = Shape.edges(of: faceits)
        for edge in edges {
            for faceit in faceits {
                var intersections = [CGPoint]()
                for shapeEdge in faceit.edges {
                    if let point = intersectionPoints(of: edge, and: shapeEdge) {
                        intersections.append(point)
                    }
                }
                // intersections count = 0 or 1 or 2
                // not finished!
            }
        }
        return edges
    }
    
    func visibleFaceits() -> [Facet] {
        var visibleFaceits = [Facet]()
        
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
                    visibleFaceits.append(face)
                }
            }
        }
        return visibleFaceits
    }
    // X
    func isVisible(x: CGFloat, y: CGFloat, z: CGFloat) -> Bool{
        let deviation: CGFloat = -0.000001
        let projection = y - 1/2 * x*sin(zAngle) - 1/2 * z*cos(zAngle)
        return (projection < deviation) ? true : false
    }
    // X
    func coefForEdge(_ edge: Edge, point: Point3D) -> CGFloat {
        // F(x, y) = (yb-ya)*(x-xa) - (xb-xa)*(y-ya)
        let B = projector(point: edge.end)
        let A = projector(point: edge.start)
        let p = projector(point: point)

        return (B.y - A.y)*(p.x - A.x) - (B.x - A.x)*(p.y - A.y)
    }
    // X
    func intersectionPoints(of edge1: Edge, and edge2: Edge) -> CGPoint? {
        let coef1 = coefForEdge(edge1, point: edge2.start)
        let coef2 = coefForEdge(edge1, point: edge2.end)
        if coef1*coef2 < 0 {
            // x = x[i] - s*(x[i+1] - x[1])
            let a = projector(point: edge2.start)
            let b = projector(point: edge2.end)

            let s = coef1 / (coef1 - coef2)
            let x = a.x - s * (b.x - a.x)
            let y = a.y - s * (b.y - a.y)
            return CGPoint(x: x, y: y)
        }
        return nil
    }
}





















