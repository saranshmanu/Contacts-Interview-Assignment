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
    case putContactDetails = 3
}

class NetworkRouter {
    var serviceURL = [
        0: "contacts.json",
        1: "contacts/",
        2: "contacts.json",
        3: "contacts/"
    ] as [Int: String]
    
    var serviceHTTPMethod = [
        0: .get,
        1: .get,
        2: .post,
        3: .put
    ] as [Int: HTTPMethod]
    
    func serverBaseURL() -> String { return "https://gojek-contacts-app.herokuapp.com/" }
    func getNetworkRoute(service: Service) -> String {
        return serviceURL[service.rawValue]!
    }
    
    func getNetworkHTTPMethod(service: Service) -> HTTPMethod {
        return serviceHTTPMethod[service.rawValue]!
    }
}
