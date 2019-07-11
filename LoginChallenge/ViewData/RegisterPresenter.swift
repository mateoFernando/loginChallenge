//
//  RegisterPresenter.swift
//  LoginChallenge
//
//  Created by Fernando Mateo on 7/10/19.
//  Copyright © 2019 Fernando Mateo. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol RegisterPresenterInterface{
    
    func notifyViewLoaded()
    func goBack()
    func validateFields()
    
    func registerUserToDB(param: [String : String] )
    func getName() -> String
    func getLastName() -> String
    func getAge() -> String
    func getBirth() -> String
}


class RegisterPresenter{
    
    var view:RegisterViewControllerInterface?
    var router: RegisterRouterInterface?
    var viewData: ViewData?
    var interactor: RegisterInteractorInterface?
    
    init(view:RegisterViewControllerInterface, router:RegisterRouterInterface, interactor:RegisterInteractorInterface, viewData:ViewData?) {
        self.view = view
        self.router = router
        self.viewData = viewData
        self.interactor = interactor
    }
}

extension RegisterPresenter : RegisterPresenterInterface {
    
    func notifyViewLoaded() {
        
        view?.setupInitialView()
        loadContent()
    }
    
    func goBack() {
        
        router?.routerToBack()
    }
    
    func loadContent() {
        
        self.view?.showLoading()
        
        guard let viewData = viewData as? UserLoginViewData else { return }
        if viewData.facebookId == "" {
            let ref = Database.database().reference().child("\(viewData.phoneNumber)")
            ref.observe(DataEventType.value) { (dataSnapshot) in
                guard let data = dataSnapshot.value as? [String:String] else {
                    
                    self.view?.hideLoading()
                    self.view!.setTextName(name:self.getName())
                    self.view!.setTextLastName(lastName:self.getLastName())
                    self.view!.setTextAge(age:self.getAge())
                    self.view!.setTextBirthday(birthday:self.getBirth())
                    return
                }
                
                self.view?.hideLoading()
                self.view!.setTextName(name:data["name"]!)
                self.view!.setTextLastName(lastName:data["lastName"]!)
                self.view!.setTextAge(age:data["age"]!)
                self.view!.setTextBirthday(birthday:data["birthday"]!)
            }
        }
        else {
            let ref = Database.database().reference().child("\(viewData.facebookId)")
            ref.observe(DataEventType.value) { (dataSnapshot) in
                guard let data = dataSnapshot.value as? [String:String] else {
                    
                    self.view?.hideLoading()
                    self.view!.setTextName(name:self.getName())
                    self.view!.setTextLastName(lastName:self.getLastName())
                    self.view!.setTextAge(age:self.getAge())
                    self.view!.setTextBirthday(birthday:self.getBirth())
                    return
                }
                
                self.view?.hideLoading()
                self.view!.setTextName(name:data["name"]!)
                self.view!.setTextLastName(lastName:data["lastName"]!)
                self.view!.setTextAge(age:data["age"]!)
                self.view!.setTextBirthday(birthday:data["birthday"]!)
            }
        }
    }
}

extension RegisterPresenter {
    
    func getName() -> String {
        guard let viewData = viewData as? UserLoginViewData else {return ""}
        return viewData.name
    }
    
    func getLastName() -> String {
        guard let viewData = viewData as? UserLoginViewData else {return ""}
        return viewData.lastName
    }
    
    func getAge() -> String {
        guard let viewData = viewData as? UserLoginViewData else {return ""}
        return viewData.age
    }
    
    func getBirth() -> String {
        guard let viewData = viewData as? UserLoginViewData else {return ""}
        return viewData.birth
    }
    
    func validateFields() {
        showSimpleAlert(title: "Error", message: "Completar todos los campos")
    }
}

extension RegisterPresenter {
    
    func registerUserToDB(param: [String : String] ) {
        
        view?.showLoading()
        guard let viewData = viewData as? UserLoginViewData else { return }
        
        if viewData.facebookId == "" {
            let ref = Database.database().reference().child("\(viewData.phoneNumber)")
            ref.setValue(param, withCompletionBlock: { (error, reference) in
                if (error != nil) {
                    self.showSimpleAlert(title: "Error", message: error!.localizedDescription)
                }
                self.showSimpleAlert(title: "Felicidades", message: "Se actualizó el usuario")
                self.view?.hideLoading()
            })
        }
        else {
            let ref = Database.database().reference().child("\(viewData.facebookId)")
            ref.setValue(param, withCompletionBlock: { (error, reference) in
                if (error != nil) {
                    self.showSimpleAlert(title: "Error", message: error!.localizedDescription)
                }
                self.showSimpleAlert(title: "Felicidades", message: "Se actualizó el usuario")
                self.view?.hideLoading()
            })
        }
        
        
    }
}

extension RegisterPresenter {
    
    func showSimpleAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            
        }))
        self.view?.showAlert(alert:alert)
    }
    
}
