//
//  ViewController.swift
//  FeaturePattern
//
//  Created by Robin Charlton on 12/07/2021.
//

import UIKit

protocol ViewEventHandling {
    func viewDidLoad()
    func viewWillAppear()
}

extension ViewEventHandling {
    func viewDidLoad() { }
    func viewWillAppear() { }
}

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
    typealias Presenteractor = AccountsViewActions & AccountsViewStateProviding & ViewEventHandling
    typealias State = AccountsViewState

    private let setupYourAccountsButton = configure(UIButton(type: .system)) {
        $0.setTitle("Set-up Your Accounts", for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private var observation: Observation?

    private let presenteractor: Presenteractor

    init(presenteractor: Presenteractor) {
        self.presenteractor = presenteractor

        super.init(nibName: nil, bundle: nil)

        tabBarItem = UITabBarItem(title: "Accounts", image: nil, tag: 0)

//        observation = presenteractor.viewState.observe { [weak self] in
//            self?.setState($0)
//        }
        observation = bind(to: presenteractor.viewState)
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

        presenteractor.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenteractor.viewWillAppear()
    }

    func setState(_ state: State, animated isAnimated: Bool) {
        print(#function, state)
        setupYourAccountsButton.isEnabled = state.isSetupYourAccountsEnabled
    }

    @objc private func setupYourAccountsButtonPressed() {
        presenteractor.setupAccounts()
    }

}
