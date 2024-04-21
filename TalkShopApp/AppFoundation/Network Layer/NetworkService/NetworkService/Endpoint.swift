//
//  Endpoint.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 18/04/24.

import Foundation

protocol Endpoint {
    var baseUrl: String { get }
    var httpMethod: HTTPMethod { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    var urlRequest: URLRequest? { get }
    var body: [String: Any]? { get }
}

// MARK: - Default properties

extension Endpoint {
  
    var baseUrl: String {
        "https://www.jsonkeeper.com"
    }
    
  var queryItems: [URLQueryItem]? {
    return nil 
  }
    var body: [String: Any]? {
        nil
    }
    
  
  var url: URL? {
    guard var urlComponents = URLComponents(string: baseUrl) else { return nil }
    urlComponents.path = path
    urlComponents.queryItems = queryItems
    
    return urlComponents.url
  }
  
  var urlRequest: URLRequest? {
    return makeUrlRequest()
  }
}

// MARK: - Helper

private extension Endpoint {
  
  /** Helper factory to create `URLRequest` */
    
    func makeUrlRequest() -> URLRequest? {
        guard let url = url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.asString
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if httpMethod == .post {
            if let body = body {
                if let httpBody = try? JSONSerialization.data(withJSONObject: body, options: [.prettyPrinted]) {
                    request.httpBody = httpBody
                }
            }
        }
        
        return request
    }
  
}

enum ServerStatus: String {
    case success
    case failure
    case unknown = ""
}
