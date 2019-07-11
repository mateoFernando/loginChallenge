//
//  RegisterRouter.swift
//  LoginChallenge
//
//  Created by Fernando Mateo on 7/10/19.
//  Copyright © 2019 Fernando Mateo. All rights reserved.
//

import Foundation
import UIKit

protocol RegisterRouterInterface {
    
    var currentViewController: RegisterViewController? {set get}
    func routerToBack()
}

class RegisterRouter {
    
    weak var currentViewController: RegisterViewController?
    
    init(_ currentViewController: RegisterViewController) {
        
        self.currentViewController = currentViewController
    }
}

extension RegisterRouter : RegisterRouterInterface {
    
    func routerToBack() {
        currentViewController?.navigationController?.popViewController(animated: true)
    }
}
