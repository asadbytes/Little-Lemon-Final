/*
 * File: Menu.swift
 * Project: LittleLemonApp
 * Author: asadbyte
 
 */

import SwiftUI
import CoreData

struct Menu: View
{
  
  @Environment(\.managedObjectContext) private var viewContext
  
  @State var startersIsEnabled = true
  @State var mainsIsEnabled = true
  @State var dessertsIsEnabled = true
  @State var drinksIsEnabled = true
  
  @State var searchText = ""
  
  @State var loaded = false
  
  @State var isKeyboardVisible = false
  
  init()
{
    UITextField.appearance().clearButtonMode = .whileEditing
  }
  
  var body: some View
{
    NavigationView {
      VStack {
        VStack {
          if !isKeyboardVisible
{
            withAnimation()
{
              Hero()
                .frame(maxHeight: 180)
            }
          }
          TextField("Search menu", text: $searchText)
            .textFieldStyle(.roundedBorder)
        }
        .padding()
        .background(Color.primaryColor1)
        
        Text("ORDER FOR DELIVERY!")
          .font(.sectionTitle())
          .foregroundColor(.highlightColor2)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.top)
          .padding(.leading)
        ScrollView(.horizontal, showsIndicators: false)
{
          HStack(spacing: 20)
{
            Toggle("Starters", isOn: $startersIsEnabled)
            Toggle("Mains", isOn: $mainsIsEnabled)
            Toggle("Desserts", isOn: $dessertsIsEnabled)
            Toggle("Drinks", isOn: $drinksIsEnabled)
          }
          .toggleStyle(MyToggleStyle())
          .padding(.horizontal)
        }
        FetchedObjects(predicate: buildPredicate(),
                               sortDescriptors: buildSortDescriptors())
{
          (dishes: [Dish]) in
          List(dishes)
{ dish in
            NavigationLink(destination: DetailItem(dish: dish))
{
              FoodItem(dish: dish)
            }
          }
          .listStyle(.plain)
        }
      }
    }
    .onAppear {
      if !loaded
{
        MenuList.getMenuData(viewContext: viewContext)
        loaded = true
      }
    }
    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification))
{ notification in
      withAnimation {
        self.isKeyboardVisible = true
      }
      
    }
    .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
{ notification in
      withAnimation {
        self.isKeyboardVisible = false
      }
    }
  }
  
  func buildSortDescriptors() -> [NSSortDescriptor] {
    return [NSSortDescriptor(key: "title",
                                  ascending: true,
                                  selector:
                  #selector(NSString.localizedStandardCompare))]
  }
  
  func buildPredicate() -> NSCompoundPredicate {
    var subpredicates: [NSPredicate] = []
    
    if searchText.count > 0 {
      subpredicates.append(NSPredicate(format: "title CONTAINS[cd] %@", searchText))
    }
    
    if !startersIsEnabled {
      subpredicates.append(NSPredicate(format: "category != %@", "starters"))
    }
    
    if !mainsIsEnabled {
      subpredicates.append(NSPredicate(format: "category != %@", "mains"))
    }
    
    if !dessertsIsEnabled {
      subpredicates.append(NSPredicate(format: "category != %@", "desserts"))
    }
    
    if !drinksIsEnabled {
      subpredicates.append(NSPredicate(format: "category != %@", "drinks"))
    }
    
    return NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
  }
}

struct Menu_Previews: PreviewProvider
{
  static var previews: some View
{
    Menu().environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
  }
}
