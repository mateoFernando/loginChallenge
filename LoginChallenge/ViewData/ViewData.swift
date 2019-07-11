//
//  ViewData.swift
//  LoginChallenge
//
//  Created by Fernando Mateo on 7/10/19.
//  Copyright © 2019 Fernando Mateo. All rights reserved.
//

import Foundation

public protocol ViewData {
}


struct UserLoginViewData:ViewData {
    let name: String
    let lastName: String
    let age: String
    let birth: String
    let email: String
    let phoneNumber: String
    let facebookId: String
}
