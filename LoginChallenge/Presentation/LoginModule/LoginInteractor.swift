//
//  LoginInteractor.swift
//  LoginChallenge
//
//  Created by Fernando Mateo on 7/9/19.
//  Copyright © 2019 Fernando Mateo. All rights reserved.
//

import Foundation

protocol LoginInteractorInterface {
    // LoginPresenter -> LoginInteractor
    func fetchAddressList()
}

class LoginInteractor {
    
    let service = NetService()
    var presenter:LoginPresenterInterface?
}

extension LoginInteractor:LoginInteractorInterface{
    
    func fetchAddressList() {
//        service.fetchAddressList(onSuccess: {[weak self] (addressList) in
//            self?.presenter?.addressListFetched(addressList: addressList)
//        }) {[weak self] (errorMessage) in
//            self?.presenter?.addressListFetchFailed(with: errorMessage)
//        }
    }
}
