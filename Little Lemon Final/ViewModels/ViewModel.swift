/*
 * File: ViewModel.swift
 * Project: LittleLemonApp
 * Author: asadbyte
 
 */

import Foundation
import Combine

public let kFirstName = "first name key"
public let kLastName = "last name key"
public let kEmail = "e-mail key"
public let kIsLoggedIn = "kIsLoggedIn"
public let kPhoneNumber = "phone number key"

public let kOrderStatuses = "order statuses key"
public let kPasswordChanges = "password changes key"
public let kSpecialOffers = "special offers key"
public let kNewsletter = "news letter key"

class ViewModel: ObservableObject
{
  
  @Published var firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
  @Published var lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
  @Published var email = UserDefaults.standard.string(forKey: kEmail) ?? ""
  @Published var phoneNumber = UserDefaults.standard.string(forKey: kPhoneNumber) ?? ""
  
  @Published var orderStatuses = UserDefaults.standard.bool(forKey: kOrderStatuses)
  @Published var passwordChanges = UserDefaults.standard.bool(forKey: kPasswordChanges)
  @Published var specialOffers = UserDefaults.standard.bool(forKey: kSpecialOffers)
  @Published var newsletter = UserDefaults.standard.bool(forKey: kNewsletter)
  
  
  @Published var errorMessageShow = false
  @Published var errorMessage = ""
  
  @Published var searchText = ""
  
  func validateUserInput(firstName: String, lastName: String, email: String, phoneNumber: String) -> Bool {
    let inputsValid = firstName.count > 0 && lastName.count > 0 && email.count > 0
    guard inputsValid else
{
      self.errorMessage = "All fields are required"
      self.errorMessageShow = true
      return false
    }
    
    let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
    
    guard emailPredicate.evaluate(with: email) else
{
      self.errorMessage = "Invalid email address"
      self.errorMessageShow = true
      return false
    }
    
    let isPhoneValid: Bool
    if phoneNumber.count == 0 {
      isPhoneValid = true
    } else if phoneNumber.first == "+" {
      let rest = phoneNumber.dropFirst()
      var allDigits = true
      for char in rest {
        if !char.isNumber { allDigits = false; break }
      }
      isPhoneValid = allDigits
    } else {
      isPhoneValid = false
    }
    
    guard isPhoneValid else
{
      self.errorMessage = "Invalid phone number format."
      self.errorMessageShow = true
      return false
    }
    
    self.errorMessageShow = false
    self.errorMessage = ""
    return true
  }
}
