//
//  FindingZero.swift
//  440Project-NuclearThings
//
//  Created by Shayarneel Kundu on 4/15/22.
//

import Foundation
import SwiftUI

class FindingZero: NSObject, ObservableObject{
    
//This is the gerneric code for bisection method for finding zeros

    func bisection(lb: Double, ub: Double) -> Double{
        
        var lowerXVal = lb
        var higherXVal = ub

        var midxVal = (lowerXVal + higherXVal)/2.0
        
        let precision = 1.0E-15
        
        while(abs(midxVal-lowerXVal) > precision){

            let fofmidVal = midxVal
            let fofprevxVal = lowerXVal
            
            if((fofmidVal * fofprevxVal) < 0){
                higherXVal = midxVal
            } else {
                lowerXVal = midxVal
            }
            
            midxVal = (lowerXVal + higherXVal)/2.0
        }
        return midxVal
    }
    
}
