//
//  ContentView.swift
//  Shared
//
//  Created by Shayarneel Kundu on 4/29/22.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]


struct ContentView: View {
    
    @ObservedObject var plotData = PlotClass()
    
    @ObservedObject var untamped = Untamped()
    @ObservedObject var tamped = Tamped()
    @ObservedObject var efficiency = Efficiency()
    @ObservedObject var neutronSpectrum = NeutronSpectrum()
    @ObservedObject var monteCarloInt = MonteCarloInt(withData: true)
    
    @State var blank : [plotDataType] = []
    
    @State var dCore = 0.0
    @State var ltranscore = 0.0
    @State var lfisscore = 0.0
    @State var nu = 0.0
    @State var rTamp = 0.0
    @State var ltranstamp = 0.0
    @State var sfisscore = 0.0
    @State var stranscore = 0.0
    @State var dTamper = 0.0
    @State var A = 0.0
    @State var atomicMass = 0.0
    @State var guess = 0.0
    
    @State var dCoreString = "density of core"
    @State var ltranscoreString = "mean free path for neutron in the core"
    @State var lfisscoreString = "mean free path of neutron before it causes fission"
    @State var nuString = "number of neutrons released per fission"
    @State var rTampString = "radius of tamper"
    @State var ltranstampString = "mean free path for neutron in the tamper"
    @State var sfisscoreString = "fission cross section of the core"
    @State var stranscoreString = "transmission cross section of the core"
    @State var dTamperString = "density of tamper"
    @State var AString = "A"
    @State var atomicMassString = "atomic mass"
    @State var guessString = "guesses"
    
    @State var urc = 0.0
    @State var untampedMass = 0.0
    
    @State var urcString = "minimum Radius required to cause fission"
    @State var untampedMassString = "mass of the core"
    
    @State var trc = 0.0
    @State var tampedCoreMass = 0.0
    @State var tamperMass = 0.0
    @State var totalMass = 0.0
    
    @State var trcString = "minimum Radius required to cause fission"
    @State var tampedCoreMassString = "mass of the core"
    @State var tamperMassString = "mass of the tamper"
    @State var totalMassString = "total mass of device"
    
    @State var minValString = ""
    @State var maxValString = ""
    @State var lowerBoundValString = ""
    @State var upperBoundValString = ""

    
    
    var body: some View {
        
        
        HStack{
            
            VStack{
                GroupBox(label: Text("Untamped Inputs"), content: {
                    VStack(alignment: .center) {
                        Text("atomic Number")
                            .font(.callout)
                            .bold()
                        TextField("", text: $AString)
                            .padding()
                    }
                    .padding(.top, 5.0)

                    VStack(alignment: .center) {
                        Text("denisity of core (g/cm^(3))")
                            .font(.callout)
                            .bold()
                        TextField("", text: $dCoreString)
                            .padding()
                    }
                    .padding(.top, 5.0)

                    VStack(alignment: .center) {
                        Text("lambda transmission (cm)")
                            .font(.callout)
                            .bold()
                        TextField("", text: $ltranscoreString)
                            .padding()
                    }
                    .padding(.top, 5.0)

                    VStack(alignment: .center) {
                        Text("lambda fission (cm)")
                            .font(.callout)
                            .bold()
                        TextField("", text: $lfisscoreString)
                            .padding()
                    }
                    .padding(.top, 5.0)

                    VStack(alignment: .center) {
                        Text("nu")
                            .font(.callout)
                            .bold()
                        TextField("", text: $nuString)
                            .padding()
                    }
                    .padding(.top, 5.0)

                })
                    

                Button("untamped", action: self.calculateUntamped)
                    .padding()
                
                GroupBox(label: Text("Untamped Outputs"), content: {
                    VStack{
                        
                        VStack(alignment: .center) {
                            Text("untamped critical radius (cm)")
                                .font(.callout)
                                .bold()
                            TextField("", text: $urcString)
                                .padding()
                        }
                        .padding(.top, 5.0)
                        
                        VStack(alignment: .center) {
                            Text("core mass (g)")
                                .font(.callout)
                                .bold()
                            TextField("", text: $untampedMassString)
                                .padding()
                        }
                        .padding(.top, 5.0)
                        
                        }
                    })
                    
                }
            
            VStack{
                
                GroupBox(label: Text("Tamped Inputs"), content: {
                    VStack(alignment: .center) {
                        Text("radius of Tamper (cm)")
                            .font(.callout)
                            .bold()
                        TextField("", text: $rTampString)
                            .padding()
                    }
                    .padding(.top, 5.0)
                    
                    VStack(alignment: .center) {
                        Text("lambda transmission of tamper (cm)")
                            .font(.callout)
                            .bold()
                        TextField("", text: $ltranstampString)
                            .padding()
                    }
                    .padding(.top, 5.0)
                    
                    VStack(alignment: .center) {
                        Text("transmission cross-section of the core (bn)")
                            .font(.callout)
                            .bold()
                        TextField("", text: $stranscoreString)
                            .padding()
                    }
                    .padding(.top, 5.0)
                    
                    VStack(alignment: .center) {
                        Text("fission cross-section of the core (bn)")
                            .font(.callout)
                            .bold()
                        TextField("", text: $sfisscoreString)
                            .padding()
                    }
                    .padding(.top, 5.0)
                    
                    VStack(alignment: .center) {
                        Text("density of tamper (g/cm^(3))")
                            .font(.callout)
                            .bold()
                        TextField("", text: $dTamperString)
                            .padding()
                    }
                    .padding(.top, 5.0)
                })
                    
                
                
                Button("tamped", action: self.calculateTamped)
                    .padding()
                
                GroupBox(label: Text("Tamped Outputs"), content: {
                    VStack{
                        
                        VStack(alignment: .center) {
                            Text("tamped critical radius (cm)")
                                .font(.callout)
                                .bold()
                            TextField("", text: $urcString)
                                .padding()
                        }
                        .padding(.top, 5.0)
                        
                        VStack(alignment: .center) {
                            Text("core mass (g)")
                                .font(.callout)
                                .bold()
                            TextField("", text: $tampedCoreMassString)
                                .padding()
                        }
                        
                        VStack(alignment: .center) {
                            Text("tamper mass (g)")
                                .font(.callout)
                                .bold()
                            TextField("", text: $tamperMassString)
                                .padding()
                        }
                        
                        VStack(alignment: .center) {
                            Text("total mass (g)")
                                .font(.callout)
                                .bold()
                            TextField("", text: $totalMassString)
                                .padding()
                        }
                        .padding(.top, 5.0)
                        
                        }
                    })
                    

                }
            
            VStack{
                GroupBox(label: Text("Neutron Spectrum Inputs"), content: {
                    VStack{
                        
                        VStack(alignment: .center) {
                            Text("atomic number")
                                .font(.callout)
                                .bold()
                            TextField("", text: $AString)
                                .padding()
                        }
                        .padding(.top, 5.0)
                        
                        VStack(alignment: .center) {
                            Text("atomic mass (amu)")
                                .font(.callout)
                                .bold()
                            TextField("", text: $atomicMassString)
                                .padding()
                        }
                        
                        VStack(alignment: .center) {
                            Text("Guesses")
                                .font(.callout)
                                .bold()
                            TextField("", text: $guessString)
                                .padding()
                        }
                        
                        .padding(.top, 5.0)
                        
                        }
                    })
                
                Button("neutron spectrum", action: {Task.init{await self.calculateNeutronSpectrum()}})
                    .padding()
                
                CorePlot(dataForPlot: $neutronSpectrum.pEnergyArray,
                        changingPlotParameters: $plotData.plotArray[0].changingPlotParameters)
                                    .setPlotPadding(left: 10)
                                    .setPlotPadding(right: 10)
                                    .setPlotPadding(top: 10)
                                    .setPlotPadding(bottom: 10)
                                    .padding()
                                    .tabItem {
                                        Text("Neutron Energy Spectrum")
                                    }
                
                drawingView(redLayer:$monteCarloInt.insideData, blueLayer: $monteCarloInt.outsideData, upperBound: $upperBoundValString, lowerBound: $lowerBoundValString, min: $minValString, max: $maxValString)
                    .padding()
                    .aspectRatio(1, contentMode: .fit)
                    .drawingGroup()
                // Stop the window shrinking to zero.
                Spacer()
                
               
            }
            
                
            }
            .padding()  
            
        }
    
