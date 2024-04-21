//
//  ImageLoaderTaskManager.swift
//  TalkShopApp
//
//  Created by Nirman Kalia on 18/04/24.

import UIKit

// MARK: - Task

struct ImageLoaderTask {
  let sessionTask: URLSessionTask
  var callbacks: [ResultCallback<UIImage>]
}

// MARK: - Task Manager

final class ImageLoaderTaskManager {
  
  private var tasks = [String: ImageLoaderTask]()
  
  var currentTasksCount: Int {
    return tasks.count
  }
  
  func task(forKey key: String) -> ImageLoaderTask? {
    return tasks[key]
  }
  
}

// MARK: - Task Manager CRUD

extension ImageLoaderTaskManager {
  
  func add(_ task: ImageLoaderTask, forKey key: String) {
    tasks[key] = task
  }
  
  func removeTask(forKey key: String) {
    tasks[key] = nil
  }
  
  func update(callback: @escaping ResultCallback<UIImage>, forTaskAtKey key: String) {
    guard let currentTask = task(forKey: key) else { return }
    tasks[key] = ImageLoaderTask(sessionTask: currentTask.sessionTask, callbacks: currentTask.callbacks + [callback])
  }
  
  func cancelTask(forKey key: String) {
    guard let currentTask = task(forKey: key) else { return }
    currentTask.sessionTask.cancel()
    removeTask(forKey: key)
  }
  
}
