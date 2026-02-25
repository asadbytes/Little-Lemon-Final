/*
 * File: MainScreen.swift
 * Project: LittleLemonApp
 * Author: asadbyte
 
 */

import SwiftUI
import CoreData

struct MainScreen: View
{
  @Environment(\.managedObjectContext) private var viewContext
  
  var body: some View
{
    NavigationStack {
      VStack {
        Header()
        Menu()
      }
    }
  }
}

struct MainScreen_Previews: PreviewProvider
{
  static var previews: some View
{
    MainScreen().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
  }
}
