//
//  NeutronShielding.swift
//  ManhattanProjectReed
//
//  Created by Shayarneel Kundu on 5/5/22.
//

import Foundation
import SwiftUI

class NeutronShielding: NSObject, ObservableObject{

    @Published var LastPoint: [(Double, Double)] = []
    @Published var Path: [(Double, Double)] = []
    @Published var numEscape: Int = 0
    @Published var enableButton = true
    
    ///MultipleWalks
    ///
    /// - Parameters:
    ///   - numParticles: These are the total number of neutrons entering the solid
    ///   - meanFreePath: The mean free path for the neutron in the solid
    ///   - Eloss: Energy loss after each colision
    ///   - Emax: Total eenrgy of the incopming beam of neutrons
    ///
    /// - Returns: array of points that are the point at which the neutrino is when it loses all its energy
    func MultipleWalks(numParticles: Int, meanFreePath: Double, Eloss: Double, Emax: Double) -> [(lastxVal: Double, lastyVal: Double)] {
        
        var LastPoint: [(lastxVal: Double, lastyVal: Double)] = []
        
        for _ in 1...numParticles{
            
            //This loop runs RandomWalk for the numer of particles that we have, and then
            //picks only the last point in the array returned by RandomWalk
            let arrays = RandomWalk(meanFreePath: meanFreePath, Eloss: Eloss, Emax: Emax)
            let ParticleEndPoint = arrays.last
            LastPoint.append((lastxVal: ParticleEndPoint!.xval, lastyVal: ParticleEndPoint!.yval))
        }
        
        return LastPoint
    }
    
    ///RandomWalk
    ///
    /// - Parameters:
    ///   - meanFreePath: The mean free path for the neutron in the solid
    ///   - Eloss: Energy loss after each colision
    ///   - Emax: Total eenrgy of the incopming beam of neutrons
    ///
    /// - Returns: array of points that the neutron passes as it expereinces collisions within the solid
    func RandomWalk(meanFreePath: Double, Eloss: Double, Emax: Double) -> [(xval: Double, yval: Double)] {
        
        //Defining the boundaries of the box
        let RightWall = 150.0
        let TopWall = 100.0
        let BottomWall = 50.0
        let LeftWall = -50.0
        
        var xPoint = 0.0    //Stores the x coordinate of the particle at each step
        var yPoint = 0.0    //Stores the y coordinate of the particle at each step
        var newxPoint = 0.0 //x coordinate of the beam
        var newyPoint = 50.0 //y coordinate of the beam
        var currentE = Emax - Eloss  //Energy loss at each step
        var angle = 0.0  //This is an angle to determine points in the random walk
        
        //This is an array that stores the points that the particle goes through
        var points: [(xval: Double, yval: Double)] = [(xval: newxPoint, yval: newyPoint)]
        
            while(currentE > 0){
            
            angle = Double.random(in: 0...2*(Double.pi)) //Random angles between 0 and 2\pi
            
            newxPoint += meanFreePath*cos(angle) //new x coordinate after collision
            newyPoint += meanFreePath*sin(angle) //new y coordinate after collision
                
                if(newxPoint < LeftWall){
                    currentE = 0  //Kills the while loop is we have back-scattering
                }
                
                else if(newxPoint > RightWall || newyPoint > TopWall || newyPoint < BottomWall){
                    currentE = 0    //Kills the while loop if somehting escapes
                    numEscape += 1  //Counts the number of particles that escaped
                }
            
                else{
                    //Accounts for the energy loss so that the loop gets killed after the
                    //appropriate number of collisions
                    currentE -= Eloss
                }
            
            //Values of points after a collision is stored and added to an array as a tuple
            xPoint = newxPoint
            yPoint = newyPoint
                
            points.append((xval: xPoint,yval: yPoint))
            
        }
           
        Path = points
        return Path
    }
    
    //Enable Button to run things smotthly
    func setButtonEnable(state: Bool) {
            if state {
                Task.init {
                    await MainActor.run {
                        self.enableButton = true
                    }
                }
            } else {
                Task.init {
                    await MainActor.run {
                        self.enableButton = false
                    }
                }
            }
        }
        
    //Delete previous data when the code is re-run
        func eraseData() {
            LastPoint.removeAll()
            Path.removeAll()
        }
}


