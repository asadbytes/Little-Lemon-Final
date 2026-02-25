//
//  Little_Lemon_FinalApp.swift
//  Little Lemon Final
//
//  Created by MacBook Pro on 25/02/2026.
//  Author: asadbyte

import SwiftUI
import CoreData

@main
struct Little_Lemon_FinalApp: App {
    var body: some Scene {
        WindowGroup {
          Onboarding().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
