//
//  ExerciseRecordAppApp.swift
//  ExerciseRecordApp
//
//  Created by 염성필 on 2023/03/19.
//

import SwiftUI

@main
struct SwiftUI_Firebase_Example1App: App {
    @StateObject private var coreDataManager = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
        }
    }
}
