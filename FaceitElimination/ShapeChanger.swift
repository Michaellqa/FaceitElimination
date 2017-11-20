
import UIKit

struct ShapeChanger {
    
    static func rotateZ(shape: Shape, angle: CGFloat) {
        let rotateMatrix: [[CGFloat]] = [[cos(angle), sin(angle), 0, 0],
                                         [-sin(angle), cos(angle), 0, 0],
                                         [0, 0, 1, 0],
                                         [0, 0, 0, 1]]
        multiplyWithCentralization(shape: shape, matrix: rotateMatrix)
    }

    static func rotateX(shape: Shape, angle: CGFloat) {
        let rotateMatrix: [[CGFloat]] = [[1, 0, 0, 0],
                                         [0, cos(angle), sin(angle), 0],
                                         [0, -sin(angle), cos(angle), 0],
                                         [0, 0, 0, 1]]
        multiplyWithCentralization(shape: shape, matrix: rotateMatrix)
    }

    static func rotateY(shape: Shape, angle: CGFloat) {
        let rotateMatrix: [[CGFloat]] = [[cos(angle), 0, -sin(angle), 0],
                                         [0, 1, 0, 0],
                                         [sin(angle), 0, cos(angle), 0],
                                         [0, 0, 0, 1]]
        multiplyWithCentralization(shape: shape, matrix: rotateMatrix)
    }

    static func scale(shape: Shape, value: CGFloat) {
        let scaleMatrix: [[CGFloat]] = [[value, 0, 0, 0],
                                        [0, value, 0, 0],
                                        [0, 0, value, 0],
                                        [0, 0, 0, 1]]
        multiplyWithCentralization(shape: shape, matrix: scaleMatrix)
    }

    static func move(shape: Shape, x: CGFloat, y: CGFloat, z: CGFloat) {
        let moveMatrix: [[CGFloat]] = [[1, 0, 0, 0],
                                       [0, 1, 0, 0],
                                       [0, 0, 1, 0],
                                       [x, y, z, 1]]
        
        for faceIndex in 0...(shape.faceits.count - 1) {
            let face = shape.faceits[faceIndex]
            let matrix = pointsToExtendedMatrix(face.points)
            let multipliedMatrix = Matrix.multiply(matrix, by: moveMatrix)
            face.points = matrixToPoints(multipliedMatrix)
        }
        // save center translation
        shape.center = shape.center + Point3D(x: x, y: y, z: z)
    }

    private static func multiplyWithCentralization(shape: Shape, matrix: [[CGFloat]]) {
        let moveToCenterMatrix: [[CGFloat]] = [[1, 0, 0, 0],
                                               [0, 1, 0, 0],
                                               [0, 0, 1, 0],
                                               [-shape.center.x, -shape.center.y, -shape.center.z, 1]]
        let moveBackMatrix: [[CGFloat]] = [[1, 0, 0, 0],
                                           [0, 1, 0, 0],
                                           [0, 0, 1, 0],
                                           [shape.center.x, shape.center.y, shape.center.z, 1]]
        // for each faceit translate coordinats
        for faceIndex in 0...(shape.faceits.count - 1) {
            let face = shape.faceits[faceIndex]
            let shapeMatrix = pointsToExtendedMatrix(face.points)
            let centerMatrix = Matrix.multiply(shapeMatrix, by: moveToCenterMatrix)
            let multipliedMatrix = Matrix.multiply(centerMatrix, by: matrix)
            let returnedMatrix = Matrix.multiply(multipliedMatrix, by: moveBackMatrix)
            face.points = matrixToPoints(returnedMatrix)
        }
    }

    private static func pointsToExtendedMatrix(_ points: [Point3D]) -> [[CGFloat]] {
        var matrix = [[CGFloat]]()
        for point in points {
            matrix.append([CGFloat(point.x), CGFloat(point.y), CGFloat(point.z), 1])
        }
        return matrix
    }

    private static func matrixToPoints(_ exMatrix: [[CGFloat]]) -> [Point3D] {
        // [Point] with the same dimention as matrix
        var points = Array<Point3D>(repeating: Point3D(x: 0, y: 0, z: 0), count: exMatrix.count)
        for row in 0...exMatrix.count - 1 {
            points[row] = Point3D(x: exMatrix[row][0], y: exMatrix[row][1], z: exMatrix[row][2])
        }
        return points
    }
    
}







