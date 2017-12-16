//
//  CustomView.swift
//  Homework
//
//  Created by Lab122-05 on 12/2/17.
//  Copyright © 2017 uni. All rights reserved.
//

import UIKit


class CustomView: UIView {
    
    struct Segment {
        var color:UIColor
        var percentage:Int
        var textColor:UIColor = .white
        
        init(color: UIColor, percentage: Int) {
            self.color = color
            self.percentage = percentage
        }
        
        init(color: UIColor, percentage: Int, textColor: UIColor) {
            self.color = color
            self.percentage = percentage
            self.textColor = textColor
        }
        
    }
    
    public var segments:[Segment] = [Segment(color: UIColor.purple, percentage: 20),
                                     Segment(color: UIColor.green, percentage: 10),
                                     Segment(color: UIColor.red, percentage: 40),
                                     Segment(color: UIColor.blue, percentage: 30)]
    
    private var segmentsCount:Int {
        return segments.count
    }
    
    private func validateSegments() {
        var sum:Int = 0
        var valid:Bool = true;
        for i in 0...segmentsCount {
            if !valid {
                segments[i].percentage = 0
            }
            sum += segments[i].percentage
            if sum >= 100 {
                valid = false
                let diff = sum - 100
                segments[i].percentage -= diff
            }
        }
        if sum < 100 {
            segments.append(Segment(color: UIColor.cyan, percentage: 100-sum))
        }

        for segment in segments {
            print(segment.percentage)
        }
    }
    
    private var scale:CGFloat = 0.7
    private var lineWidth:CGFloat = 50
    private var radius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    private var centerPoint: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    
    /*private var radiusCircle: CGFloat {
        return lineWidth/2
    }
    private var centerCircle: CGPoint {
        return CGPoint(x:bounds.midX + radius, y: bounds.midY)
    }*/
    
    
    private func drawSegmnent(number: Int, from start: CGFloat, to end:CGFloat) -> UIBezierPath {
        //draw line
        let path = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: start, endAngle: end, clockwise: false)
        //add roundness to the line
        path.lineCapStyle = .round
        //set the color and the width
        segments[number].color.setStroke()
        path.lineWidth = lineWidth
        
        return path
    }

    private func drawRoundnessFirstSegment(){
        let end:Double = -(Double.pi*2) * 0.001
        let path = UIBezierPath(arcCenter: centerPoint, radius: radius, startAngle: 0, endAngle: CGFloat(end), clockwise: false)
        path.lineCapStyle = .round
        segments[0].color.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
    }
    
    private func drawPercentage(number: Int, at angle: CGFloat) {
        let font = UIFont.systemFont(ofSize: 14)
        let color = segments[number].textColor
        let attributes = [NSAttributedStringKey.font:font,
                          NSAttributedStringKey.foregroundColor: color]
        let percentageString = NSAttributedString(string: String(segments[number].percentage), attributes: attributes)
        //TODO: position text better on the circle - after New Year
        let rect = CGRect(x: radius * cos(angle), y: radius * sin(angle), width: 50, height: 50)
        percentageString.draw(in: rect)
    }
    
    private func testDrawNumber() {
        let font = UIFont.systemFont(ofSize: 14)
        ("100" as NSString).draw(at: centerPoint, withAttributes: [NSAttributedStringKey.font:font, NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    override func draw(_ rect: CGRect) {
        //validateSegments()
        var start: Double = 0
        //drawing segments
        for i in 0..<segmentsCount {
                let step: Double = (Double.pi*2) * Double(segments[i].percentage) / 100
                drawSegmnent(number: i, from: CGFloat(start), to: CGFloat(start-step)).stroke()
                start -= step
        }
        drawRoundnessFirstSegment()
        
        //drawing numbers
        //testDrawNumber()
        var angle:Double = 0
        for i in 0...segmentsCount {
            //drawPercentage(number: i, at: CGFloat(angle))
            let step: Double = (Double.pi*2) * Double(segments[i].percentage) / 100
            angle -= step
        }
    }
}
