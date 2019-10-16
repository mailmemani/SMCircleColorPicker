//
//  SMCircleColorPicker.swift
//  SMCircleColorPicker
//
//  Created by subramanian on 07/10/19.
//  Copyright © 2019 Subramanian. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics


/**
  SMColorWheelDelegate will inform about the color changes based on the color wheen arc control head position
 */
protocol SMCircleColorPickerDelegate: class {
    
    /**
     
     Update color when user rotating the color wheel control.
     
     - Parameter color : Color which is based on the arc control head position.
     
     */
    func colorChanged(color: UIColor)
}


/******************************************************************/
// SM Color Wheel
/******************************************************************/
@IBDesignable
class SMCircleColorPicker : UIControl {
    
    // Configurable
    @IBInspectable
    var thicknessOfColorWheel: CGFloat = 10 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var arcControlSpacing: CGFloat = 20 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    
    @IBInspectable
    var totalColorSectors:Int = 360 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var arcColor: UIColor = .black {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    // colorWheelTracker
    fileprivate var arcControl: SMArcControl!
    
    // Arc head selected color
    fileprivate var selectedColor: UIColor! {
        didSet {
            colorPickerDelegate?.colorChanged(color: selectedColor)
        }
    }
    
    
    // Arc start and end angle
    fileprivate var arcStartAngle: Int = 90
    fileprivate var arcEndAngle: Int = 270
    
    
    // Delegate instance which wants to lisiten the color based on the color wheel head position
    open weak var colorPickerDelegate: SMCircleColorPickerDelegate?
    
    // Hide view
    open var shouldHideView: Bool = false {
        didSet {
            self.isHidden = shouldHideView
            arcControl.isHidden = shouldHideView
        }
    }
    
    /**
     Initiate the view with frame values
     
     - Parameter frame : frame of the view
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = (frame.size.width / 2) + 5
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func draw(_ rect: CGRect) {
        
        // Draw color wheel
        addColorWheel()
        // Draw color wheel selector arc
        setupColorWheelThumb(rect: rect)
    }
    
    /**
        Add color wheel based on the configured thicknes of the circle.
     */
    private func addColorWheel() {
        
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        let radius = CGFloat(self.frame.width / 2 -  (3 * thicknessOfColorWheel))
        
        let angle:CGFloat = CGFloat(2.0) *  (.pi) / CGFloat(totalColorSectors)
        
        for sector in 0..<totalColorSectors {
            
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(sector) * angle, endAngle: (CGFloat(sector) + CGFloat(1)) * angle, clockwise: true)
            path.lineWidth = thicknessOfColorWheel
            path.close()
            
            let color = SMCircleColorPicker.colorOnSector(sector: sector,totalSectors: totalColorSectors)
            color.setFill()
            color.setStroke()
            
            path.fill()
            path.stroke()
        }
    }
    
    /**
     
     Setup sie of the arc view (Color wheel control) and draw on top the color wheel
     
     - Parameter rect : size of the SMColorWheel view.
     
     */
    private func setupColorWheelThumb(rect : CGRect) {
        
        if arcControl != nil {
            arcControl.removeFromSuperview()
        }
        
        // Increase size of the outer view by the border width (Arc color wheel control)
        var wheelRect = self.frame
        wheelRect.size.width = wheelRect.size.width + arcControlSpacing
        wheelRect.size.height = wheelRect.size.height + arcControlSpacing
        
        arcControl = SMArcControl.init(frame: wheelRect, startAngle: self.arcStartAngle, endAngle:  self.arcEndAngle, arcSpacing: self.arcControlSpacing, arcColor: self.arcColor)
        // Arc should have the same center position of the color wheel
        arcControl.center = self.center
        // Hide arc based on color wheel hidden status
        arcControl.isHidden = self.isHidden
        // Pass the reference of self to arc view to update the selected color changes.
        arcControl.colorWheel = self
        // Add arc to view.
        self.superview?.addSubview(arcControl!)
    }

    /**
     
     Return the color object based on the given selector
     
     - Parameter sector : current sector value.
     
     - Returns: color object for the given sector value out of 360 sectors (SMTotalColorSectors).
     */

    static func colorOnSector(sector: Int, totalSectors: Int) -> UIColor {
        let color = UIColor(hue: CGFloat(sector)/CGFloat(totalSectors), saturation: CGFloat(1), brightness: CGFloat(1), alpha: CGFloat(1))
        return color
    }
}




