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

struct AccountsViewState {
    var isSetupYourAccountsEnabled: Bool
}

protocol AccountsViewStateProviding {
    var viewState: Observable<AccountsViewState> { get }
}

class AccountsViewController: UIViewController, StateRepresentable {
    typealias Presenteractor = AccountsViewActions & AccountsViewStateProviding
    typealias State = AccountsViewState

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

        observation = presenteractor.viewState.observe { [weak self] in
            self?.setState($0)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

    func setState(_ state: State, animated isAnimated: Bool) {
        print(#function, state)
        setupYourAccountsButton.isEnabled = state.isSetupYourAccountsEnabled
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
