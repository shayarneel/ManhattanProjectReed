//
//  PlotClass.swift
//  440Project-NuclearThings
//
//  Created by Shayarneel Kundu on 4/28/22.
//

import Foundation

class PlotClass: ObservableObject {
    
    @Published var plotArray: [PlotDataClass]
    
    @MainActor init() {
        self.plotArray = [PlotDataClass.init(fromLine: true)]
        self.plotArray.append(contentsOf: [PlotDataClass.init(fromLine: true)])
            
        }
 
}

