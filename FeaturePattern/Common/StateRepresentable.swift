//
//  StateRepresentable.swift
//  FeaturePattern
//
//  Created by Robin Charlton on 12/07/2021.
//

protocol StateRepresentable {
    associatedtype State
    func setState(_ state: State, animated isAnimated: Bool)
}

extension StateRepresentable {
    func setState(_ state: State) {
        setState(state, animated: false)
    }
}
