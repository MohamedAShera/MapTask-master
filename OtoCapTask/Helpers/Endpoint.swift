//
//  Endpoint.swift
//  SurvvCustomer
//
//  Created by mohamed on 5/12/19.
//  Copyright © 2019 mohamed. All rights reserved.
//

import Foundation

protocol Endpoint {
    var service: EndpointService {get set}
    var url: String {get set}
    var method: EndpointMethod {get set}
    var auth: AuthorizationHandler {get set}
    var parameters: [String: Any] {get set}
    var encoding: EndpointEncoding {get set}
    var headers: [String: String] {get set}
}

enum EndpointEncoding {
    case json
    case query
}

enum EndpointMethod: String {
    case get
    case post
    case put
    case delete
}

enum EndpointService {
    case auth
    case countries
    case home
    case meetings
    case follow_ups
    case ocrConnection
    case connections
    case users
    case user
    
    var url: String {
        if self == .home || self == .ocrConnection {
            return "https://arborapp.io"
        }
        return "https://arborapp.io/\(self)"
    }
    
}
