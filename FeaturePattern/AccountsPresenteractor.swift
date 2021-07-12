//
//  AccountsPresenteractor.swift
//  FeaturePattern
//
//  Created by Robin Charlton on 12/07/2021.
//

import Foundation

class AccountsPresenteractor {
    private let viewStateSubject = PropertySubject(AccountsViewState.initial)
}

extension AccountsPresenteractor: AccountsViewStateProviding {
    var viewState: Observable<AccountsViewState> {
        viewStateSubject
    }
}

extension AccountsPresenteractor: ViewEventHandling {
    func viewWillAppear() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.viewStateSubject.value = AccountsViewState(isSetupYourAccountsEnabled: true)
        }
    }
}

extension AccountsPresenteractor: AccountsViewActions {
    func setupAccounts() {
        print(type(of: self), #function)
    }
}

private extension AccountsViewState {
    static let initial = AccountsViewState(isSetupYourAccountsEnabled: false)
}
