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

extension AccountsPresenteractor: AccountsViewActions {
    func resume() {
        print(type(of: self), #function)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.viewStateSubject.value = AccountsViewState(isSetupYourAccountsEnabled: true)
        }
    }

    func setupAccounts() {
        print(type(of: self), #function)

        viewStateSubject.value = viewStateSubject.value.mutated {
            $0.isSetupYourAccountsEnabled = false
        }
    }
}

private extension AccountsViewState {
    static let initial = AccountsViewState(isSetupYourAccountsEnabled: false)
}

// MARK: -

private struct AccountsViewStateBuilder {
    var isSetupYourAccountsEnabled: Bool

    init(from accountsViewState: AccountsViewState) {
        isSetupYourAccountsEnabled = accountsViewState.isSetupYourAccountsEnabled
    }

    func build(using builder: (inout AccountsViewStateBuilder) -> Void) -> AccountsViewState {
        var value = self
        builder(&value)
        return AccountsViewState(isSetupYourAccountsEnabled: value.isSetupYourAccountsEnabled)
    }
}

// MARK: -

private extension AccountsViewState {
    func mutated(using builder: (inout AccountsViewStateBuilder) -> Void) -> AccountsViewState {
        AccountsViewStateBuilder(from: self).build(using: builder)
    }
}
