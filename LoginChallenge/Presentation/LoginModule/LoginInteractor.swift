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
}

class LoginInteractor {
    
    let service = NetService()
    var presenter:LoginPresenterInterface?
}

extension LoginInteractor:LoginInteractorInterface{
    
}
