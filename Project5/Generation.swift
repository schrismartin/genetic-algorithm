//
//  Generation.swift
//  Project5
//
//  Created by Chris Martin on 4/22/17.
//  Copyright © 2017 Chris Martin. All rights reserved.
//

import Foundation

struct Generation {
    
    var members: [BitString]
    var values: [Double]
    var pc: Double
    var pm: Double
    
    /// The next Generation
    var next: Generation {
        return Generation(previous: self, pc: pc, pm: pm)
    }
    
    /// Create statistics based on the current generation
    var statistics: Statistics {
        return Statistics(generation: self)
    }
    
    /// Creates a new generation with `count` randomly generated BitStrings of size `size`.
    ///
    /// - Parameters:
    ///   - count: The number of BitStrings to create
    ///   - size: The number of bits in each BitString
    ///   - pc: Probability of Combination
    ///   - pm: Probability of Mutation
    init(count: Int, size: Int, pc: Double, pm: Double) {
        var members = [BitString]()
        
        for _ in 0 ..< count {
            let bitstring = BitString(size: size)
            members.append(bitstring)
        }
        
        self.init(members: members, pc: pc, pm: pm)
    }
    
    /// Create a generation by advancing the previous generation
    ///
    /// - Parameters:
    ///   - generation: Previous generation
    ///   - pc: Probability of Combination
    ///   - pm: Probability of Mutation
    init(previous generation: Generation, pc: Double, pm: Double) {
        let bitstrings = generation.members
        let values = generation.values
        
        var newMembers = [BitString]()
        let size = bitstrings.count
        
        while newMembers.count < size {
            let parents = Generation.getParents(using: bitstrings, values: values)
            let children = (Bool(probability: pc)! ? parents : parents[0] >< parents[1])
                .map { $0.mutated(probability: pm) }
            
            newMembers += children
        }
        
        self.init(members: newMembers, pc: pc, pm: pm)
    }
    
    /// Create a generation using a pre-defined list of BitStrings
    ///
    /// - Parameters:
    ///   - members: Pre-defined list of BitStrings
    ///   - pc: Probability of Combination
    ///   - pm: Probability of Mutation
    init(members: [BitString], pc: Double, pm: Double) {
        self.members = members
        self.pc = pc
        self.pm = pm
        
        let sum: Double = members.reduce(0) { (prev, bitstring) -> Double in
            return prev + bitstring.fitnessValue()
        }
        
        values = []
        
        // Calculate normalized values
        for bitstring in members {
            let fitnessValue = bitstring.fitnessValue()
            
            let normalizedFitness = BitString.normalized(fitness: fitnessValue, relatedToSum: sum)
            values.append(normalizedFitness + (values.last ?? 0))
        }
    }
    
    
    /// Randomly select two parents
    ///
    /// - Parameters:
    ///   - strings: Bitstrings available to choose from
    ///   - values: Corresponding advancing normalized fitness values
    /// - Returns: The two parents for a given set of children
    private static func getParents(using strings: [BitString], values: [Double]) -> [BitString] {
        var parents = [BitString]()
        
        // Get the index for each one
        var values = values
        var strings = strings
        
        for _ in 0 ..< 2 {
            let maxRemaining = values.max()!
            let parent = (Double(arc4random()) / Double(UINT32_MAX)) * maxRemaining
            let index = values.filter { $0 < parent }.count
            
            parents.append(strings[index])
            values.remove(at: index)
            strings.remove(at: index)
        }
        
        return Array(parents)
    }
    
}
