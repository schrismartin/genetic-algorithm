//
//  Statistics.swift
//  Project5
//
//  Created by Chris Martin on 4/22/17.
//  Copyright © 2017 Chris Martin. All rights reserved.
//

import Foundation

struct Statistics {
    var averageFitness: Double
    var bestFitness: Double
    var bestCorrect: Double
    
    init(generation: Generation) {
        let members = generation.members
        
        let fitnessValues = members.map { $0.fitnessValue }
        averageFitness = fitnessValues.reduce(0, +) / Double(fitnessValues.count)
        bestFitness = fitnessValues.max()!
        
        let indexOfMax = fitnessValues.index(of: bestFitness)!
        let bestMember = members[indexOfMax]
        
        let sum = members.reduce(0, { (prev, string) -> Int in
            prev + string.oneBits()
        })
        bestCorrect = Double(sum) / Double(members.count)
    }
}

extension Statistics: CustomStringConvertible {
    var description: String {
        return "\(averageFitness), \(bestFitness), \(bestCorrect)"
    }
}
