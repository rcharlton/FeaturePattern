//
//  Observer.swift
//  FeaturePattern
//
//  Created by Robin Charlton on 12/07/2021.
//

import Foundation

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

protocol Invalidatable {
    func invalidate()
}

typealias Observation = Invalidatable

/// Base observation subject class with an immutable interface;
/// cannot be instantiated outside this source file.
class ObservationSubject<T> {
    typealias Observer = (ValueChange<T>) -> Void

    private var observers = [ObjectIdentifier: Observer]()

    fileprivate init() { }

    func observe(with observer: @escaping Observer) -> Observation {
        let record = ObservationRecord<T>(subject: self)
        observers[record.identifier] = observer
        return record
    }

    fileprivate func removeObservationRecord(_ record: ObservationRecord<T>) {
        observers.removeValue(forKey: record.identifier)
    }

    fileprivate func sendValueChange(_ valueChange: ValueChange<T>) {
        observers.forEach { $0.value(valueChange) }
    }
}

private class ObservationRecord<T>: Observation {
    lazy var identifier: ObjectIdentifier = {
        ObjectIdentifier(self)
    }()

    private weak var subject: ObservationSubject<T>?

    init(subject: ObservationSubject<T>) {
        self.subject = subject
    }

    deinit {
        invalidate()
    }

    func invalidate() {
        subject?.removeObservationRecord(self)
        subject = nil
    }
}

/// A stateless observation subject. The observer receives no value on initial observation.
/// Observations returned are NOT given the current value of the subject
/// - Note: Returned observations must be retained by the caller.
///         No strong reference is maintained between subject and observation.
class PassthroughObservationSubject<T>: ObservationSubject<T> {
    private var value: T?

    func send(_ value: T) {
        sendValueChange(ValueChange(value, previous: self.value))
        self.value = value
    }
}

/// A stateful observation subject. The observer receives the current value when it first observes.
/// - Note: Returned observations must be retained by the caller.
///         No strong reference is maintained between subject and observation.
class PropertyObservationSubject<T>: ObservationSubject<T> {
    var value: T {
        didSet {
            sendValueChange(ValueChange(value, previous: oldValue))
        }
    }

    init(_ value: T) {
        self.value = value
        super.init()
    }

    override func observe(with block: @escaping Observer) -> Observation {
        block(.initial(value))
        return super.observe(with: block)
    }
}
