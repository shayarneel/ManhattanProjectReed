//
//  TampedStuff.swift
//  440Project-NuclearThings
//
//  Created by Shayarneel Kundu on 4/15/22.
//

import Foundation
import SwiftUI
import CorePlot

class Untamped: NSObject, ObservableObject{
    
//This class has the series of calculations needed for finding the critical radius for the
//case of an untamped core using Diffusion Theory.
    
    /// untampedValues: Computes all the necessary values for the untamped case
    /// - Parameters:
    ///   - lfisscore: mean free path for fission (cm)
    ///   - ltranscore: mean free path for transmission (cm)
    ///   - nu: numer of neutrons released per fission
    ///   - density: density of the material being used (g cm^-3)
    /// - Returns: returns the critical radius of the core and the mass of the core
    func untampedValues(lfisscore: Double, ltranscore: Double, nu: Double, density: Double) -> (urc: Double, coreMass: Double){
        
        let urc = urcFinder(lfisscore: lfisscore, ltranscore: ltranscore, nu: nu)
        
        let coreVol = (4.0/3.0) * Double.pi * pow(urc,3.0)
        let coreMass = density * coreVol/1000.0
        
        return (urc, coreMass)
    }

    
    /// Finds the R critical
    /// - Parameters:
    ///   - lfisscore: mean free path for fission (cm)
    ///   - ltranscore: mean free path for transmission (cm)
    ///   - nu: numer of neutrons released per fission
    /// - Returns: The R critical
    func urcFinder(lfisscore: Double, ltranscore: Double, nu: Double) -> Double {
        
        //solving equation for a bunch of urc's
        var URCArray: [Double] = []
        var ansVal = 0.0
        
        for urc in stride(from: 0.0, to: 10.0, by: 0.1){
            ansVal = untampedRCritical(untampedRC: urc, lfisscore: lfisscore, ltranscore: ltranscore, nu: nu)
            URCArray.append(ansVal)
        }
        
        //find urc vals for which there is a sign change
        var prevans = 0.0
        var curans = 0.0
        var numVal = 0.0
        
        for num in 1...URCArray.count-1{
            
            prevans = URCArray[num - 1]
            curans = URCArray[num]
            
            if((prevans * curans) < 0 && (abs(prevans + curans)) < 0.1){
                numVal = Double(num - 1)
            }

        }
        
        //Bisection to find actual zero between urc values with a sign change
        var lowerURCVal = numVal * 0.1
        var higherURCVal = (numVal + 1.0) * 0.1
        var midURCVal = (lowerURCVal + higherURCVal)/2.0
        
        let precision = 1.0E-15
        
        while(abs(midURCVal-lowerURCVal) > precision){

            let fofmidVal = untampedRCritical(untampedRC: midURCVal, lfisscore: lfisscore, ltranscore: ltranscore, nu: nu)
            
            let fofprevxVal = untampedRCritical(untampedRC: lowerURCVal, lfisscore: lfisscore, ltranscore: ltranscore, nu: nu)
            
            if((fofmidVal * fofprevxVal) < 0){
                higherURCVal = midURCVal
            } else {
                lowerURCVal = midURCVal
            }
            
            midURCVal = (lowerURCVal + higherURCVal)/2.0
        }
        return midURCVal
    }
    
    
    /// untampedRCritical: Equation for finding R critical for untamped cores. Eq.3.6 pg 3-3
    /// - Parameters:
    ///   - untampedRC: R critical for untamped core (cm)
    ///   - lfisscore: mean free path for fission (cm)
    ///   - ltranscore: mean free path for transmission (cm)
    ///   - nu: numer of neutrons released per fission
    /// - Returns: solves equation mentioend above, should return 0 for critical core radius
    func untampedRCritical(untampedRC: Double, lfisscore: Double, ltranscore: Double, nu: Double) -> Double{
        
        let d = d(lfisscore: lfisscore, ltranscore: ltranscore, nu: nu)
        let eta = eta(lfisscore: lfisscore, ltranscore: ltranscore, nu: nu)
        
        let x = untampedRC/d
        let t1 = x / tan(x)
        let t2 = (1.0/eta) * x
        
        let ans = t1 + t2 - 1
        
        return ans
    }
    
    
    /// eta: ratio of mean free path for transmission to the characteristic size. Eq.3.8 pg 3-3
    /// - Parameters:
    ///   - lfisscore: mean free path for fission (cm)
    ///   - ltranscore: mean free path for transmission (cm)
    ///   - nu: numer of neutrons released per fission
    /// - Returns: charactersitic length scale
    func eta(lfisscore: Double, ltranscore: Double, nu: Double) -> Double {
        
        let etanum = 2.0 * ltranscore
        let etaden = 3.0 * d(lfisscore: lfisscore, ltranscore: ltranscore, nu: nu)
        
        let eta = etanum/etaden
        
        return eta
    }
    
    
    /// d: Characteristic size. Eq.3.7 pg 3-3
    /// - Parameters:
    ///   - lfisscore: mean free path for fission (cm)
    ///   - ltranscore: mean free path for transmission (cm)
    ///   - nu: numer of neutrons released per fission
    /// - Returns: charactersitic size
    func d(lfisscore: Double, ltranscore: Double, nu: Double) -> Double {
        
        let dnum = lfisscore * ltranscore
        let dden = 3.0 * (nu - 1.0)
        
        let d = sqrt(dnum/dden)
        
        return d
    }
    
}
