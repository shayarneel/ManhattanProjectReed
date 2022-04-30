//
//  NeutronSpectrum.swift
//  440Project-NuclearThings
//
//  Created by Shayarneel Kundu on 4/28/22.
//

import Foundation
import SwiftUI
import CorePlot

class NeutronSpecturm: NSObject, ObservableObject{
    
    @Published var pEnergyArray: [plotDataType] = []
    
    
    func pEnergyPlot() {
        
        var energyVal = 0.0
        
        for E in stride(from: 0.0, to: 15.0, by: 0.001){
            
            energyVal = pEnergy(energy: E)
            pEnergyArray.append([.X: E, .Y: energyVal])
        }
    }
    
    /// bEnergy: calculates the binding energyper nucleon
    /// - Parameters:
    ///   - A: Atomic Number
    ///   - atomicMass: Atomic Mass (g mol^-1)
    /// - Returns: Retruns the binding energy per nucleon
    func bEnergy(A: Double, atomicMass: Double) -> Double {
         
        let massGap = abs(atomicMass - A)/A
        
        //binding energy = massGap (u) * 931.494 (MeV/u) 
        let bE = massGap * 931.494
        
        return bE
    }
    
//This is the plot of the energy spectrum of the released neutrons. Formula taken from:
//https://indico.cern.ch/event/145296/contributions/1381141/attachments/136909/194258/lecture24.pdf
    
    /// pEnergy: Calculates teh expected energy spectrum for high energy neutronsin a fission process
    /// - Parameters:
    ///   - energy: energy at which we are evaluating the probability function (MeV)
    /// - Returns: probability of emitting a neutron with given energy (MeV^-1)
    func pEnergy(energy: Double) -> Double {
        
        let exp = exp(-energy)
        
        let arg = sqrt(2.0 * energy)
        let coeff = 0.4865 * sinh(arg)
        
        let pE = coeff * exp
        
        return pE
    }
    
}
