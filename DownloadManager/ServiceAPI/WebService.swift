//
//  WebService.swift
//  DownloadManager
//
//  Created by Marcelo Sampaio on 09/05/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import Foundation

class WebService {
    
    // MARK: - Class Methods
    //
    //
    //
    
    // MARK: - Class Helper
    class func getEndpoint(_ identifier: String) -> String {
        
        var result = String()
        
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist") {
            // file root is a dictionary
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                result = dic[identifier] as! String
            }
        }
        return result
    }
    
    // MARK: - Request Body Helper
    class func createBodyDataWithQueryParams(parameters: [String: Any]) -> Data {
        let params = createQueryParams(parameters: parameters)
        return params.data(using: String.Encoding.utf8)!
    }
    class func createQueryParams(parameters: [String: Any]) -> String {
        let parameterArray = parameters.map { (key, value) in
            return "\(key)=\(value)"
        }
        return parameterArray.joined(separator: "&")
    }
}

