
import UIKit

extension CGPoint {
    static func sum(p1: CGPoint, p2: CGPoint) -> CGPoint {
        let x = p1.x + p2.x
        let y = p1.y + p2.y
        return CGPoint(x: x, y: y)
    }
}

struct Matrix {
    
    // MARK: basic matrix operations
    
    static func multiply(_ m1: [[CGFloat]], by m2: [[CGFloat]]) -> [[CGFloat]] {
        guard m1[0].count == m2.count else {
            print("Size mismatch")
            return [[0]]
        }
        let rawsCount = m1.count
        let columnsCount = m2[0].count
        
        var res = Array<[CGFloat]>(repeating: (Array<CGFloat>(repeating: 0, count: columnsCount)), count: rawsCount)
        for rawIndex in 0...rawsCount-1 {
            for columnIndex in 0...columnsCount-1 {
                for index in 0..<m2.count {
                    res[rawIndex][columnIndex] += m1[rawIndex][index] * m2[index][columnIndex]
                }
            }
        }
        return res
    }
    
    // universal dimention
    static func scalarMultiply(matrix: [[CGFloat]], on value: CGFloat) -> [[CGFloat]] {
        var multiplied = Array.init(matrix)
        for rawIndex in 0..<matrix.count {
            for columnIndex in 0..<matrix[0].count {
                multiplied[rawIndex][columnIndex] *= value
            }
        }
        return multiplied
    }
    
    // universal dimention
    static func transpose(matrix: [[CGFloat]]) -> [[CGFloat]] {
        let rawCount = matrix.count
        let columnCount = matrix[0].count
        
        var transposed = Array<[CGFloat]>(repeating: (Array<CGFloat>(repeating: 0, count: columnCount)), count: rawCount)
        for rawIndex in 0..<rawCount {
            for columnIndex in 0..<columnCount {
                transposed[rawIndex][columnIndex] = matrix[columnIndex][rawIndex]
            }
        }
        return transposed
    }
    
    // universal dimention
    static func inverse(matrix: [[CGFloat]]) -> [[CGFloat]]? {
        let det = determinant(for: matrix)
        if det != 0 {
            // minor matrix
            let m = minor(matrix: matrix)
            let transposed = transpose(matrix: m)
            let res = scalarMultiply(matrix: transposed, on: 1/abs(det))
            return res
        }
        print("DETERMINANT = 0")
        return nil
    }
    
    // 3-d specific
    private static func minor(matrix: [[CGFloat]]) -> [[CGFloat]] {
        let size = matrix.count
        var res = Array<[CGFloat]>(repeating: (Array<CGFloat>(repeating: 0, count: size)), count: size)
        for rawIndex in 0...size-1 {
            for columnIndex in 0...size-1 {
                let em = exclude(raw: rawIndex, column: columnIndex, from: matrix)
                // [[+ - +],[- + -],[+ - +]]
                let sign: CGFloat = ((rawIndex + columnIndex) % 2) == 0 ? 1 : -1
                
                res[rawIndex][columnIndex] = sign * (em[0][0]*em[1][1] - em[0][1]*em[1][0])
            }
        }
        return res
    }
    
    // universal dimention
    private static func exclude(raw: Int, column: Int, from matrix: [[CGFloat]]) -> [[CGFloat]] {
        let size = matrix.count-1
        var res = Array<[CGFloat]>(repeating: (Array<CGFloat>(repeating: 0, count: size)), count: size)
        var i = 0
        for rawIndex in 0...size {
            if rawIndex == raw {
                continue
            }
            var j = 0
            for columnIndex in 0...size {
                if columnIndex == column {
                    continue
                }
                res[i][j] = matrix[rawIndex][columnIndex]
                j += 1
            }
            i += 1
        }
        return res
    }
    
    // 3-d specific
    static func determinant(for m: [[CGFloat]]) ->CGFloat {
        let first = m[0][0] * (m[1][1]*m[2][2] - m[1][2]*m[2][1])
        let second = m[0][1] * (m[1][0]*m[2][2] - m[1][2]*m[2][0])
        let third = m[0][2] * (m[1][0]*m[2][1] - m[1][1]*m[2][0])
        let det = first - second + third
        return det
    }
    
    
}

