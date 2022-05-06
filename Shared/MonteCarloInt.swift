//
//  MonteCarloInt.swift
//  440Project-NuclearThings (iOS)
//
//  Created by Shayarneel Kundu on 4/28/22.
//

import Foundation
import SwiftUI

class MonteCarloInt: NSObject, ObservableObject {
    
    @MainActor @Published var insideData = [(xPoint: Double, yPoint: Double)]()
    @MainActor @Published var outsideData = [(xPoint: Double, yPoint: Double)]()
    @Published var totalGuessesString = ""
    @Published var guessesString = ""
    @Published var IntValString = ""
    @Published var enableButton = true
    
    var intval = 0.0
    var guesses = 1
    var totalGuesses = 0
    var totalIntegral = 0.0
    var lowerBoundVal = 1.0
    var upperBoundVal = 1.0
    var minVal = 1.0
    var maxVal = 1.0
    var firstTimeThroughLoop = true
    
    @MainActor init(withData data: Bool){
        
        super.init()
        
        insideData = []
        outsideData = []
        
    }


    /// calculate the value of decaying exponential integral using monte carlo integration
    ///
    /// - Parameter sender: Any
    func calculateIntVal(lowerBoundVal: Double, upperBoundVal: Double, minVal: Double, maxVal: Double) async {
        
        var maxGuesses = 0.0
        let intArea = (upperBoundVal - lowerBoundVal) * (maxVal - minVal)
        let totalArea = (10.0 - 0.0) * (0.35 - 0.0)
        let Area = intArea/totalArea
        
        
        maxGuesses = Double(guesses)
        
        let newValue = await calculateMonteCarloIntegral(lowerBound: lowerBoundVal, upperBound: upperBoundVal, min: minVal, max: maxVal, maxGuesses: maxGuesses)
        
        totalIntegral = totalIntegral + newValue
        
        totalGuesses = totalGuesses + guesses
        
        await updateTotalGuessesString(text: "\(totalGuesses)")
        
        //totalGuessesString = "\(totalGuesses)"
        
        ///Calculates the value of integral by normalizing to teh bounding box
        
        intval = totalIntegral/Double(totalGuesses) * (Area/10.0)
        
        await updateIntValString(text: "\(intval)")
        
        //updates the numerically comptued integral
        
       
        
    }

    /// calculates the Monte Carlo Integral
    ///
    /// - Parameters:
    ///   - lowerBoundVal: lower bound of integral
    ///   - upperBoundVal: upper bound of integral
    ///   - minval: lowest y-axis value within which you want to intergrate (take this value to be zero, unless the function goes below the x-axis, in which case this should be the minimum value of the function in within the bounds of integration)
    ///   - maxval: highest y-axis value within which you want to intergrate (should be the maximum value of the function within the bounds of integration)
    ///   - maxGuesses: number of guesses to use in the calculaton
    /// - Returns: ratio of points inside to total guesses. Must mulitply by area of box in calling function
    func calculateMonteCarloIntegral(lowerBound: Double, upperBound: Double, min: Double, max: Double, maxGuesses: Double) async -> Double {
        
        let neutronSpectrum = NeutronSpectrum()
        
        var numberOfGuesses = 0.0
        var pointUnderCurve = 0.0
        var integral = 0.0
        var point = (xPoint: 0.0, yPoint: 0.0)
        var intPoint = 0.0
        
        var newInsidePoints : [(xPoint: Double, yPoint: Double)] = []
        var newOutsidePoints : [(xPoint: Double, yPoint: Double)] = []
        
        while numberOfGuesses < maxGuesses {
            
            /* Calculate 2 random values within the box */
            /* Determine the wether under the decaying exponential or not */
            /* If the under the curve, point is added to integral */
            point.xPoint = Double.random(in: lowerBound...upperBound)
            point.yPoint = Double.random(in: min...max)
            
            intPoint = neutronSpectrum.pEnergy(energy: point.xPoint) - point.yPoint
            
            // if under the curve, add to the points under the curve
                if((intPoint) >= 0.0) {
                    pointUnderCurve += 1.0
                    newInsidePoints.append(point)
                    }
            
            //if outside the curve, put in list of points outside curve
                else {
                    newOutsidePoints.append(point)
                    }
            
            numberOfGuesses += 1.0

            }
        
        integral = Double(pointUnderCurve)
        
        //Append the points to the arrays needed for the displays
        //Don't attempt to draw more than 250,000 points to keep the display updating speed reasonable.
        
        if ((totalGuesses < 500001) || (firstTimeThroughLoop)){
        
//            insideData.append(contentsOf: newInsidePoints)
//            outsideData.append(contentsOf: newOutsidePoints)
            
            var plotInsidePoints = newInsidePoints
            var plotOutsidePoints = newOutsidePoints
            
            if (newInsidePoints.count > 750001) {
                
                plotInsidePoints.removeSubrange(750001..<newInsidePoints.count)
            }
            
            if (newOutsidePoints.count > 750001){
                plotOutsidePoints.removeSubrange(750001..<newOutsidePoints.count)
                
            }
            
            await updateData(insidePoints: plotInsidePoints, outsidePoints: plotOutsidePoints)
            firstTimeThroughLoop = false
        }
        
        await updateIntValString(text: String(integral))
        return integral
        }
    
    
    /// updateData
    /// The function runs on the main thread so it can update the GUI
    /// - Parameters:
    ///   - insidePoints: points inside the curve
    ///   - outsidePoints: points outside the curve within the bounding box
    @MainActor func updateData(insidePoints: [(xPoint: Double, yPoint: Double)] , outsidePoints: [(xPoint: Double, yPoint: Double)]){
        
        insideData.append(contentsOf: insidePoints)
        outsideData.append(contentsOf: outsidePoints)
    }
    
    /// updateTotalGuessesString
    /// The function runs on the main thread so it can update the GUI
    /// - Parameter text: contains the string containing the number of total guesses
    @MainActor func updateTotalGuessesString(text:String){
        
        self.totalGuessesString = text
        
    }
    
    /// updateIntValString
    /// The function runs on the main thread so it can update the GUI
    /// - Parameter text: contains the string containing the current value of intval
    @MainActor func updateIntValString(text:String){
        
        self.IntValString = text
        
    }
    
    
    /// setButton Enable
    /// Toggles the state of the Enable Button on the Main Thread
    /// - Parameter state: Boolean describing whether the button should be enabled.
    @MainActor func setButtonEnable(state: Bool){
        
        if state {
            Task.init {
                await MainActor.run {
                    self.enableButton = true
                }
            }

                
        }
        else{
            Task.init {
                await MainActor.run {
                    self.enableButton = false
                }
            }
                
        }
        
    }

}
