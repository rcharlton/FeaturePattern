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

extension StateRepresentable where Self: AnyObject {
    func bind<T: Observable<State>>(
        to observable: T,
        animated isAnimating: Bool = false
    ) -> Observation {
        observable.observe { [weak self] (state: State) in
            guard let self = self else { return }
            self.setState(state, animated: isAnimating)
        }
    }
}
