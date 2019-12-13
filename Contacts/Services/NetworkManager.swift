//
//  NetworkManager.swift
//  Contacts
//
//  Created by Saransh Mittal on 11/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation
import Alamofire

// Network Handler class to manage the network request
class NetworkManager {
    
    var uuid: Int?
    private func getURL(service: Service) -> URL {
        var urlString = NetworkRouter().serverBaseURL() + NetworkRouter().getNetworkRoute(service: service)
        if service == .getContactDetails || service == .putContactDetails {
            urlString.append("\(uuid ?? 0)" + ".json")
        }
        let url = URL(string: urlString)
        return url!
    }
    
    // network request to handle the error and other network parameters
    public func request(service: Service, header: HTTPHeaders? = [:], parameters: Parameters? = [:], completion: @escaping (Bool, Any?) -> ()) {
        let url = getURL(service: service)
        let method = NetworkRouter().getNetworkHTTPMethod(service: service)
        if method == .get {
            Alamofire.request(
                url, method: method
            ).responseJSON { response in
                    switch response.result {
                case .success(_) :
                    let result = response.result.value as Any
                    completion(false, result)
                case .failure :
                    completion(true, nil)
                }
            }
        } else {
            Alamofire.request(
                url, method: method,
                parameters: parameters!,
                encoding: JSONEncoding.init(),
                headers: ["Content-Type": "application/json"]
            ).responseJSON { response in
                    switch response.result {
                case .success(_) :
                    let result = response.result.value as Any
                    completion(false, result)
                case .failure :
                    completion(true, nil)
                }
            }
        }
        
    }
        
    // fetch the image from the internet
    public func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
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
