//
//  ImageLoader.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 18/04/24.

import UIKit

final class ImageLoader {
  
  // Shared instance
  static let shared = ImageLoader()
  
  private let session: URLSession
  private let cache: ImageLoaderCache
  private let taskManager: ImageLoaderTaskManager
  
  init(session: URLSession = URLSession.shared,
       cache: ImageLoaderCache = ImageLoaderCache(),
       taskManager: ImageLoaderTaskManager = ImageLoaderTaskManager()) {
    self.session = session
    self.cache = cache
    self.taskManager = taskManager
  }
  
}

// MARK: - Requests

extension ImageLoader {
  
  func request(_ imagePath: String, completion: @escaping ResultCallback<UIImage>) {
    guard let url = URL(string: imagePath) else {
      completion(.failure(ImageLoaderError.invalidURL))
      return
    }
    
    let request = URLRequest(url: url)
    
    // First, check cache
    if let cachedImage = cache.image(forKey: imagePath) {
      completion(.success(cachedImage))
      
    // If task already exists, update its callback
    } else if taskManager.task(forKey: imagePath) != nil {
      taskManager.update(callback: completion, forTaskAtKey: imagePath)
      
    // Otherwise, create new task
    } else {
      let task = session.dataTask(with: request) { [weak self] data, _, error in

        if let error = error as NSError? {
          DispatchQueue.main.async { completion(.failure(ImageLoaderError.errorCode(error.code))) }
          self?.taskManager.removeTask(forKey: imagePath)
          return
        }
        
        guard let data = data, let image = UIImage(data: data) else {
          DispatchQueue.main.async { completion(.failure(ImageLoaderError.dataMissing)) }
          self?.taskManager.removeTask(forKey: imagePath)
          return
        }
        
        // Complete
        DispatchQueue.main.async {
          self?.taskManager.task(forKey: imagePath)?.callbacks.forEach ({
            $0(.success(image))
          })
          self?.taskManager.removeTask(forKey: imagePath)
        }
        self?.cache.set(image, forKey: imagePath)
      }
      
      taskManager.add(ImageLoaderTask(sessionTask: task, callbacks: [completion]), forKey: imagePath)
      
      task.resume()
    }
  }
    
  func cancelRequest(_ imagePath: String) {
    taskManager.cancelTask(forKey: imagePath)
  }
  
}

// MARK: - Image Loader Error

enum ImageLoaderError: Error {
  case dataMissing
  case errorCode(Int)
  case invalidURL
}
