//
//  FaceitEliminationTests.swift
//  FaceitEliminationTests
//
//  Created by Micky on 20/11/2017.
//  Copyright © 2017 Micky. All rights reserved.
//

import XCTest
@testable import FaceitElimination

class FaceitEliminationTests: XCTestCase {
    
    let testPoints: [Point3D] = [Point3D(x: 50, y: 0, z: -50),
                                 Point3D(x: 200, y: 0, z: -200),
                                 Point3D(x: 50, y: 0, z: -100),
                                 Point3D(x: 250, y: 0, z: -100)]
    let expectedProjections: [CGPoint] = [CGPoint(x: 50, y: 50),
                                      CGPoint(x: 200, y: 200),
                                      CGPoint(x: 50, y: 100),
                                      CGPoint(x: 250, y: 100)]
    let drawer = DrawerView()
    
    func testProjector() {
        var checkPoints = [CGPoint]()
        for point in testPoints {
            let projection = drawer.projector(point: point)
            checkPoints.append(projection)
        }
        XCTAssertEqual(checkPoints, expectedProjections)
    }
    
    func testIntersectionPoints() {
        let edge1 = Edge(start: testPoints[0], end: testPoints[1])
        let edge2 = Edge(start: testPoints[2], end: testPoints[3])
        let checkPoint = drawer.edgesIntersectionPoint(of: edge1, and: edge2)
        let expectedPoint = CGPoint(x: 100, y: 100)

        XCTAssertEqual(checkPoint, expectedPoint)
    }
    
    func testEdgesOfFacet() {
        let points: [Point3D] = [Point3D(x: 50, y: 0, z: -50),
                                 Point3D(x: 150, y: 0, z: -50),
                                 Point3D(x: 150, y: 0, z: -200),
                                 Point3D(x: 50, y: 0, z: -150)]
        let facet = Facet(withPoints: points)
        let edges = facet.edges
        let expectedEdges: [Edge] = [Edge(start: points[0], end: points[1]),
                                     Edge(start: points[1], end: points[2]),
                                     Edge(start: points[2], end: points[3]),
                                     Edge(start: points[3], end: points[0])]
        XCTAssertEqual(edges, expectedEdges)
    }
    
    func testEdgesOfShape() {
        let p0 = Point3D(x: -40, y: -40, z: -100) // front left
        let p1 = Point3D(x: -40, y: 40, z: -100)  // back left
        let p2 = Point3D(x: 40, y: 40, z: -100)   // back right
        let p3 = Point3D(x: 40, y: -40, z: -100)  // front right
        let p4 = Point3D(x: -40, y: -40, z: 50)
        let p5 = Point3D(x: -40, y: 40, z: 50)
        
        let shape = Shape()
        shape.faceits = [Facet(withPoints: [p3, p2, p1, p0]),
                         Facet(withPoints: [p0, p1, p5, p4]),]
        let edges = Shape.edges(of: shape.faceits)
        let expectedEdges: [Edge] = [Edge(start: p3, end: p2),
                                     Edge(start: p2, end: p1),
                                     Edge(start: p1, end: p0),
                                     Edge(start: p0, end: p3),
                                     Edge(start: p1, end: p5),
                                     Edge(start: p5, end: p4),
                                     Edge(start: p4, end: p0),]
        XCTAssertEqual(edges, expectedEdges)
    }
    
    
    func testFacetIntersectionPoints() {
        let p0 = Point3D(x: -40, y: 0, z: -40) // front left
        let p1 = Point3D(x: -40, y: 0, z: 40)  // back left
        let p2 = Point3D(x: 40, y: 0, z: 40)   // back right
        let p3 = Point3D(x: 40, y: 0, z: -40)
        let edge = Edge(start: Point3D(x: -30, y: 0, z: -15),
                        end: Point3D(x: 20, y: 0, z: 10))
        let facet = Facet(withPoints: [p3, p2, p1, p0])
        let points = drawer.facetIntersectionPoints(facet, edge: edge)
        let expectedPoints = [CGPoint(x: 40, y: -20), CGPoint(x: -40, y: 20)]

        XCTAssertEqual(points?.p1, expectedPoints[0])
        XCTAssertEqual(points?.p2, expectedPoints[1])
        // also need to test projection cases
    }
     /*
    func testEdgesIntersectionPoints() {
        
    }
     */
    
    func testCutEdge() {
        let edge = Edge(start: Point3D(x: 10, y: 10, z: 10), end: Point3D(x: 60, y: 60, z: 110))
        let range: ClosedRange<CGFloat> = 0.2...0.8
        let checkEdges = edge.cut(range: range)
        let expectedEdges = [Edge(start: Point3D(x: 10, y: 10, z: 10), end: Point3D(x: 20, y: 20, z: 30)),
                             Edge(start: Point3D(x: 50, y: 50, z: 90), end: Point3D(x: 60, y: 60, z: 110))]
        XCTAssertEqual(checkEdges, expectedEdges)
    }
    
}


















