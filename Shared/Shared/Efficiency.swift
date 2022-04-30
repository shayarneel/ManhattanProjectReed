//
//  Efficiency.swift
//  440Project-NuclearThings
//
//  Created by Shayarneel Kundu on 4/19/22.
//

import Foundation
import SwiftUI
import CorePlot

class Efficiency: NSObject, ObservableObject{
    
    
    /// fissmass: mass that undergoes fission
    /// - Parameters:
    ///   - atomicMass: atomic mass (g mol^-1)
    ///   - ltranscore: mean free path for transmission (cm)
    ///   - rCritical: critical core radius (cm)
    ///   - rCore: core radius input by user (cm)
    ///   - dCore: density of core materical (g cm^-3)
    ///   - nu: numer of neutrons released per fission
    /// - Returns: mass that undegoes fission (g)
    func fissMass(atomicMass: Double, ltranscore: Double, rCritical: Double, rCore: Double, dCore: Double, nu: Double) -> Double {
        
        let e = eff(atomicMass: atomicMass, ltranscore: ltranscore, rCritical: rCritical, rCore: rCore, dCore: dCore, nu: nu)
        let mCore = (4.0/3.0) * Double.pi * pow(rCore, 3.0) * dCore
        
        let mFiss = e * mCore
        
        return mFiss
    }
    
    
    /// yield: use approximate eficiency to comput teh yield of the object - eq. 2.68 of blue book pg. 77
    /// - Parameters:
    ///   - atomicMass: atomic mass (g mol^-1)
    ///   - ltranscore: mean free path for transmission (cm)
    ///   - rCritical: critical core radius (cm)
    ///   - rCore: core radius input by user (cm)
    ///   - dCore: density of core materical (g cm^-3)
    ///   - nu: numer of neutrons released per fission
    /// - Returns: yield
    func yield(atomicMass: Double, ltranscore: Double, rCritical: Double, rCore: Double, dCore: Double, nu: Double) -> Double {
        
        let e = eff(atomicMass: atmoicMass, ltranscore: ltranscore, rCritical: rCritical, rCore: rCore, dCore: dCore, nu: nu)
        let Ef = 170.0 * 1.6021 * 1.0E-13 // Set Fc to 170 MeV, converted to joules
        let n = numDensity(dCore: dCore, atomicMass: atomicMass)
        let V = (4.0/3.0) * Double.pi * pow(rCritical, 3.0)
        
        let Y = e * Ef * n * V
        
        return Y
    }
    
    /// eff: approximate efficiency calculation - eq 3.24 pg 3-10 small book
    /// - Parameters:
    ///   - atomicMass: atomic mass (g mol^-1)
    ///   - ltranscore: mean free path for transmission (cm)
    ///   - rCritical: critical core radius (cm)
    ///   - rCore: core radius input by user (cm)
    ///   - dCore: density of core materical (g cm^-3)
    ///   - nu: numer of neutrons released per fission
    /// - Returns: efficiency
    func eff(atomicMass: Double, ltranscore: Double, rCritical: Double, rCore: Double, dCore: Double, nu: Double) -> Double {
        
        let alpha = alpha(rCritical: rCritical, rCore: rCore, dCore: dCore, nu: nu)
        let rho = dCore
        let dR = deltaR(rCritical: rCritical, rCore: rCore)
        let effnum = pow(alpha, 2.0) * rho * pow(dR, 2.0)
        
        let tau = tau(ltranscore: ltranscore)
        let n = numDensity(dCore: dCore, atomicMass: atomicMass)
        let Ef = 170.0 * 1.6021 * 1.0E-13 // Set Fc to 170 MeV, converted to joules
        let effden = 8.0 * pow(tau, 2.0) * n * Ef
        
        let e = effnum/effden
        
        return e
    }
    
    
    /// numDensity: Calcualtes the number denisity of atoms
    /// - Parameters:
    ///   - dCore: density of core materical (g cm^-3)
    ///   - atomicMass: atomic mass (g mol^-1)
    /// - Returns: number density of atoms in atoms/sm^3
    func numDensity(dCore: Double, atomicMass: Double) -> Double{
        
        let NA = 6.022 * 1.0E-23
        
        let nd = dCore * NA / atomicMass // return value in atomc/cm^3
        
        return nd
    }
    
    /// deltaR: for efficiency approximation
    /// - Parameters:
    ///   - rCritical: critical core radius (cm)
    ///   - rCore: core radius input by user (cm)
    /// - Returns: deltaR  measurement
    func deltaR(rCritical: Double, rCore: Double) -> Double {
        
        let drt1 = rCore
        
        let drRatio = rCore/rCritical
        let drt2 = pow(drRatio, 1.0/2.0) - 1.0
        
        let dr = drt1 * drt2
        
        return dr
    }
    
    
    /// tau - calcualtes travel time between fission
    /// - Parameters:
    ///   - ltranscore: mean free path for transmission (cm)
    /// - Returns: tau (s)
    func tau(ltranscore: Double) -> Double {
        
        let tauNum = ltranscore
        let tauDen = avgV()
        let tauVal = tauNum/tauDen
        
        return tauVal
    }
    
    
    //https://sites.ntc.doe.gov/partners/tr/Training%20Textbooks/10-Nuclear%20Physics-Reactor%20Theory/2-Mod-2%20Neutron%20Characteristics.pdf
    //pg 2-34
    
    /// average velocity of neutrons
    /// - Returns: average velocity at 1273K
    func avgV()-> Double{
        
        //The units used here give an naswer in cm/s, which is good to be compatible with
        //other calculations that have been done
        let kb = 8.617 * 1.0E-11 // erg/K
        let T = 1273.0 // 1273K = 1000C
        let m = 1.66 * 1.0E-24 //g
        
        let vNum = 2.0 * kb * T
        let vDen = m
        
        let v = sqrt(vNum/vDen)
        
        return v
    }
    
    
    /// alpha: effective number of neutrons released per fission event
    /// - Parameters:
    ///   - rCritical: critical radius, this is urc or trc calculation form the appropriate case (cm)
    ///   - rCore: core radius, this is a user input (cm)
    ///   - dCore: density of core material (g cm^-3)
    ///   - nu: numer of neutrons released per fission
    /// - Returns: the alpha parameter
    func alpha(rCritical: Double, rCore: Double, dCore: Double, nu: Double) -> Double {
        
        let at1 = nu - 1.0
        
        let mCritical = (4.0/3.0) * Double.pi * pow(rCritical, 3.0) * dCore
        let mCore = (4.0/3.0) * Double.pi * pow(rCore, 3.0) * dCore
        let mRatio = mCritical/mCore
        let at2 = 1.0 - pow(mRatio, (2.0/3.0))
        
        let al = at1 * at2
        
        return al
    }

}
