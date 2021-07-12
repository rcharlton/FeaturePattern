//
//  ViewController.swift
//  FeaturePattern
//
//  Created by Robin Charlton on 12/07/2021.
//

import UIKit

protocol AccountsViewActions {
    func setupAccounts()
}

class State {
    let string1: Observable<String> = PropertySubject(value: "initial")

    @ObservableState var string2: String = "First"
}


class AccountsViewController: UIViewController {

    typealias Presenteractor = AccountsViewActions

    @UserDefault(key: "lrd") var lastRunDate: Date?

    @ObservableState var string: String = "First"
    let string1 = PassthroughSubject<String>()
    let string2 = PropertySubject<String>(value: "cat")

    let state = State()

    private let setupYourAccountsButton = configure(UIButton(type: .system)) {
        $0.setTitle("Set-up Your Accounts", for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    var observation: Observation?

    private let presenteractor: Presenteractor

    init(presenteractor: Presenteractor) {
        self.presenteractor = presenteractor

        super.init(nibName: nil, bundle: nil)

        tabBarItem = UITabBarItem(title: "Accounts", image: nil, tag: 0)

        let v1: ValueChange<Int> = .initial(123)
        let v2: ValueChange<Int> = .unchanged(123)

        observation = $string.observe {
            print("Name changed from \($0.previous ?? "none") to \($0.current)")
        }

        state.string1.observe {
            print($0)
        }
        // state.string1 = "Hello" // cannot mutate

        state.$string2.observe {
            print($0)
        }
        state.string2 = "hello"

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        string = "Hello"
        string = "There"

        print(lastRunDate)
        lastRunDate = Date()

        view.backgroundColor = .white

        view.addSubview(setupYourAccountsButton)
        NSLayoutConstraint.activate([
            setupYourAccountsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            setupYourAccountsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40)
        ])

        setupYourAccountsButton.addTarget(
            self,
            action: #selector(setupYourAccountsButtonPressed),
            for: .touchUpInside
        )
    }

    @objc private func setupYourAccountsButtonPressed() {
        presenteractor.setupAccounts()
    }

}


@propertyWrapper struct UserDefault<Value> {
    let key: String
    var userDefaults: UserDefaults = .standard

    var wrappedValue: Value? {
        get { userDefaults.value(forKey: key) as? Value }
        set { userDefaults.setValue(newValue, forKey: key) }
    }
}


@propertyWrapper class Test {

    var wrappedValue: Int? {
        get { 1 }
        set { }
    }

}
