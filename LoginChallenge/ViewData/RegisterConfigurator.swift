//
//  RegisterConfigurator.swift
//  LoginChallenge
//
//  Created by Fernando Mateo on 7/10/19.
//  Copyright © 2019 Fernando Mateo. All rights reserved.
//

import Foundation
import UIKit

protocol RegisterConfiguratorInterface {
    func configure(viewController: RegisterViewController, data: ViewData )
}

class RegisterConfigurator : RegisterConfiguratorInterface {
    
    func configure(viewController: RegisterViewController, data: ViewData) {
        
        let router = RegisterRouter(viewController)
        viewController.presenter = RegisterPresenter(view: viewController, router: router, interactor: RegisterInteractor(), viewData: data)
    }
}
