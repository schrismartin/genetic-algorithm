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
    
    /// User-defined fitness function
    var customFitnessFunction: FitnessFunction?
    
    /// The contents of the bitstring, as a zero or one
    var contents: [Bit]
    
    
    /// The number of one-bits in the BitString
    ///
    /// - Returns: Count of one-bits in the BitString
    func oneBits() -> Int {
        return contents.reduce(0) { (prev, bit) -> Int in
            prev + Int(bit.rawValue)
        }
    }
    
    
    /// The number of zero-bits in the BitString
    ///
    /// - Returns: Count of zero-bits in the BitString
    func zeroBits() -> Int {
        return contents.count - oneBits()
    }
    
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
    
    /// Fitness value of the bitstring given a fitness function.
    var fitnessValue: Double {
        let equation = customFitnessFunction ?? BitString.defaultFunction
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
    
    
    /// Create two child BitStrings from a randomly decided separator between
    /// splitting the parent BitStrings
    ///
    /// ```
    /// // Randomly select a range, in this case, between char 1 and 2.
    /// parent: 01|001011 10|110100
    ///
    /// // And switch after separator
    /// child: 10|110100 10|001011
    /// ```
    ///
    /// - Parameters:
    ///   - lhs: Left BitString
    ///   - rhs: Right BitString
    /// - Returns: Array of two resulting BitStrings
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
    init(size: Int, function: FitnessFunction? = nil) {
        customFitnessFunction = function
        
        // Fill Contents
        contents = [Bit]()
        for _ in 0 ..< size {
            contents.append(Bit())
        }
    }
    
    /// Initialize the bitstring with an array of bits.
    ///
    /// - Parameter contents: Constituent array of bits
    init(contents: [Bit], function: FitnessFunction? = nil) {
        customFitnessFunction = function
        
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
