//
//  ContentView.swift
//  Shared
//
//  Created by Shayarneel Kundu on 4/12/22.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    
    
    
    let untamped = Untamped()
    let tamped = Tamped()
    let efficiency = Efficiency()
//    var urcZero = untamped.urcFinder(lfisscore: 14.14, ltranscore: 4.108, nu: 3.172)
    
    var body: some View {
        Button("Do Stuff", action: self.calculate)
            .padding()
    }
    
    func calculate() {
        efficiency.eff(atomicMass: 238.02891, ltranscore: 3.596, rCritical: 8.366, rCore: 9.25, dCore: 18.71, nu: 2.637)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
