//
//  ObservableState.swift
//  FeaturePattern
//
//  Created by Robin Charlton on 12/07/2021.
//

/// E.g.
/// @ObservableState var name: String
///
/// $name.observe { change in
///     print("Name changed from \(\(change.previous ?? "nil")) to \(change.value)")
/// }
/// name = "Tom"
/// name = "Jerry"
///
/// > Name changed from nil to Tom
/// > Name changed from Tom to Jerry
@propertyWrapper
class ObservableState<T>: PropertySubject<T> {
    var wrappedValue: T {
        get { value }
        set { value = newValue }
    }

    var projectedValue: Observable<T> {
        self
    }

    init(wrappedValue: T) {
        super.init(wrappedValue)
    }

}
