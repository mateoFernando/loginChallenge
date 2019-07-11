//
//  LoginViewController.swift
//  LoginChallenge
//
//  Created by Fernando Mateo on 7/9/19.
//  Copyright © 2019 Fernando Mateo. All rights reserved.
//

import UIKit
import AVFoundation

protocol LoginViewControllerInterface {
    // LoginPresenter->LoginView
    func showLoading()
    func hideLoading()
    func setupInitialView()
    func cleanFields()
    
    func getPhoneNumber() -> String
    func getVerificationCode() -> String
    func getViewController() -> UIViewController
    func showAlert(alert: UIAlertController)
    func dismissAlert()
}

class LoginViewController: UIViewController , UITextFieldDelegate {
    
    var presenter:LoginPresenterInterface?
    var configurator = LoginConfigurator()
    var isPhoneLogin = true
    var alert: UIAlertController!
    
    @IBOutlet weak var btnPhoneLogin: UIButton!
    @IBOutlet weak var btnFacebookLogin: UIButton!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtVerificationCode: UITextField!
    @IBOutlet weak var loadingPhoneLogin: UIActivityIndicatorView!
    @IBOutlet weak var loadingFacebookLogin: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configurator.configure(viewController: self)
        presenter?.notifyViewLoaded()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        presenter?.notifyViewWillDisappear()
    }
    
    @IBAction func loginWithPhoneNumber(_ sender: Any) {
        isPhoneLogin = true
        presenter?.loginWithPhoneNumber()
    }
    
    @objc func loginButtonClicked() {
        isPhoneLogin = false
        presenter?.loginWithFacebook()
    }
}

extension LoginViewController:LoginViewControllerInterface {
    
    func setupInitialView() {
        navigationController?.navigationBar.isHidden = true
        btnFacebookLogin.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
    }
    
    func cleanFields() {
        
        self.txtVerificationCode.text = ""
        self.txtPhoneNumber.text = ""
    }
    
    func showLoading() {
        
        if ( isPhoneLogin ) {
            btnPhoneLogin.isUserInteractionEnabled = false
            btnFacebookLogin.isUserInteractionEnabled = false
            loadingPhoneLogin.startAnimating()
        }
        else {
            btnPhoneLogin.isUserInteractionEnabled = false
            btnFacebookLogin.isUserInteractionEnabled = false
            loadingFacebookLogin.startAnimating()
        }
    }
    
    func hideLoading() {
        
        if ( isPhoneLogin ) {
            btnPhoneLogin.isUserInteractionEnabled = true
            btnFacebookLogin.isUserInteractionEnabled = true
            loadingPhoneLogin.stopAnimating()
        }
        else {
            btnPhoneLogin.isUserInteractionEnabled = true
            btnFacebookLogin.isUserInteractionEnabled = true
            loadingFacebookLogin.stopAnimating()
        }
    }
    
    func getPhoneNumber() -> String {
        
        let number = self.txtPhoneNumber.text! == "" ? "" : "+51\(self.txtPhoneNumber.text!)"
        return number
    }
    
    func getVerificationCode() -> String {
        
        return self.txtVerificationCode.text!
    }
    
    func getViewController() -> UIViewController {
        
        return self
    }
}

//MARK: ALERT

extension LoginViewController {
    
    func showAlert(alert: UIAlertController) {
        
        self.alert = alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissAlert() {
        
        self.alert.dismiss(animated: true, completion: nil)
    }
}

// MARK: TEXTFIELD DELEGATE

extension LoginViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if ( textField == txtPhoneNumber ) {
            txtVerificationCode.becomeFirstResponder()
        }
        else {
            txtVerificationCode.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func didTapGesture(_ sender: Any) {
        self.view.endEditing(true)
    }
}
