//
//  AuthorizationHandler.swift
//  PantherAppIOS
//
//  Created by mohamed on 8/5/19.
//  Copyright © 2019 mohamed. All rights reserved.
//

import Foundation

protocol AuthorizationHandler {
    var tokenHeader: [String: String] { get }
    var clientHeader: [String: String] { get }
    var uidHeader: [String: String] { get }
    func setAuthManually(authToken: String)
    func setClientManually(client: String)
    func setUidManually(uid: String)
    func removeAuthManually(authToken: String)
    func removeClientManually(client: String)
    func removeUidManually(uid: String)
    
}
