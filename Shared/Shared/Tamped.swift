//
//  Tamped.swift
//  440Project-NuclearThings
//
//  Created by Shayarneel Kundu on 4/19/22.
//

import Foundation
import SwiftUI

class Tamped: NSObject, ObservableObject{
    
//This class has the series of calculations needed for finding the critical radius for the
//case of an untamped core using Diffusion Theory.
    
    let untamped = Untamped()
    
    /// tampedValues: calculates all the requried values for the case of the tamped case
    /// - Parameters:
    ///   - rTamp: tmaper radius (cm)
    ///   - ltranstamp: mean free path in the tamper (cm)
    ///   - ltranscore: mean free path in the core (cm)
    ///   - lfisscore: mean free path for fission in the core (cm)
    ///   - sfisscore: fission cross-section of core (bn)
    ///   - stranscore: transmission cross section of core (bn)
    ///   - nu: numer of neutrons released per fission
    ///   - dTamper: density of material being used as the tamper (cm)
    ///   - dCore: density of the material beign used as the core (cm)
    /// - Returns: returns the critical radius for core, and the mass of the core, the mass of the tamper and the total mass
    func tampedValues(rTamp: Double, ltranstamp: Double, ltranscore: Double, lfisscore: Double, sfisscore: Double, stranscore: Double, nu: Double, dTamper: Double, dCore: Double) -> (rCore: Double, coreMass: Double, tamperMass: Double, totalMass: Double){
        
        let rCore = trcFinder(rTamp: rTamp, ltranstamp: ltranstamp, ltranscore: ltranscore, lfisscore: lfisscore, sfisscore: sfisscore, stranscore: stranscore, nu: nu)
        
        let coreVol = (4.0/3.0) * Double.pi * pow(rCore,3.0)
        let coreMass = dCore * coreVol
        
        let tamperVol = (4.0/3.0) * Double.pi * pow((rTamp - rCore),3.0)
        let tamperMass = dTamper * tamperVol
        
        let totalMass = coreMass + tamperMass
        
        return (rCore, coreMass, tamperMass, totalMass)
    }
    
    /// trcFinder: Calculates the critical value for core given a tamper radius
    /// - Parameters:
    ///   - rTamp: tmaper radius (cm)
    ///   - ltranstamp: mean free path in the tamper (cm)
    ///   - ltranscore: mean free path in the core (cm)
    ///   - lfisscore: mean free path for fission in the core (cm)
    ///   - sfisscore: fission cross-section of core (bn)
    ///   - stranscore: transmission cross section of core (bn)
    ///   - nu: numer of neutrons released per fission
    /// - Returns: Critical value given a radius for the tamper object
    func trcFinder(rTamp: Double, ltranstamp: Double, ltranscore: Double, lfisscore: Double, sfisscore: Double, stranscore: Double, nu: Double) -> Double {
        
        //solving equation for a bunch of urc's
        var TRCArray: [Double] = []
        var ansVal = 0.0
        
        for trc in stride(from: 0.0, to: 10.0, by: 0.1){
            ansVal = tampedRCritical(rCore: trc, rTamp: rTamp, ltranstamp: ltranstamp, ltranscore: ltranscore, lfisscore: lfisscore, sfisscore: sfisscore, stranscore: stranscore, nu: nu)
            TRCArray.append(ansVal)
        }
        
        //find critical core values vals for which there is a sign change
        var prevans = 0.0
        var curans = 0.0
        var numVal = 0.0
        
        for num in 1...TRCArray.count-1{
            
            prevans = TRCArray[num - 1]
            curans = TRCArray[num]
            
            if((prevans * curans) < 0 && (abs(prevans + curans)) < 0.1){
                numVal = Double(num - 1)
            }

        }
        
        //Bisection to find actual zero, in between the core radii for which there is a
        //sign change
        var lowerTRCVal = numVal * 0.1
        var higherTRCVal = (numVal + 1.0) * 0.1
        var midTRCVal = (lowerTRCVal + higherTRCVal)/2.0
        
        let precision = 1.0E-15
        
        while(abs(midTRCVal - lowerTRCVal) > precision){

            let fofmidVal = tampedRCritical(rCore: midTRCVal, rTamp: rTamp, ltranstamp: ltranstamp, ltranscore: ltranscore, lfisscore: lfisscore, sfisscore: sfisscore, stranscore: stranscore, nu: nu)
            
            let fofprevxVal = tampedRCritical(rCore: lowerTRCVal, rTamp: rTamp, ltranstamp: ltranstamp, ltranscore: ltranscore, lfisscore: lfisscore, sfisscore: sfisscore, stranscore: stranscore, nu: nu)
            
            if((fofmidVal * fofprevxVal) < 0){
                higherTRCVal = midTRCVal
            } else {
                lowerTRCVal = midTRCVal
            }
            
            midTRCVal = (lowerTRCVal + higherTRCVal)/2.0
        }
        print(midTRCVal)
        return midTRCVal
    }

    
    /// tampedRCritical: Computes the critical core and tamper radius. Eq 3.12 pg 3-6
    /// - Parameters:
    ///   - rCore: critical core radius
    ///   - rTamp: tmaper radius (cm)
    ///   - ltranstamp: mean free path in the tamper (cm)
    ///   - ltranscore: mean free path in the core (cm)
    ///   - lfisscore: mean free path for fission in the core (cm)
    ///   - sfisscore: fission cross-section of core (bn)
    ///   - stranscore: transmission cross section of core (bn)
    ///   - nu: numer of neutrons released per fission
    /// - Returns: solves the equation number mentioned above, should return 0for critical core radius and appropriate tamper radius
    func tampedRCritical(rCore: Double, rTamp: Double, ltranstamp: Double, ltranscore: Double, lfisscore: Double, sfisscore: Double, stranscore: Double, nu: Double) -> Double{
        
        let lambda = lambda(ltranstamp: ltranstamp, ltranscore: ltranscore)
        let epsilon = epsilon(sfisscore: sfisscore, stranscore: stranscore, nu: nu)
        let d = untamped.d(lfisscore: lfisscore, ltranscore: ltranscore, nu: nu)
        
        let rRatio = rCore/rTamp
        let x = rCore/d
        
        let t12 = 2.0 * lambda * epsilon * (1.0/x) * pow(rRatio,2.0)
        let t13 = rRatio
        let t1 = 1.0 + t12 - t13
        
        let t21 = x/tan(x)
        let t2 = t21 - 1.0
        
        let ans = (t1 * t2) + lambda
        
        return ans
    }
    
    
    /// lambda: Computes the ratio of the mean free path in tamper to core. Eq.3.13 pg 3-6
    /// - Parameters:
    ///   - ltranstamp: mean free path in the tamper (cm)
    ///   - ltranscore: mean free path in the core (cm)
    /// - Returns: ratio of the mean free paths
    func lambda(ltranstamp: Double, ltranscore: Double) -> Double{
        
        let lambda = ltranstamp/ltranscore
        
        return lambda
    }
    
    /// epsilon: Computes the dimensionless calue epsilon. Eq.3.11 pg 3-6
    /// - Parameters:
    ///   - sfisscore: fission cross-section of core (bn)
    ///   - stranscore: transmission cross section of core (bn)
    ///   - nu: numer of neutrons released per fission
    /// - Returns: returns the characteristic length scale
    func epsilon(sfisscore: Double, stranscore: Double, nu: Double) -> Double {

        let epnum = (nu - 1.0) * sfisscore
        let epden = 3.0 * stranscore
        
        let epsilon = sqrt(epnum/epden)
        
        return epsilon
    }
    
}
