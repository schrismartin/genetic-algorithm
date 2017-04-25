//
//  Bit.swift
//  Project5
//
//  Created by Chris Martin on 4/22/17.
//  Copyright © 2017 Chris Martin. All rights reserved.
//

import Foundation

/// A binary one or zero
///
/// - zero: Zero
/// - one: One
enum Bit: UInt32 {
    case zero = 0
    case one = 1
    
    /// Invert the given bit.
    ///
    /// - Parameter bit: Target bit
    /// - Returns: Inverted bit
    static prefix func !(bit: Bit) -> Bit {
        switch bit {
        case .zero: return .one
        case .one: return .zero
        }
    }
    
    /// Create a new bit with a random value
    init() {
        let value = arc4random_uniform(2)
        self.init(rawValue: value)!
    }
}

extension Bit: CustomStringConvertible {
    var description: String {
        return String(rawValue)
    }
}

extension Int {
    
    /// Initialize an integer based on the rawValue of a Bit
    ///
    /// - Parameter bit: Subject `Bit`
    init(_ bit: Bit) {
        self = Int(bit.rawValue)
    }
}
