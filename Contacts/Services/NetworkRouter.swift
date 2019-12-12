//
//  NetworkRouter.swift
//  Contacts
//
//  Created by Saransh Mittal on 12/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation
import Alamofire

enum Service: Int {
    case getContact = 0
    case getContactDetails = 1
    case postContactDetails = 2
}

class NetworkRouter {
    var serviceURL = [
        0: "contacts.json",
        1: "contacts/",
        2: "contacts.json"
    ] as [Int: String]
    
    var serviceHTTPMethod = [
        0: .get,
        1: .get,
        2: .post
    ] as [Int: HTTPMethod]
    
    // base URL for the server
    func serverBaseURL() -> String { return "https://gojek-contacts-app.herokuapp.com/" }
    
    func getNetworkRoute(service: Service) -> String {
        return serviceURL[service.rawValue]!
    }
    
    func getNetworkHTTPMethod(service: Service) -> HTTPMethod {
        return serviceHTTPMethod[service.rawValue]!
    }
}
