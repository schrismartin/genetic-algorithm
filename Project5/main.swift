//
//  main.swift
//  Project5
//
//  Created by Chris Martin on 4/22/17.
//  Copyright © 2017 Chris Martin. All rights reserved.
//

import Foundation

class MainApplication {
    
    var args: Arguments
    
    static let customFunction: FitnessFunction = {
        (_ x: Int, _ n: Int) -> Double in
        
        return pow(Double(x) / (pow(2, Double(n)) as Double), 10.0)
    }
    
    /// Runs the program from the passed command-line arguments
    ///
    /// - Parameter args: Command-line arguments
    /// - Throws: Lots of stuff.
    init(args: [String]) throws {
        self.args = try Arguments(args: args)
        
        var generation = Generation(
            count: self.args.n,
            size: self.args.l,
            pc: self.args.pc,
            pm: self.args.pm,
            function: MainApplication.customFunction
        )
        
        for iteration in 0 ..< self.args.g {
            if iteration != 0 {
                generation = generation.next
            }
            
            print(generation.statistics)
        }
    }
}

do {
    _ = try MainApplication(args: CommandLine.arguments)
}
catch {
    switch error {
    case let error as AppError.Arguments:
        Utils.usage()
    default:
        print(error)
    }
}
