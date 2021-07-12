//
//  ViewController.swift
//  FeaturePattern
//
//  Created by Robin Charlton on 12/07/2021.
//

import UIKit

protocol ViewActions {
    /// Signal that the view is ready to present state and active behaviours such as timers should begin.
    func resume()

    /// Signal that the view is no longer presenting state and active behaviours such as timers should pause.
    func suspend()
}

extension ViewActions {
    func resume() { }
    func suspend() { }
}

// MARK: -

/// Actions state WHAT rather than HOW. They are semantic / conceptual and do not mirror the private
/// internals of the view hierarchy such as button presses and table view cell selections.
protocol AccountsViewActions: ViewActions {
    func setupAccounts()
}

/// ViewState captures the entire range of state that the view can present.
/// View properties are always private and never manipulated from outside the class.
/// As with ViewActions, ViewState should not explicitly reflect the view hierarchy.
struct AccountsViewState {
    var isSetupYourAccountsEnabled: Bool
}

protocol AccountsViewStateProviding {
    var viewState: Observable<AccountsViewState> { get }
}

// MARK: -

class AccountsViewController: UIViewController, StateRepresentable {
    typealias Presenteractor = AccountsViewActions & AccountsViewStateProviding
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

        presenteractor.resume()
    }

    // MARK: -

    func setState(_ state: State, animated isAnimated: Bool) {
        print(#function, state)
        setupYourAccountsButton.isEnabled = state.isSetupYourAccountsEnabled
    }

    // MARK: -

    @objc private func setupYourAccountsButtonPressed() {
        presenteractor.setupAccounts()
    }

}
