//
//  PlotDataClass.swift
//  440Project-NuclearThings
//
//  Created by Shayarneel Kundu on 4/28/22.
//

import Foundation
import SwiftUI
import CorePlot

class PlotDataClass: NSObject, ObservableObject {
    
    @MainActor @Published var plotData = [plotDataType]()
    @MainActor @Published var changingPlotParameters: ChangingPlotParameters = ChangingPlotParameters()
    @MainActor @Published var calculatedText = ""
    //In case you want to plot vs point number
    @MainActor @Published var pointNumber = 1.0
    
    @MainActor init(fromLine line: Bool) {
        
        
        //Must call super init before initializing plot
        super.init()

        //Intitialize the first plot
        self.plotBlank()
        
       }
    
    
    
    @MainActor func plotBlank()
    {
        zeroData()

        //set the Plot Parameters
        changingPlotParameters.yMax = 0.5
        changingPlotParameters.yMin = -1.0
        changingPlotParameters.xMax = 4.0
        changingPlotParameters.xMin = -1.0
        changingPlotParameters.xLabel = "x"
        changingPlotParameters.yLabel = "y"
        changingPlotParameters.lineColor = .red()
        changingPlotParameters.title = "y = x"
    }
    
    @MainActor func zeroData(){
            plotData = []
            pointNumber = 1.0
        }
        
    @MainActor func appendData(dataPoint: [plotDataType])
        {
            plotData.append(contentsOf: dataPoint)
            pointNumber += 1.0
   
        }
    
}

