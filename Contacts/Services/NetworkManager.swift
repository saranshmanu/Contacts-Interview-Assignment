//
//  NetworkManager.swift
//  Contacts
//
//  Created by Saransh Mittal on 11/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation
import Alamofire

// the Network Handler class manages the network request for GET and POST requests
class NetworkManager {
    
    // list of all the services that are available with the
    var contactUUID: Int?
    enum Service: String {
        case getContact = "contacts.json"
        case getContactDetails = "contacts/"
    }
    
    // base URL for the server
    private func serverBaseURL() -> String? { return "https://gojek-contacts-app.herokuapp.com/" }
    
    private func getURL(service: Service) -> URL {
        var urlString = serverBaseURL()! + service.rawValue
        if service == .getContactDetails {
            urlString.append("\(contactUUID ?? 0)" + ".json")
        }
        let url = URL(string: urlString)
        return url!
    }
    
    // network request to handle the error and other network parameters
    public func request(service: Service, method: HTTPMethod, header: HTTPHeaders, parameters: Parameters, completion: @escaping (Bool, Any?) -> ()) {
        let url = getURL(service: service)
        print(url)
        Alamofire.request(url, method: method, parameters: parameters, headers: header).responseJSON { response in
            switch response.result {
            case .success(_) :
                let result = response.result.value as Any
                completion(false, result)
            case .failure :
                completion(true, nil)
            }
        }
    }
        
    public func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    // fetch the image from the internet
    public func downloadImage(from url: URL, completion: @escaping (UIImage?) -> ()) {
        var image: UIImage?
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            image = UIImage(data: data)
            completion(image)
        }
    }
}
