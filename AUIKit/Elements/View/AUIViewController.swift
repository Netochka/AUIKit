//
//  AUIElementViewController.swift
//  Level
//
//  Created by Ihor Myroniuk on 11/2/18.
//  Copyright © 2018 Brander. All rights reserved.
//

import Foundation

public protocol AUIViewController: class {
  
  // MARK: View
  
  var view: UIView? { get set }
  
  // MARK: State
  
  var isUserInteractionEnabled: Bool { get set }
  
  // MARK: First Responder
  
  func becomeFirstResponder()
  
  func resignFirstResponder()
  
}
