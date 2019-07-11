//
//  RegisterViewController.swift
//  LoginChallenge
//
//  Created by Fernando Mateo on 7/10/19.
//  Copyright © 2019 Fernando Mateo. All rights reserved.
//

import UIKit

protocol RegisterViewControllerInterface {
    
    func setupInitialView()
    func setTextName(name: String)
    func setTextLastName(lastName: String)
    func setTextAge(age: String)
    func setTextBirthday(birthday: String)
    
    func showLoading()
    func hideLoading()
    func showAlert(alert: UIAlertController)
}

class RegisterViewController: UIViewController , UITextFieldDelegate {
    
    var presenter: RegisterPresenterInterface?
    var configurator = RegisterConfigurator()
    var alert: UIAlertController!
    var data: ViewData!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var loadingRegister: UIActivityIndicatorView!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnGoBack: UIButton!
    
    private var datePicker : UIDatePicker?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        configurator.configure(viewController: self, data: self.data)
        presenter?.notifyViewLoaded()
    }
    
    
    @IBAction func registerUser(_ sender: Any) {
        
        if (emptyFields()) {
            return
        }
        
        let parameters : [String : String] =
            ["name": "\(self.txtName.text!)",
        "lastName": "\(self.txtLastName.text!)",
        "age": "\(self.txtAge.text!)",
        "birthday": "\(self.txtBirthday.text!)"]
        presenter?.registerUserToDB(param: parameters )
    }
    
    @IBAction func goBack(_ sender: Any) {
        presenter?.goBack()
    }
}

extension RegisterViewController : RegisterViewControllerInterface{
    
    func setupInitialView() {
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self,
                              action: #selector(dateChanged(datePicker:)),
                              for: .valueChanged)
        txtBirthday.inputView = datePicker
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        txtBirthday.text = dateFormatter.string(from: datePicker.date)
    }
    
    func showLoading() {
        
        btnRegister.isUserInteractionEnabled = false
        btnGoBack.isUserInteractionEnabled = false
        loadingRegister.startAnimating()
    }
    
    func hideLoading() {
        
        btnRegister.isUserInteractionEnabled = true
        btnGoBack.isUserInteractionEnabled = true
        loadingRegister.stopAnimating()
    }
    
    func emptyFields() -> Bool {
        
        if (
            txtName.text! == "" ||
            txtLastName.text! == "" ||
            txtAge.text! == "" ||
                txtBirthday.text! == "" ) {
            presenter?.validateFields()
            return true
        }
        
        return false
    }
}

extension RegisterViewController {
    
    func setTextName(name: String)
    {
        self.txtName.text = name
    }
    
    func setTextLastName(lastName: String)
    {
        self.txtLastName.text = lastName
    }
    
    func setTextAge(age: String)
    {
        self.txtAge.text = age
    }
    
    func setTextBirthday(birthday: String)
    {
        self.txtBirthday.text = birthday
    }
}

// MARK: TEXTFIELD DELEGATE

extension RegisterViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if ( textField == txtName ) {
            txtLastName.becomeFirstResponder()
        }
        else if ( textField == txtLastName ) {
            txtAge.becomeFirstResponder()
        }
        else if ( textField == txtAge ) {
            txtBirthday.becomeFirstResponder()
        }
        else {
            txtBirthday.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func didTapGesture(_ sender: Any) {
        self.view.endEditing(true)
    }
}

//MARK: ALERT

extension RegisterViewController {
    
    func showAlert(alert: UIAlertController) {
        
        self.alert = alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissAlert() {
        
        self.alert.dismiss(animated: true, completion: nil)
    }
}
