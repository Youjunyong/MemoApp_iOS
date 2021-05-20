//
//  UIViewController+Alert.swift
//  MemoApp
//
//  Created by 유준용 on 2021/05/15.
//

import UIKit


extension UIViewController {
  func alert(title: String = "Alert!!", message : String){
    let alert = UIAlertController(title : title, message : message, preferredStyle : .alert)
    
    let okAction = UIAlertAction(title : "확인", style : .default, handler : nil)
    alert.addAction(okAction)
    present(alert, animated : true)
  }
    
    
}

