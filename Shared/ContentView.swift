//
//  ContentView.swift
//  Shared
//
//  Created by Shayarneel Kundu on 4/29/22.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

let xmin : Double = 75.0
let xmax : Double = 375
let ymin : Double = 150
let ymax : Double = 450



struct ContentView: View {
    
    @ObservedObject var neutronShielding = NeutronShielding()
    
    @State var randomWalk : [(lastxVal: Double, lastyVal: Double)] = [(lastxVal: 300, lastyVal: 300)]
    
    
    @State var box : [[(lastxVal: Double, lastyVal: Double)]] =
    [[(lastxVal: xmin, lastyVal: ymin),
                       (lastxVal: xmin, lastyVal: ymax),
                       (lastxVal: xmax, lastyVal: ymax),
                       (lastxVal: xmax, lastyVal: ymin),
                       (lastxVal: xmin, lastyVal: ymin)]]
     
    @State var particleNumString : String = "1000"
    @State var meanFreePathString : String = "50.0"
    @State var ElossString : String = "0.50"
    @State var EmaxString : String = "10"
    @State var numEscapedString : String = "0"
    
    
    @ObservedObject var plotData = PlotClass()
    
    @ObservedObject var untamped = Untamped()
    @ObservedObject var tamped = Tamped()
    @ObservedObject var eff = Efficiency()
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
    @State var rCore = 0.0
    @State var ueff = 0.0
    @State var uy = 0.0
    @State var um = 0.0
    @State var teff = 0.0
    @State var ty = 0.0
    @State var tm = 0.0
    @State var energyRW = 0.0
    @State var particleNum = 0.0
    @State var ep = 0.0
    
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
    @State var totalGuessString = "0"
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
    @State var intValString = ""
    
    @State var rCoreString = "Radius of the core"
    
    @State var ueffString = ""
    @State var uyString = ""
    
    @State var teffString = ""
    @State var tyString = ""

    
    
