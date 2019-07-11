//
//  LoginConfigurator.swift
//  LoginChallenge
//
//  Created by Fernando Mateo on 7/10/19.
//  Copyright © 2019 Fernando Mateo. All rights reserved.
//

import Foundation
import UIKit

protocol LoginConfiguratorInterface{
    func configure(viewController: LoginViewController)
}

class LoginConfigurator : LoginConfiguratorInterface {
    
    func configure(viewController: LoginViewController ) {
        
        let router = LoginRouter(viewController)
        
        viewController.presenter = LoginPresenter(view:viewController,router:router, interactor: LoginInteractor())
    }
}
