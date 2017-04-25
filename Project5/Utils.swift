//
//  Utils.swift
//  Project5
//
//  Created by Chris Martin on 4/22/17.
//  Copyright © 2017 Chris Martin. All rights reserved.
//

import Foundation
import Darwin


/// Errors thrown during the lifetime of the application
///
/// - badArgc: Incorrect number of arguments
/// - badArgv: Unexpected argument sequence
enum AppError: Error {
    
    /// Errors relating to command-line argument parsing
    ///
    /// - badArgc: Incorrect number of arguments
    /// - badArgv: Unexpected argument sequence
    enum Arguments: Error {
        case badArgc
        case badArgv
    }
}

/// Namespace providing numerous helper functions.
class Utils {
    
    /// Private initializer preventing initialization
    private init() { }
    
    /// Print the correct usage of the program.
    public class func usage() {
        print("usage: l n g Pm Pc")
        exit(-1)
    }
    
    /// Calculates the hashValue of the bitstring
    ///
    /// - Parameter contents: Contents of the bitstring to hash
    /// - Returns: New hashValue of the bitstring.
    public class func xorHashes<T: Hashable>(contents: [T]) -> Int {
        return contents.reduce(0, { (prev, current) -> Int in
            return prev.hashValue ^ current.hashValue
        })
    }
    
}

extension Bool {
    
    /// Initialize a boolean value as the result of a random-number-generator 
    /// falling within the range of the probability.
    ///
    /// - Parameter probability: Probability of calculating true
    init?(probability: Double) {
        guard (0.0...1.0).contains(probability) else {
            return nil
        }
        
        let rand = Double(arc4random()) / Double(UINT32_MAX)
        self = (0.0...probability).contains(rand)
    }
}


/// Struct containt program arguments
struct Arguments {
    
    /// Bits / Genes in a genetic string
    var l: Int
    
    /// Population Size
    var n: Int
    
    /// Number of Generations
    var g: Int
    
    /// Mutation Probability
    var pm: Double
    
    /// Crossover Probability
    var pc: Double
    
    /// Create an arguments struct given an array of strings
    ///
    /// - Parameter args: Base array
    /// - Throws: `badArgc` or `badArgv`
    init(args: [String]) throws {
        guard args.count == 6 else { throw AppError.Arguments.badArgc }
        
        guard
            let l =  Int(args[1]),
            let n =  Int(args[2]),
            let g =  Int(args[3]),
            let pm = Double(args[4]),
            let pc = Double(args[5])
            else { throw AppError.Arguments.badArgv }
        
        self.l = l;
        self.n = n;
        self.g = g;
        self.pm = pm;
        self.pc = pc;
    }
}


