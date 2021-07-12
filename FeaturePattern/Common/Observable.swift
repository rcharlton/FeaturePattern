//
//  Observer.swift
//  FeaturePattern
//
//  Created by Robin Charlton on 12/07/2021.
//

typealias Observation = Invalidatable

/// Base observation subject class with an immutable interface;
/// cannot be instantiated outside this source file.
class Observable<T> {
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

    fileprivate func notifyObservers(_ valueChange: ValueChange<T>) {
        observers.forEach { $0.value(valueChange) }
    }
}

extension Observable {
    func observe(with block: @escaping (T) -> Void) -> Observation {
        observe { block($0.current) }
    }
}

extension Observable where T: Equatable {
    func observe(with block: @escaping (T) -> Void) -> Observation {
        observe { (change: ValueChange<T>) in
            guard change.isChanged else { return }
            block(change.current)
        }
    }
}

// MARK: -

private class ObservationRecord<T>: Observation {
    lazy var identifier: ObjectIdentifier = {
        ObjectIdentifier(self)
    }()

    // Important: observations do NOT retain subjects.
    private weak var subject: Observable<T>?

    init(subject: Observable<T>) {
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

// MARK: - PassthroughSubject

/// Stateless observation subject. No value is sent on initial observation.
/// Observations returned are NOT given the current value of the subject
/// - Note: Returned observations must be retained by the caller.
///         No strong reference is maintained between subject and observation.
class PassthroughSubject<T>: Observable<T> {
    private var value: T?

    override init() {
        super.init()
    }

    func send(_ value: T) {
        notifyObservers(ValueChange(value, previous: self.value))
        self.value = value
    }
}

// MARK: - PropertySubject

/// Stateful observation subject.
/// The current value is sent on first observation.
/// - Note: Returned observations must be retained by the caller.
///         No strong reference is maintained between subject and observation.
class PropertySubject<T>: Observable<T> {
    var value: T {
        didSet {
            notifyObservers(ValueChange(value, previous: oldValue))
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
