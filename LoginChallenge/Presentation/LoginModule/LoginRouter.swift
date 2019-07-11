//
//  LoginRouter.swift
//  LoginChallenge
//
//  Created by Fernando Mateo on 7/9/19.
//  Copyright © 2019 Fernando Mateo. All rights reserved.
//

import Foundation
import UIKit

protocol LoginRouterInterface {
    // LoginPresenter -> LoginRouter
    var currentViewController: LoginViewController? {set get}
    func routeToRegister(viewData: ViewData) 
}

class LoginRouter {
    
    weak var currentViewController: LoginViewController?
    
    init(_ currentViewController: LoginViewController) {
        
        self.currentViewController = currentViewController
    }
}

extension LoginRouter : LoginRouterInterface {
    
    func routeToRegister(viewData: ViewData) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as? RegisterViewController else { return }
        viewController.data = viewData
        currentViewController?.navigationController?.pushViewController(viewController, animated: true)
    }
}