    func calculateUntamped() {
        
        lfisscore = Double(lfisscoreString)!
        ltranscore = Double(ltranscoreString)!
        nu = Double(nuString)!
        dCore = Double(dCoreString)!
        
        var urcvals : (Double, Double) = (0.0, 0.0)
        
        urcvals = untamped.untampedValues(lfisscore: lfisscore, ltranscore: ltranscore, nu: nu, density: dCore)
        
        urc = urcvals.0
        untampedMass = urcvals.1
        
        urcString = String(urc)
        untampedMassString = String(untampedMass)
            }
    
    func calculateTamped() {
        
        rTamp = Double(rTampString)!
        ltranstamp = Double(ltranstampString)!
        ltranscore = Double(ltranscoreString)!
        lfisscore = Double(lfisscoreString)!
        sfisscore = Double(sfisscoreString)!
        stranscore = Double(stranscoreString)!
        nu = Double(nuString)!
        dTamper = Double(dTamperString)!
        dCore = Double(dCoreString)!
                
        var trcvals : (Double, Double, Double, Double) = (0.0, 0.0, 0.0, 0.0)
        
        trcvals = tamped.tampedValues(rTamp: rTamp, ltranstamp: ltranstamp, ltranscore: ltranscore, lfisscore: lfisscore, sfisscore: sfisscore, stranscore: stranscore, nu: nu, dTamper: dTamper, dCore: dCore)
        
        trc = trcvals.0
        tampedCoreMass = trcvals.1
        tamperMass = trcvals.2
        totalMass = trcvals.3
        
        urcString = String(urc)
        tampedCoreMassString = String(tampedCoreMass)
        tamperMassString = String(tamperMass)
        totalMassString = String(totalMass)
            }
    
    
    func calculateNeutronSpectrum() async {
        
        neutronSpectrum.pEnergyPlot()
        
        A = Double(AString)!
        atomicMass = Double(atomicMassString)!
        
//        monteCarloInt.lowerBoundVal = neutronSpectrum.bEnergy(A: A, atomicMass: atomicMass)
//        monteCarloInt.upperBoundVal = 10.0
//        monteCarloInt.minVal = 0.0
//        monteCarloInt.maxVal = neutronSpectrum.pEnergy(energy: monteCarloInt.lowerBoundVal)
//
//        lowerBoundValString = String(monteCarloInt.lowerBoundVal)
//        upperBoundValString = String(monteCarloInt.upperBoundVal)
//        minValString = String(monteCarloInt.minVal)
//        maxValString = String(monteCarloInt.maxVal)
        monteCarloInt.totalGuesses = Int(guessString) ?? Int(0.0)
        
        await monteCarloInt.calculateIntVal(lowerBoundVal: neutronSpectrum.bEnergy(A: A, atomicMass: atomicMass), upperBoundVal: 10.0, minVal: 0.0, maxVal: neutronSpectrum.pEnergy(energy: monteCarloInt.lowerBoundVal))
    }
        }
    
   

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
