//
//  AccountsPresenteractor.swift
//  FeaturePattern
//
//  Created by Robin Charlton on 12/07/2021.
//

import Foundation

class AccountsPresenteractor: AccountsViewController.Presenteractor {
    let viewState: Observable<AccountsViewState> = PropertySubject(.initial)

    func setupAccounts() {
        print(type(of: self), #function)
    }
}

extension AccountsViewState {
    static let initial = AccountsViewState(isSetupYourAccountsEnabled: false)
}
