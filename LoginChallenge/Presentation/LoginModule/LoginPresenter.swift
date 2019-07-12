//
//  LoginPresenter.swift
//  LoginChallenge
//
//  Created by Fernando Mateo on 7/9/19.
//  Copyright © 2019 Fernando Mateo. All rights reserved.
//

import Foundation
import Firebase
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import FirebaseAuth

protocol LoginPresenterInterface{
    // LoginView -> LoginPresenter
    func notifyViewLoaded()
    func notifyViewWillDisappear()
    func getuserLogin() -> UserLoginViewData
    
    func loginWithPhoneNumber()
    func loginWithFacebook()
}

typealias AddressViewModel = (title:String, city:String, nameSurname:String, address:String)

class LoginPresenter {
    
    var view:LoginViewControllerInterface?
    var router:LoginRouterInterface?
    var interactor:LoginInteractorInterface?
    var viewData: ViewData?
    
    let loginManager = LoginManager()
    var userLogin : UserLoginViewData?
    
    let kAddressDetailSegueIdentifier = "goToRegister"
    
    init(view:LoginViewControllerInterface, router:LoginRouterInterface,interactor:LoginInteractorInterface) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}
extension LoginPresenter {
    
    func showSimpleAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            
        }))
        self.view?.showAlert(alert:alert)
    }
}

extension LoginPresenter : LoginPresenterInterface{
    
    func notifyViewLoaded() {
        view?.setupInitialView()
    }
    
    func notifyViewWillDisappear() {
        view?.cleanFields()
    }
    
    func getuserLogin() -> UserLoginViewData {
        
        return self.userLogin!
    }
    
    func loginWithPhoneNumber() {
        
        view?.showLoading()
        Auth.auth().languageCode = "es-PE";
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        let verificationCode = self.view?.getVerificationCode()
        
        PhoneAuthProvider.provider().verifyPhoneNumber((self.view?.getPhoneNumber())!, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                self.view?.hideLoading()
                self.showSimpleAlert(title: "Error", message: error.localizedDescription)
                return
            }
            
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
                verificationCode: verificationCode!)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    self.view?.hideLoading()
                    self.showSimpleAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                
                let user = Auth.auth().currentUser
                if let user = user {
                    
                    self.view?.hideLoading()
                    let phoneNumber = user.phoneNumber
                    
                    self.userLogin = UserLoginViewData(name: "", lastName: "", age: "", birth: "", email: "", phoneNumber: phoneNumber!, facebookId: "")
                    
                    self.router!.routeToRegister(viewData:self.userLogin!)
                }
            }
        }
        
    }
    
    func loginWithFacebook() {
        
        view?.showLoading()
        loginManager.logOut()
        loginManager.logIn(permissions: [Permission.publicProfile, Permission.email ], viewController: self.view?.getViewController(), completion: { loginResult in
            switch loginResult {
            case .failed(let error):
                self.view?.hideLoading()
                self.showSimpleAlert(title: "Error", message: error.localizedDescription)
                print(error)
            case .cancelled:
                self.view?.hideLoading()
                print("User cancelled login.")
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                
                print("\(grantedPermissions) \(declinedPermissions) \(accessToken) Logged in!")
                
                let connection = GraphRequestConnection()
                let request = GraphRequest.init(graphPath: "me")
                request.parameters = ["fields":"email,first_name,last_name"]
                connection.add(request, completionHandler: { connection, values, error in
                    if error != nil {
                        self.view?.hideLoading()
                        self.showSimpleAlert(title: "Error", message: error.debugDescription)
                        NSLog(error.debugDescription)
                        return
                    }
                    print(values!)
                    
                    if let result = values as? [String:String],
                        let email: String = result["email"],
                        let firstName: String = result["first_name"],
                        let lastName: String = result["last_name"] ,
                        let faceId: String = result["id"] {
                        
                        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                        Auth.auth().signIn(with: credential) { (authResult, error) in
                            if let error = error {
                                print(error)
                                return
                            }
                            let user = Auth.auth().currentUser
                            if user != nil {
                                
                                self.view?.hideLoading()
                                self.userLogin = UserLoginViewData(name: firstName, lastName: lastName, age: "", birth: "", email: email, phoneNumber: "", facebookId: faceId)
                                self.router!.routeToRegister(viewData:self.userLogin!)
                            }
                        }
                    }
                    
                })
                connection.start()
            }
        })
    }
}


