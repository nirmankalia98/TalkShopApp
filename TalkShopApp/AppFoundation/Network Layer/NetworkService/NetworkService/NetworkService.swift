//
//  NetworkService.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 18/04/24.

import Foundation

final class NetworkService {
  
  // Shared instance
  static let shared = NetworkService()
  
  private let cache: URLCache
  private let decoder: JSONDecoder
  private let session: URLSession
  private let taskManager: NetworkTaskManager
  
  private init(session: URLSession = URLSession(configuration: .default),
               cache: URLCache = URLCache.shared,
               decoder: JSONDecoder = JSONDecoder(),
               taskManager: NetworkTaskManager = NetworkTaskManager()) {
      decoder.dateDecodingStrategy = .millisecondsSince1970
    self.cache = cache
    self.decoder = decoder
    self.session = session
    self.taskManager = taskManager
  }
  
}

// MARK: - Requests

extension NetworkService {
    
    // wrapper request
    func request<T: Decodable>(_ endpoint: Endpoint,type: T.Type, completion: @escaping ResultCallback<T>) {
        request(endpoint: endpoint, type: type) { res in
            switch res {
            case .success(let data):
                completion(.success(data))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    func upload<T: Decodable>(endpoint: Endpoint, data: Data?, type: T.Type, completion: @escaping ResultCallback<T>) {
        guard let request = endpoint.urlRequest else {
          DispatchQueue.main.async { completion(.failure(NetworkError.invalidRequest)) }
          return
        }
        guard let data = data else {
            debugPrint("invalid data")
            return
        }
        // First, check cache
        // Otherwise, request from server
        let task = session.uploadTask(with: request, from: data) { [weak self] data, response, error in
            
          self?.taskManager.removeTask(forRequest: request)
          
          if let error = error as NSError? {
            DispatchQueue.main.async { completion(.failure(NetworkError.errorCode(error.code))) }
            return
          }
          
          guard let data = data else {
            DispatchQueue.main.async { completion(.failure(NetworkError.dataMissing)) }
            return
          }
            debugPrint("response: \(String(decoding: data, as: UTF8.self))")
          guard let strongSelf = self else { return }
          DispatchQueue.main.async { completion(strongSelf.decoded(T.self, data: data)) }
        }
        
        taskManager.add(task, forRequest: request)
        
        task.resume()
      }

    
    private func request<T: Decodable>(endpoint: Endpoint,type: T.Type, completion: @escaping ResultCallback<T>) {
        guard let request = endpoint.urlRequest else {
            DispatchQueue.main.async { completion(.failure(NetworkError.invalidRequest)) }
            return
        }
    // First, check cache
//        if let cachedData = cache.cachedResponse(for: request)?.data {
//            DispatchQueue.main.async { completion(self.decoded(T.self, data: cachedData)) }
//            return
//        }
    // Otherwise, request from server
    let task = session.dataTask(with: request) { [weak self] data, response, error in
        
      self?.taskManager.removeTask(forRequest: request)
      
      if let error = error as NSError? {
        DispatchQueue.main.async { completion(.failure(NetworkError.errorCode(error.code))) }
        return
      }
      
      guard let data = data else {
        DispatchQueue.main.async { completion(.failure(NetworkError.dataMissing)) }
        return
      }
        debugPrint("response: \(String(decoding: data, as: UTF8.self))")
      guard let strongSelf = self else { return }
////        if let err = strongSelf.checkStatus(data: data) {
//            DispatchQueue.main.async { completion(.failure(err)) }
//        } else {
            DispatchQueue.main.async { completion(strongSelf.decoded(T.self, data: data)) }
//        }
    }
    
    taskManager.add(task, forRequest: request)
    
    task.resume()
  }
  
  func cancelRequest(forEndpoint endpoint: Endpoint) {
    guard let request = endpoint.urlRequest else { return }
    taskManager.task(forRequest: request)?.cancel()
  }
}

// MARK: - Decoding

private extension NetworkService {
    
//    func checkStatus(data: Data) -> Error? {
//        let res = decoded(StatusResponse.self, data: data)
//        switch res {
//        case .success(let t):
//            if t.isSuccesfull {
//                return nil
//            }
//            return t.isSuccesfull ? nil : NetworkError.apiError(msg: t.errorDescription ?? t.message ?? "")
//        case .failure(let err):
//            return err
//        }
//    }
    
    func decoded<T: Decodable>(_ type: T.Type, data: Data) -> Result<T> {
        do {
            let object = try decoder.decode(T.self, from: data)
            return .success(object)
        } catch {
            return .failure(NetworkError.decodingFailed(msg: "\(error)"))
        }
    }
    
}


// MARK: - Network Error

enum NetworkError: Error {
    case dataMissing
    case decodingFailed(msg: String)
    case errorCode(Int)
    case invalidRequest
    case apiError(msg: String)
}
