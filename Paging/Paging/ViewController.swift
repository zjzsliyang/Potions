//
//  ViewController.swift
//  Paging
//
//  Created by Yang Li on 21/05/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import UIKit
import Charts
import TextFieldEffects

class ViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var dashBoard: UIView!
  @IBOutlet weak var missNo: UILabel!
  @IBOutlet weak var missRate: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let memoryTextField = MadokaTextField(frame: CGRect(x: 250, y: 53, width: 170, height: 40))
    memoryTextField.placeholder = "Physical Memory"
    memoryTextField.placeholderFontScale = 1
    memoryTextField.borderColor = .lightGray
    memoryTextField.placeholderColor = .lightGray
    let orderNoTextField = MadokaTextField(frame: CGRect(x: 250, y: 160, width: 170, height: 40))
    orderNoTextField.placeholder = "No. of Order"
    orderNoTextField.placeholderFontScale = 1
    orderNoTextField.borderColor = .lightGray
    orderNoTextField.placeholderColor = .lightGray
    dashBoard.addSubview(memoryTextField)
    dashBoard.addSubview(orderNoTextField)
  }

  @IBAction func algorithmChosen(_ sender: UISwitch) {
    
  }
}
