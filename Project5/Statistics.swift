//
//  Statistics.swift
//  Project5
//
//  Created by Chris Martin on 4/22/17.
//  Copyright © 2017 Chris Martin. All rights reserved.
//

import Foundation


/// Staticstics for a given `Generation`
struct Statistics {
    
    /// The average fitness of a generation
    var averageFitness: Double
    
    /// The highest fitness value in a generation
    var bestFitness: Double
    
    /// The average number of ones per `BitString` in a population
    var averageCorrect: Double
    
    /// Create a new Statistics object describing a given `Generation`
    ///
    /// - Parameter generation: Subject Generation to analyze
    init(generation: Generation) {
        let members = generation.members
        
        let fitnessValues = members.map { $0.fitnessValue }
        averageFitness = fitnessValues.reduce(0, +) / Double(fitnessValues.count)
        bestFitness = fitnessValues.max()!
        
        let sum = members.reduce(0, { (prev, string) -> Int in
            prev + string.oneBits()
        })
        averageCorrect = Double(sum) / Double(members.count)
    }
}

extension Statistics: CustomStringConvertible {
    var description: String {
        return "\(averageFitness), \(bestFitness), \(averageCorrect)"
    }
}
