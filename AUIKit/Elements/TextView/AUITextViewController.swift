//
//  AUITextViewController.swift
//  Level
//
//  Created by Ihor Myroniuk on 11/6/18.
//  Copyright © 2018 Brander. All rights reserved.
//

import Foundation

public protocol AUITextViewController: AUIScrollViewController {
 
  var textView: UITextView? { get set }
  
}
