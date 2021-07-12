//
//  Configure.swift
//  DeclarativeTableView
//
//  Created by Robin Charlton on 07/07/2021.
//

/// A generic configuration pattern.
/// - Parameters:
///   - resolve: An expression to provide the initial instance. Value types are copied.
///   - closure: An expression to mutate the provided instance.
/// - Returns:  The configured instance.
public func configure<T>(_ instance: T, with closure: (inout T) -> Void) -> T {
    var instance = instance
    closure(&instance)
    return instance
}
