//
//  ShieldingBox.swift
//  ManhattanProjectReed
//
//  Created by Shayarneel Kundu on 5/5/22.
//

import SwiftUI

struct boxView: View {
    
    @Binding var Layer1 : [(lastxVal: Double, lastyVal: Double)] //PLots Random Walk Points
    @Binding var Layer2 : [[(lastxVal: Double, lastyVal: Double)]]//For box
    
    var body: some View {
        
        ZStack {
            drawPath(drawingPoints: Layer1)
                .stroke(Color.red)
                .frame(width: 150, height: 150)
                .background(Color.white)
            
            drawBox(boxsides: Layer2)
                .stroke(Color.black)
                .frame(width: 150, height: 150)
        }
    }
    
    
    struct drawPath: Shape {
        
        var drawingPoints: [(lastxVal: Double, lastyVal: Double)]  ///Array of tuples
        
        func path(in rect: CGRect) -> Path {
            
            
            // draw from the center of our rectangle
            let center = CGPoint(x: rect.width/8, y: rect.height/4)
            let scale = 0.5
            
            
            // Create the Path for the display
            
            var path = Path()
            
            for item in drawingPoints {
                path.addRect(CGRect(x: item.lastxVal*Double(scale)+Double(center.x), y: -(item.lastyVal*Double(scale)+Double(center.y)) + rect.height, width: 1.0 , height: 1.0))
                
            }
            
            
            return (path)
        }
    }
    
    struct drawBox: Shape {
        
        var boxsides: [[(lastxVal: Double, lastyVal: Double)]] = []  ///Array of tuples
        
        // path
        // This plots the box
        func path(in rect: CGRect) -> Path {
            
            // Create the Path for the box
            
            var path = Path()
            
            if boxsides.isEmpty {
                return path
            }
            
            let scale = 1.0
            for side in boxsides {
                path.move(to: CGPoint(x: scale * side[0].lastxVal, y: scale * side[0].lastyVal))
                
                for item in 1..<(side.endIndex) {
                    path.addLine(to: CGPoint(x: scale * side[item].lastxVal, y: scale * side[item].lastyVal))
                }
            }
            return (path)
        }
    }
    
}

