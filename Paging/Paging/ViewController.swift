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

class ViewController: UIViewController, UITextFieldDelegate, ChartViewDelegate {

  @IBOutlet weak var dashBoard: UIView!
  @IBOutlet weak var conclusionBoard: UIView!
  @IBOutlet weak var missNo: UILabel!
  @IBOutlet weak var missRate: UILabel!
  
  @IBOutlet weak var virtualView: UIView!
  @IBOutlet weak var pageTableView: UIView!
  @IBOutlet weak var physicalView: UIView!
  @IBOutlet weak var diskView: UIView!
  
  var virtualUnit = [UIView]()
  var pageTableUnit = [UIView]()
  var physicalUnit = [UIView]()
  
  var algorithm: Int = 1 // 1 fot LRU, 0 for FIFO

  
  override func viewDidLoad() {
    super.viewDidLoad()

    initForBoard()
    initForVirtual()
    initForPageTable()
    initForPhysical()
    initForDisk()
    
  }
  
  func initForBoard() {
    let memoryTextField = MadokaTextField(frame: CGRect(x: 720, y: 73, width: 170, height: 40))
    memoryTextField.placeholder = "Physical Memory"
    memoryTextField.placeholderFontScale = 1
    memoryTextField.borderColor = .lightGray
    memoryTextField.placeholderColor = .lightGray
    let orderNoTextField = MadokaTextField(frame: CGRect(x: 720, y: 130, width: 170, height: 40))
    orderNoTextField.placeholder = "No. of Order"
    orderNoTextField.placeholderFontScale = 1
    orderNoTextField.borderColor = .lightGray
    orderNoTextField.placeholderColor = .lightGray
    dashBoard.addSubview(memoryTextField)
    dashBoard.addSubview(orderNoTextField)
  }
  
  func initForVirtual() {
    for i in 0..<32 {
      let virtualIndex = UILabel(frame: CGRect(x: 20, y: 5 + i * 26, width: 15, height: 26))
      virtualIndex.text = "\(i)"
      virtualIndex.font = UIFont(name: "HelveticaNeue-UltraLight", size: 12)
      virtualView.addSubview(virtualIndex)
      for j in 0..<10 {
        let virtualCell = UIView(frame: CGRect(x: 40 + j * 26, y: 5 + i * 26, width: 26, height: 26))
        virtualCell.layer.borderColor = UIColor.lightGray.cgColor
        virtualCell.layer.borderWidth = 0.5
        virtualView.addSubview(virtualCell)
        virtualUnit.append(virtualCell)
      }
    }
  }
  
  func initForPageTable() {
    for i in 0..<32 {
      let pageTableIndex = UILabel(frame: CGRect(x: 20, y: 5 + i * 26, width: 15, height: 26))
      pageTableIndex.text = "\(i)"
      pageTableIndex.font = UIFont(name: "HelveticaNeue-UltraLight", size: 12)
      pageTableView.addSubview(pageTableIndex)
      for j in 0..<2 {
        let pageTableCell = UIView(frame: CGRect(x: 40 + j * 32, y: 5 + i * 26, width: 32, height: 26))
        pageTableCell.layer.borderColor = UIColor.lightGray.cgColor
        pageTableCell.layer.borderWidth = 0.5
        pageTableView.addSubview(pageTableCell)
        pageTableUnit.append(pageTableCell)
      }
    }
  }
  
  func initForPhysical() {
    for i in 0..<4 {
      let physicalIndex = UILabel(frame: CGRect(x: 20, y: 5 + i * 64, width: 15, height: 64))
      physicalIndex.text = "\(i)"
      physicalIndex.font = UIFont(name: "HelveticaNeue-UltraLight", size: 12)
      physicalView.addSubview(physicalIndex)
      let physicalCell = UIView(frame: CGRect(x: 40, y: 5 + i * 64, width: 180, height: 64))
      physicalCell.layer.borderColor = UIColor.lightGray.cgColor
      physicalCell.layer.borderWidth = 0.5
      physicalView.addSubview(physicalCell)
      physicalUnit.append(physicalCell)
    }
  }
  
  func initForDisk() {
    // init for b+ - tree.
  }

  @IBAction func algorithmChosen(_ sender: UISwitch) {
    if sender.isOn {
      algorithm = 1 // LRU Algorithm
    } else {
      algorithm = 0 // FIFO Algorithm
    }
  }
  
  @IBAction func step(_ sender: UIButton) {
    
  }
  
  @IBAction func stepForward(_ sender: UIButton) {
    
  }
  
}
