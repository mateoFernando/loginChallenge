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
        
//        // Create layers
//        let router = LoginRouter()
//        let presenter = LoginPresenter()
//        let interactor = LoginInteractor()
//        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//
//        // Connect layers
//        presenter.interactor = interactor
//        presenter.router = router
//        presenter.view = view
//        view.presenter = presenter
//        interactor.presenter = presenter
//        router.presenter = presenter
//        router.navigationController = navigationController
        
//    func configure(viewController: LoginViewController) {
//        viewController.presenter = LoginPresenter(view:viewController,router:LoginRouter(withView:viewController), interactor: DeviceInteractor(repository: DeviceRepositoryImpl.sharedInstance), andData:viewController.viewData)
//    }
    }
}

//static func createModule(using navigationController:UINavigationController) -> LoginViewController{
//    
//    // Create layers
//    let router = LoginRouter()
//    let presenter = LoginPresenter()
//    let interactor = LoginInteractor()
//    let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//    
//    // Connect layers
//    presenter.interactor = interactor
//    presenter.router = router
//    presenter.view = view
//    view.presenter = presenter
//    interactor.presenter = presenter
//    router.presenter = presenter
//    router.navigationController = navigationController
//    
//    return view
//}
