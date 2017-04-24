//
//  Bitstring.swift
//  Project5
//
//  Created by Chris Martin on 4/22/17.
//  Copyright © 2017 Chris Martin. All rights reserved.
//

import Foundation

infix operator >< : MultiplicationPrecedence

/// An equation to find the fitness value of a given BitString
typealias FitnessFunction = (_ x: Int, _ n: Int) -> Double

/// A BitString used in the lab
struct BitString: Hashable {
    
    /// Default fitness function for the lab
    static let defaultFunction: FitnessFunction = {
        (_ x: Int, _ n: Int) -> Double in
        
        return pow(Double(x) / (pow(2, Double(n)) as Double), 10.0)
    }
    
    /// The contents of the bitstring, as a zero or one
    var contents: [Bit]
    
    /// Calculate the numeric value for a BitString
    var numericValue: Int {
        var value = 0
        let count = contents.count
        
        for (index, bit) in contents.enumerated() {
            let power = Double(count - index - 1)
            let modifier = Int(bit) * Int(pow(2, power))
            value += modifier
        }
        
        return value
    }
    
    /// Get the fitness value of the bitstring given a fitness function.
    ///
    /// - Parameter equation: Fitness Function for the bitstring. Uses the default equation of `(x / n ^ 2) ^ 10`
    /// - Returns: The fitness value of the bitstring.
    func fitnessValue(using equation: FitnessFunction = BitString.defaultFunction) -> Double {
        return equation(numericValue, contents.count)
    }
    
    /// Get the normalized fitness of a bitstring in relation to the sum.
    ///
    /// - Parameters:
    ///   - fitness: Resulting value from calculated fitness function
    ///   - sum: The sum of all previous iterations
    /// - Returns: Resulting fitness divdied by the sum
    static func normalized(fitness: Double, relatedToSum sum: Double) -> Double {
        return fitness / sum
    }
    
    static func ><(lhs: BitString, rhs: BitString) -> [BitString] {
        let cardinality = lhs.contents.count
        let index = Int(arc4random_uniform(UInt32(cardinality)))
        
        let startRange = 0 ..< index
        let endRange = index ..< cardinality
        
        let a = BitString(contents: [ lhs.contents[startRange], rhs.contents[endRange] ].flatMap { $0 })
        let b = BitString(contents: [ rhs.contents[startRange], lhs.contents[endRange] ].flatMap { $0 })
        
        return [a, b]
    }
    
    var hashValue: Int {
        return Utils.xorHashes(contents: contents)
    }
    
    /// Create a new bitstring with a certain size.
    ///
    /// - Parameter size: Number of bits in the bitstring.
    init(size: Int) {
        
        // Fill Contents
        contents = [Bit]()
        for _ in 0 ..< size {
            contents.append(Bit())
        }
    }
    
    /// Initialize the bitstring with an array of bits.
    ///
    /// - Parameter contents: Constituent array of bits
    init(contents: [Bit]) {
        // Mirror the contents to the Bitstring
        self.contents = contents
    }
    
    static func == (lhs: BitString, rhs: BitString) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    /// The mutated version of the current BitString given a probability
    ///
    /// - Parameter probability: Probability of Mutation
    /// - Returns: Mutated BitString
    func mutated(probability: Double) -> BitString {
        return BitString(previous: self, pm: probability)
    }
    
    
    /// Create a mutated BitString given another BitString.
    ///
    /// - Parameters:
    ///   - previous: BitString to be mutated
    ///   - pm: Probability of Mutation
    init(previous: BitString, pm: Double) {
        var new = previous
        new.contents = previous.contents.map { Bool(probability: pm)! ? !$0 : $0 }
        
        self = new
    }
}

extension BitString: CustomStringConvertible {
    var description: String {
        return contents.map { String($0.rawValue) }.reduce("", +)
    }
}
