//
//  ApiController.swift
//  GermanTimeTravel
//
//  Created by Zachary Thacker on 12/7/20.
//

import UIKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum NetworkError: Error {
    case noData, failedResponse, failedError, failedDecode, noToken, tryAgain, invalidURL, invalidImageData
}

final class ApiController {
    
    // MARK: - Properties
    
    var bearer: Bearer?

    private let baseURL = URL(string: "https://time-translator.nordquint.de")!
    private lazy var tokenURL = baseURL.appendingPathComponent("/token")
    private lazy var scenarioURL = baseURL.appendingPathComponent("/scenario/")
    private lazy var imageURL = baseURL.appendingPathComponent("/image/jpg/")
    private lazy var aboutURL = baseURL.appendingPathComponent("/about")
    
    // MARK: - Public Functions
    
    /// called in modelController.signInAndGetScenarioList
    /// submits the api username and password to receive a bearer token
    /// - Parameter completion: completion is used in modelController to control app flow
    func signIn(completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        let parameters = "username=Cora&password=WYqEzBgjMBXyVNMYkZDgDeNwMmG"
        let postData =  parameters.data(using: .utf8)
        var request = URLRequest(url: tokenURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.checkResponse(for: "signIn", data, response, error) { result in
                switch result {
                case .success(let data):
                    do {
                        self.bearer = try JSONDecoder().decode(Bearer.self, from: data)
                        completion(.success(true))
                    } catch {
                        NSLog("Error decoding bearer token: \(error)")
                        completion(.failure(.noToken))
                    }
                default:
                    completion(.failure(.failedResponse))
                }
            }
        }
        task.resume()
    }
    
    /// called in modelController.signInAndGetScenarioList after api.signIn
    /// - Parameter completion: completion is used in modelController to control app flow
    func fetchSummaries(completion: @escaping (Result<[Summary], NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noToken))
            return
        }
        let url = scenarioURL.appendingPathComponent("list")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(bearer.access_token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.checkResponse(for: "fetchSummaries", data, response, error) { result in
                switch result {
                case .success(let data):
                    do {
                        let summaries = try JSONDecoder().decode([Summary].self, from: data)
                        completion(.success(summaries))
                    } catch {
                        NSLog("Error decoding summary data: \(error)")
                        completion(.failure(.failedDecode))
                    }
                default:
                    completion(.failure(.failedResponse))
                }
            }
        }
        task.resume()
    }
    
    /// called in HomeVC to fetch current text for display on About page
    /// - Parameter completion: completion is used in modelController to control app flow
    func fetchAbout(completion: @escaping (Result<About, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noToken))
            return
        }
        var request = URLRequest(url: aboutURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(bearer.access_token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.checkResponse(for: "fetchAbout", data, response, error) { result in
                switch result {
                case .success(let data):
                    do {
                        let aboutText = try JSONDecoder().decode(About.self, from: data)
                        completion(.success(aboutText))
                    } catch {
                        NSLog("Error decoding About text: \(error)")
                        completion(.failure(.failedDecode))
                    }
                default:
                    completion(.failure(.failedResponse))
                }
            }
        }
        task.resume()
    }
    
    /// fetches all data for a single scenario, including event information
    /// called in ModelController.startScenario
    /// - Parameters:
    ///   - nameID: accepts a nameId
    ///   - completion: returns a Scenario
    func fetchScenario(nameID: String, completion: @escaping (Result<Scenario, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noToken))
            return
        }
        let url = scenarioURL.appendingPathComponent("get/\(nameID)")
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(bearer.access_token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            self.checkResponse(for: "fetchScenario", data, response, error) { result in
                switch result {
                case .success(let data):
                    do {
                        let scenarioRep = try JSONDecoder().decode(ScenarioRepresentation.self, from: data)
                        let scenario = Scenario(scenarioRepresentation: scenarioRep)
                        completion(.success(scenario))
                    } catch {
                        NSLog("Error decoding scenario data: \(error)")
                        completion(.failure(.failedDecode))
                    }
                default:
                    completion(.failure(.failedResponse))
                }
            }
        }
        task.resume()
    }
    
    /// fetches an image through the API using the scenario and optionally, an event
    /// generates the URL from the scenario's nameId, and either the scenario's or the event's image
    /// called in modelController.loadImage
    /// - Parameters:
    ///   - summary: use a Summary for loading the image in RunTimeViewController, else set to nil
    ///   - scenario: use a Scenario for loading images everywhere except RunTimeViewController, where it is set to nil
    ///   - event: Optional - accepts an event, use if image is not the main Scenario image
    ///   - completion: returns UIImage
    func fetchImage(summary: Summary?, scenario: Scenario?, event: Event?, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let bearer = bearer else {
            completion(.failure(.noToken))
            return
        }
        var imageString = ""
        if let summary = summary {
            guard let image = summary.image else { return }
            imageString = image
        }
        else if let event = event {
            guard let image = event.image else { return }
            imageString = image
        } else {
            guard let image = scenario?.image else { return }
            imageString = image
        }
        let url = imageURL.appendingPathComponent(imageString)
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Bearer \(bearer.access_token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.checkResponse(for: "fetchImage", data, response, error) { result in
                switch result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        completion(.success(image))
                    }
                default:
                    completion(.failure(.failedResponse))
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Private Functions
    
    /// a helper function that checks data, response, and error from a data task
    /// - Parameters:
    ///   - taskDescription: accepts a String containing the function name where the data task is called for printing responses
    ///   - data: pass in the data received from the data task
    ///   - response: pass in the response received from the data task
    ///   - error: pass in the error received from the data task
    ///   - completion: returns either success(data) or failure(NetworkError)
    private func checkResponse(for taskDescription: String, _ data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        if let error = error {
            NSLog("\(taskDescription) failed with error: \(error)")
            completion(.failure(.failedError))
            return
        }
        if let response = response as? HTTPURLResponse,
           !(200...210 ~= response.statusCode) {
            NSLog("\(taskDescription) failed response - \(response)")
            completion(.failure(.failedResponse))
            return
        }
        guard let data = data,
              !data.isEmpty else {
            NSLog("Data was not received from \(taskDescription)")
            completion(.failure(.noData))
            return
        }
        completion(.success(data))
    }
    
}

