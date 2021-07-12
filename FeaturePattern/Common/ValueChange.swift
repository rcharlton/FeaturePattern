//
//  ValueChange.swift
//  FeaturePattern
//
//  Created by Robin Charlton on 12/07/2021.
//

struct ValueChange<Value> {
    let current: Value
    let previous: Value?

    init(_ current: Value, previous: Value?) {
        self.current = current
        self.previous = previous
    }

    static func initial(_ value: Value) -> Self {
        .init(value, previous: nil)
    }

    static func unchanged(_ value: Value) -> Self {
        .init(value, previous: value)
    }
}

extension ValueChange: Equatable where Value: Equatable { }

extension ValueChange where Value: Equatable {
    var isChanged: Bool {
        return current != previous
    }

    var changedValue: Value? {
        isChanged ? current : nil
    }
}