    var body: some View {
        
        
        HStack{
            
            VStack{
                GroupBox(label: Text("Untamped Inputs"), content: {

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
                            Text("core mass (kg)")
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
                            TextField("", text: $trcString)
                                .padding()
                        }
                        .padding(.top, 5.0)
                        
                        VStack(alignment: .center) {
                            Text("core mass (kg)")
                                .font(.callout)
                                .bold()
                            TextField("", text: $tampedCoreMassString)
                                .padding()
                        }
                        
                        VStack(alignment: .center) {
                            Text("tamper mass (kg)")
                                .font(.callout)
                                .bold()
                            TextField("", text: $tamperMassString)
                                .padding()
                        }
                        
                        VStack(alignment: .center) {
                            Text("total mass (kg)")
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
                            Text("mass number")
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
                
                Button("neutron spectrum", action: self.calculateNeutronSpectrum)
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
                
                Button("monte carlo integration", action: {Task.init{await self.calculateMonteCarloInt()}})
                    .padding()
                    .disabled(monteCarloInt.enableButton == false)
                
                drawingView(redLayer:$monteCarloInt.insideData, blueLayer: $monteCarloInt.outsideData, upperBound: $upperBoundValString, lowerBound: $lowerBoundValString, min: $minValString, max: $maxValString)
                    .padding()
                    .aspectRatio(1, contentMode: .fit)
                    .drawingGroup()
                // Stop the window shrinking to zero.
                Spacer()
                
                VStack(alignment: .center) {
                    Text("Integral Value")
                        .font(.callout)
                        .bold()
                    TextField("", text: $intValString)
                        .padding()
                }
               
            }
            
            VStack{
                
                VStack{
                    GroupBox(label: Text("Efficiency Inputs"), content: {
                        VStack(alignment: .center) {
                            Text("Core Radius (cm)")
                                .font(.callout)
                                .bold()
                            TextField("", text: $rCoreString)
                                .padding()
                        }
                        
                        VStack(alignment: .center) {
                            Text("atomic mass (amu)")
                                .font(.callout)
                                .bold()
                            TextField("", text: $atomicMassString)
                                .padding()
                        }
                    })
                    
                    Button("untamped efficiency", action: self.calculateUntampedEff)
                        .padding()
                    Button("tamped efficiency", action: self.calculateTampedEff)
                        .padding()
   
                }
                
                VStack{
                    
                    GroupBox(label: Text("Untamped Efficiency"), content: {
                        VStack(alignment: .center) {
                            Text("Efficiency")
                                .font(.callout)
                                .bold()
                            TextField("", text: $ueffString)
                                .padding()
                        }
                        .padding(.top, 5.0)
                        
                        VStack(alignment: .center) {
                            Text("Yield (J)")
                                .font(.callout)
                                .bold()
                            TextField("", text: $uyString)
                                .padding()
                        }
                        .padding(.top, 5.0)
                        
                    })
                
                
            }
                
                VStack{
                    
                    GroupBox(label: Text("Tamped Efficiency"), content: {
                        VStack(alignment: .center) {
                            Text("Efficiency")
                                .font(.callout)
                                .bold()
                            TextField("", text: $teffString)
                                .padding()
                        }
                        .padding(.top, 5.0)
                        
                        VStack(alignment: .center) {
                            Text("Yield (J)")
                                .font(.callout)
                                .bold()
                            TextField("", text: $tyString)
                                .padding()
                        }
                        .padding(.top, 5.0)

                    })
                
                
            }
            
                
            }
            .padding()
            
            VStack{
                
                GroupBox(label: Text("Random Walk Inputs"), content: {
                    
                    VStack {
                        Text("Energy")
                        TextField("Energy of neutron", text: $EmaxString)
                            .frame(width: 100.0)
                    }.padding()
                    
                })
                
                
                
                // Drawing
                boxView(Layer1: $randomWalk, Layer2: $box)
                    .padding()
                    .aspectRatio(1, contentMode: .fit)
                    .drawingGroup()
                
                Button("Random Walk", action: self.calculateRandomWalk)
                    .padding()
                    .frame(width: 200.0)
                    .disabled(neutronShielding.enableButton == false)
                
                VStack {
                    Text("Number Escaped")
                    TextField("Particles that leave the box", text: $numEscapedString)
                        .frame(width: 100.0)
                        .disabled(neutronShielding.enableButton == false)
                }.padding()
            }
            
            

            
        }
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
        
        trcString = String(trc)
        tampedCoreMassString = String(tampedCoreMass)
        tamperMassString = String(tamperMass)
        totalMassString = String(totalMass)
            }
    
    
    func calculateNeutronSpectrum() {
        
        neutronSpectrum.pEnergyPlot()
        
        
    }
    
    func calculateMonteCarloInt() async {
        
        A = Double(AString)!
        atomicMass = Double(atomicMassString)!
        
        
        monteCarloInt.lowerBoundVal = neutronSpectrum.bEnergy(A: A, atomicMass: atomicMass)
        monteCarloInt.upperBoundVal = 10.0
        monteCarloInt.minVal = 0.0
        monteCarloInt.maxVal = neutronSpectrum.pEnergy(energy: monteCarloInt.lowerBoundVal)

        lowerBoundValString = String(monteCarloInt.lowerBoundVal)
        upperBoundValString = String(monteCarloInt.upperBoundVal)
        minValString = String(monteCarloInt.minVal)
        maxValString = String(monteCarloInt.maxVal)
        
        monteCarloInt.setButtonEnable(state: false)
        
        monteCarloInt.guesses = Int(guessString)!
        monteCarloInt.totalGuesses = Int(totalGuessString) ?? Int(0.0)
        
        await monteCarloInt.calculateIntVal(lowerBoundVal: Double(lowerBoundValString)!, upperBoundVal: Double(upperBoundValString)!, minVal: Double(minValString)!, maxVal: Double(maxValString)!)
        
        totalGuessString = monteCarloInt.totalGuessesString
        
        intValString = monteCarloInt.IntValString
        
        monteCarloInt.setButtonEnable(state: true)
        
        }
    
    func calculateUntampedEff() {
        
        rCore = Double(rCoreString)!
        lfisscore = Double(lfisscoreString)!
        ltranscore = Double(ltranscoreString)!
        nu = Double(nuString)!
        dCore = Double(dCoreString)!
        atomicMass = Double(atomicMassString)!
        
        urc = Double(urcString)!
        
        ueff = eff.eff(atomicMass: atomicMass, lfisscore: lfisscore, rCritical: urc, rCore: rCore, dCore: dCore, nu: nu)
        uy = eff.yield(atomicMass: atomicMass, lfisscore: lfisscore, rCritical: urc, rCore: rCore, dCore: dCore, nu: nu)

        
        ueffString = String(ueff)
        uyString = String(uy)
        
    }
    
    func calculateTampedEff() {
        
        rCore = Double(rCoreString)!
        lfisscore = Double(lfisscoreString)!
        ltranscore = Double(ltranscoreString)!
        nu = Double(nuString)!
        dCore = Double(dCoreString)!
        atomicMass = Double(atomicMassString)!

        trc = Double(trcString)!
        
        teff = eff.eff(atomicMass: atomicMass, lfisscore: lfisscore, rCritical: trc, rCore: rCore, dCore: dCore, nu: nu)
        ty = eff.yield(atomicMass: atomicMass, lfisscore: lfisscore, rCritical: trc, rCore: rCore, dCore: dCore, nu: nu)
        
        teffString = String(teff)
        tyString = String(ty)

    }
    
    func calculateRandomWalk() {
        
        let neutronSpectrum = NeutronSpectrum()
        let eff = Efficiency()
        
        dCore = Double(dCoreString)!
        atomicMass = Double(atomicMassString)!
        energyRW = Double(EmaxString)!
        ep = Double(ueffString)!
        urc = Double(urcString)!
        
        let n = eff.numDensity(dCore: dCore, atomicMass: atomicMass)
        let probEnergy = neutronSpectrum.pEnergy(energy: energyRW)
        
        //Number of neutrons with energy E that are emitted during the fission process
        let intermediateVal = ep * n * probEnergy * (4.0/3.0) * Double.pi * pow(urc, 3.0)
        particleNum = intermediateVal.rounded()
	
        particleNumString = String(particleNum)
        meanFreePathString = ltranscoreString
        
        
        neutronShielding.setButtonEnable(state: false)
        self.neutronShielding.objectWillChange.send()
        
        randomWalk.append(contentsOf: neutronShielding.MultipleWalks(numParticles: Int(particleNumString)!, meanFreePath: Double(meanFreePathString)!, Eloss: Double(ElossString)!, Emax: Double(EmaxString)!))
            
        
        numEscapedString = String(neutronShielding.numEscape)
        neutronShielding.setButtonEnable(state: true)
    }
}

    
   

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