/******************************************************************/
// SM ARC Control
/******************************************************************/
fileprivate class SMArcControl: UIControl {
    
    weak var colorWheel: SMCircleColorPicker!

    private var deltaAngle: CGFloat = 0.0
    private var startTransform: CGAffineTransform?
    
    private var startAngle: Int = 90
    private var endAngle: Int = 270
    private var arcSpacing: CGFloat = 20
    private var arcColor: UIColor = .black
    
    private let wheelHeadSize: CGFloat = 20.0
    private let totalSectors: Int = 360
    
    /**
     Override the init method to configure the color of the view.
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect,
                     startAngle: Int,
                     endAngle: Int,
                     arcSpacing: CGFloat,
                     arcColor: UIColor) {
        self.init(frame: frame)
        
        self.layer.cornerRadius = (frame.size.width / 2) + 5
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.arcSpacing = arcSpacing
        self.arcColor = arcColor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /**
     Draw arc based on the given corrdinates and size
     */
    override func draw(_ rect: CGRect) {
        
        addArc()
        
        // Update initial color and which will update all view who are all confirmed to SMColorWheel protocol
        updateColorBasedOnArcHead()
    }
    
    /**
     Add arc and head (filled circle) at end of the arc based on the configured arc start and end angle.
     */
    func addArc() {
        
        let center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        let radius = CGFloat(self.frame.width / 2 -  self.arcSpacing)
        
        let angle:CGFloat = CGFloat(2.0) *  (.pi) / CGFloat(self.totalSectors)
        
        // initial thickness
        var lineThickness = 0.02
        // Increase the thickness of the arch on every sector
        let ticknessToIncrease = 0.02
        // Maximum thickness of the arc
        let maxThickness = 3.0
        
        let sectorRange = startAngle...endAngle
        
        // To increase the arc thickness gradually we need to draw the line in different angle and different thickness
        for sector in sectorRange {
            
            // Create Bezierpath in the from the center of the view and calculated radius along with start and end angle based on the configured start-end angle
            let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(sector) * angle, endAngle: (CGFloat(sector) + CGFloat(1)) * angle, clockwise: true)
            
            path.close()
            
            // Arc Color
            let color: UIColor = self.arcColor
            
            path.lineWidth = CGFloat(lineThickness)
            
            if lineThickness <= maxThickness {
                // If the line thickness is not reached the maximum thicness value then increase the thickness by ticknessToIncrease value
                lineThickness += ticknessToIncrease
            }
            
            color.setFill()
            color.setStroke()
            
            path.fill()
            path.stroke()
            
            // Once reach the end of the arc line we need to draw a circle at the tail of the arc. which will act as a head of the color picker wheel
            if sector == endAngle {

                // Poition of the circle
                let pointOnCircle = CGPoint.pointOnCircle(center: center, radius: radius, angle: (CGFloat(sector) + CGFloat(1)) * angle)
                
                let circlePath = UIBezierPath(ovalIn: CGRect(x: pointOnCircle.x, y: (pointOnCircle.y - CGFloat(wheelHeadSize/2)), width: wheelHeadSize, height: wheelHeadSize))
                
                color.setFill()
                color.setStroke()
                
                circlePath.fill()
                circlePath.stroke()
            }
        }
    }
    
    /**
        On begin tracking, Identify the user tracking position. If if it is on top of the arc control then updated the color based on the head
     */
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let touchPoint = touch.location(in: self)

        // 1.1 - Get the distance from the center
        let dist = calculateDistanceFromCenter(point: touchPoint)
        
        // 1.2 - Filter out touches too close to the center
        if (dist < 100)
        {
            // forcing a tap to be on the ferrule
            print("ignoring tap :", touchPoint.x, touchPoint.y)
            return false
        }
        
        // 2 - Calculate distance from center
        let dx = touchPoint.x - self.center.x
        let dy = touchPoint.y - self.center.y
        
        // 3 - Calculate arctangent value
        deltaAngle = atan2(dy,dx)
        
        // 4 - Save current transform
        startTransform = self.transform
        
        // 5. Update the color based on the arc head  position
        updateColorBasedOnArcHead()
        
        return true;
    }
    
    /**
        On continues tracking, Identify the user tracking position. If if it is on top of the arc control then updated the color based on the head
     */
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let pt = touch.location(in: self)
        
        // 1 - Calculate distance from center
        let dx = pt.x  - self.center.x
        let dy = pt.y  - self.center.y
        let ang = atan2(dy,dx)
        
        // 2 - Calculate angle different from the delta angle value
        let angleDifference = deltaAngle - ang
        
        // 3. Rotate the view based on the angle difference
        self.transform = startTransform!.rotated(by: -angleDifference)
        
        // 4. Save current transform state
        startTransform = self.transform
        
        // Update the color based on the arc head  position
        updateColorBasedOnArcHead()
        
        return true;
    }
    
    
    /**
        At the end of the tracking, Identify the user tracking position. If if it is on top of the arc control then updated the color based on the head
     */
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        //Update the color based on the arc head  position
        updateColorBasedOnArcHead()
    }
    
    
    /**
        Indicate the color wheel about the new color change based on the arc view head position
     */
    func updateColorBasedOnArcHead() {
        
        // Get radian based on the arc view transform
        let radians = Double(atan2(self.transform.b, self.transform.a))
        
        // Convert radian into degree.
        let degree = radians * (180.0 / Double.pi)
        
        // Identify the seletor from the angle
        let sector = sectorFromDegreeBasedOnArc(degree: Int(degree))
        
        // Update the color wheel selector color property based on the identified sector position
        colorWheel.selectedColor = SMCircleColorPicker.colorOnSector(sector: sector, totalSectors: self.totalSectors)
    }
    
    /**
     
     Calculat ethe distance from center of the view based on the given tap position
     
     - Parameter point : user tap position
     
     - Returns: distance from the center to tapped area.
     
     */
    func calculateDistanceFromCenter(point: CGPoint) -> CGFloat {
        
        let center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        
        let dx = point.x - center.x
        let dy = point.y - center.y
        
        return (dx*dx + dy*dy).squareRoot()
    }
    
    /**
     
     Get sector based on the arc view head transform.
     
     - Parameter degree : Arc view rotated degree
     
     - Returns: sector value
     
     */
    func sectorFromDegreeBasedOnArc(degree: Int) -> Int {
        var sector = degree
        
        if (degree < 0) {
            // Negative Values
            sector = 360  - (degree * -1)
        }
        
        sector = sector +  (endAngle + Int(wheelHeadSize / 2))
        
        return sector
    }
}
