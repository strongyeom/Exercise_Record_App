//
//  CoreDataManager.swift
//  ExerciseRecordApp
//
//  Created by 염성필 on 2023/03/19.
//

import CoreData

final class CoreDataManager: ObservableObject {

  static let shared = CoreDataManager()

  let container = NSPersistentContainer(name: "Exercise")

  private init() {
    container.loadPersistentStores { description, error in
      if let error {
        print("코어 데이터 로딩 에러 -> \(error.localizedDescription)")
      }
    }
  }
}
