//
//  ApiController.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 12/7/20.
//

import Foundation
import UIKit

final class ApiController {
    
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum NetworkError: Error {
        case noData, failedSignUp, failedSignIn, noToken, tryAgain, invalidURL, invalidImageData
    }

    
    func getToken(completionHandler: @escaping (Bearer) -> Void) {
        
        let parameters = "username=Zach&password=EYy6fb3E@wE9ZADBf8UKK42E"
        let postData =  parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://development-290808.ew.r.appspot.com/token")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else { return }
            do {
                let bearerData = try JSONDecoder().decode(Bearer.self, from: data)
                
                completionHandler(bearerData)
            } catch {
                let error = error
                print(error.localizedDescription)
                
            }
            
        }
        
        task.resume()
    }
    
    
    func getPosts(with token: String) {
        
        
        var request = URLRequest(url: URL(string: "https://development-290808.ew.r.appspot.com/scenario/list")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            let stringData = (String(data: data, encoding: .utf8)!)
            print(stringData)
        }
        
        task.resume()

    }
}




