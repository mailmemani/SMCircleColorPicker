//
//  CGPoint+Extension.swift
//  SMCircleColorPicker
//
//  Created by subramanian on 07/10/19.
//  Copyright © 2019 Subramanian. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    
    static func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        
        return CGPoint(x: x, y: y)
    }
    
    static func angleBetweenThreePoints(center: CGPoint, firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat {
        let firstAngle = atan2(firstPoint.y - center.y, firstPoint.x - center.x)
        let secondAnlge = atan2(secondPoint.y - center.y, secondPoint.x - center.x)
        var angleDiff = firstAngle - secondAnlge
        
        if angleDiff < 0 {
            angleDiff *= -1
        }
        
        return angleDiff
    }
    
    func angleBetweenPoints(firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat {
        return CGPoint.angleBetweenThreePoints(center: self, firstPoint: firstPoint, secondPoint: secondPoint)
    }
    
    func angleToPoint(pointOnCircle: CGPoint) -> CGFloat {
        
        let originX = pointOnCircle.x - self.x
        let originY = pointOnCircle.y - self.y
        var radians = atan2(originY, originX)
        
        while radians < 0 {
            radians += CGFloat(2 * Double.pi)
        }
        
        return radians
    }
    
    static func pointOnCircleAtArcDistance(center: CGPoint,
                                           point: CGPoint,
                                           radius: CGFloat,
                                           arcDistance: CGFloat,
                                           clockwise: Bool) -> CGPoint {
        
        var angle = center.angleToPoint(pointOnCircle: point);
        
        if clockwise {
            angle = angle + (arcDistance / radius)
        } else {
            angle = angle - (arcDistance / radius)
        }
        
        return self.pointOnCircle(center: center, radius: radius, angle: angle)
        
    }
    
    func distanceToPoint(otherPoint: CGPoint) -> CGFloat {
        return sqrt(pow((otherPoint.x - x), 2) + pow((otherPoint.y - y), 2))
    }
    
    static func CGPointRound(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: CoreGraphics.round(point.x), y: CoreGraphics.round(point.y))
    }
    
    static func intersectingPointsOfCircles(firstCenter: CGPoint, secondCenter: CGPoint, firstRadius: CGFloat, secondRadius: CGFloat ) -> (firstPoint: CGPoint?, secondPoint: CGPoint?) {
        
        let distance = firstCenter.distanceToPoint(otherPoint: secondCenter)
        let m = firstRadius + secondRadius
        var n = firstRadius - secondRadius
        
        if n < 0 {
            n = n * -1
        }
        
        //no intersection
        if distance > m {
            return (firstPoint: nil, secondPoint: nil)
        }
        
        //circle is inside other circle
        if distance < n {
            return (firstPoint: nil, secondPoint: nil)
        }
        
        //same circle
        if distance == 0 && firstRadius == secondRadius {
            return (firstPoint: nil, secondPoint: nil)
        }
        
        let a = ((firstRadius * firstRadius) - (secondRadius * secondRadius) + (distance * distance)) / (2 * distance)
        let h = sqrt(firstRadius * firstRadius - a * a)
        
        var p = CGPoint.zero
        p.x = firstCenter.x + (a / distance) * (secondCenter.x - firstCenter.x)
        p.y = firstCenter.y + (a / distance) * (secondCenter.y - firstCenter.y)
        
        //only one point intersecting
        if distance == firstRadius + secondRadius {
            return (firstPoint: p, secondPoint: nil)
        }
        
        var p1 = CGPoint.zero
        var p2 = CGPoint.zero
        
        p1.x = p.x + (h / distance) * (secondCenter.y - firstCenter.y)
        p1.y = p.y - (h / distance) * (secondCenter.x - firstCenter.x)
        
        p2.x = p.x - (h / distance) * (secondCenter.y - firstCenter.y)
        p2.y = p.y + (h / distance) * (secondCenter.x - firstCenter.x)
        
        //return both points
        return (firstPoint: p1, secondPoint: p2)
    }
}
