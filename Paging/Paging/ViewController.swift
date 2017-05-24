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
import NVActivityIndicatorView

class ViewController: UIViewController, UITextFieldDelegate, ChartViewDelegate {

  @IBOutlet weak var dashBoard: UIView!
  @IBOutlet weak var conclusionBoard: UIView!
  @IBOutlet weak var missNo: UILabel!
  @IBOutlet weak var missRate: UILabel!
  
  @IBOutlet weak var virtualView: UIView!
  @IBOutlet weak var pageTableView: UIView!
  @IBOutlet weak var physicalView: UIView!
  @IBOutlet weak var diskView: UIView!
  
  @IBOutlet weak var diskAnimationView: NVActivityIndicatorView!
  
  var virtualUnit = [UIView]()
  var pageTableUnit = [UIView]()
  var physicalUnit = [UIView]()
  var pageTableFrameLabel = [UILabel]()
  var pageTableTagLabel = [UILabel]()
  var physicalLabel = [UILabel]()
  
  var algorithm: Int = 1 // 1 fot LRU, 0 for FIFO
  var instrCount = [Int](repeatElement(0, count: 320))
  
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
        if j == 0 {
          let frameLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 32, height: 26))
          frameLabel.textAlignment = .center
          frameLabel.font = UIFont(name: "Menlo", size: 15)
          pageTableCell.addSubview(frameLabel)
          pageTableFrameLabel.append(frameLabel)
        } else {
          let tagLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 32, height: 26))
          tagLabel.textAlignment = .center
          tagLabel.font = UIFont(name: "Menlo", size: 15)
          tagLabel.text = "i"
          pageTableCell.addSubview(tagLabel)
          pageTableTagLabel.append(tagLabel)
        }
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
      let physicalLabelUnit = UILabel(frame: CGRect(x: 0, y: 0, width: 180, height: 64))
      physicalLabelUnit.textAlignment = .center
      physicalLabel.append(physicalLabelUnit)
      physicalCell.addSubview(physicalLabelUnit)
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
    if instrustionQueue.isEmpty {
      generateInstruction()
      instrCount = [Int](repeatElement(0, count: 320))
      for i in 0..<320 {
        updateVirtualCell(index: i)
      }
    }
    let instr = instrustionQueue.dequeue()
    instrCount[instr] = instrCount[instr] + 1
    updateVirtualCell(index: instr)
  }
  
  func updateVirtualCell(index: Int) {
    switch instrCount[index] {
    case 0:
      virtualUnit[index].backgroundColor = UIColor.clear
    case 1:
      virtualUnit[index].backgroundColor = UIColor(colorLiteralRed: 158/255, green: 208/255, blue: 255/255, alpha: 1)
    case 2:
      virtualUnit[index].backgroundColor = UIColor(colorLiteralRed: 141/255, green: 197/255, blue: 251/255, alpha: 1)
    case 3:
      virtualUnit[index].backgroundColor = UIColor(colorLiteralRed: 119/255, green: 189/255, blue: 255/255, alpha: 1)
    case 4:
      virtualUnit[index].backgroundColor = UIColor(colorLiteralRed: 98/255, green: 179/255, blue: 255/255, alpha: 1)
    default:
      virtualUnit[index].backgroundColor = UIColor(colorLiteralRed: 81/255, green: 170/255, blue: 255/255, alpha: 1)
    }
  }
  
  func updatePageTableCell(oldIndex: Int, newIndex: Int, newFrame: Int) {
    pageTableTagLabel[oldIndex].text = "i"
    pageTableFrameLabel[newIndex].text = String(newFrame)
    pageTableTagLabel[newIndex].text = "v"
  }
  
  func updatePhysicalCell(index: Int, pageNo: Int) {
    physicalLabel[index].text = "Page: " + String(pageNo)
  }
  
  func virtual2PageTable(vIndex: Int, ptIndex: Int) {
    
  }
  
  func pageTable2Physical(ptIndex: Int, pIndex: Int) {
    
  }
  
  func physical2Disk(pIndex: Int) {
    diskAnimationView.type = .ballGridPulse
    diskAnimationView.startAnimating()
    
//    diskAnimationView.stopAnimating()
  }
  
  
  
  @IBAction func stepForward(_ sender: UIButton) {
    if instrustionQueue.isEmpty {
      generateInstruction()
      instrCount = [Int](repeatElement(0, count: 320))
      for i in 0..<320 {
        updateVirtualCell(index: i)
      }
    }
    while !instrustionQueue.isEmpty {
      let instr = instrustionQueue.dequeue()
      instrCount[instr] = instrCount[instr] + 1
      updateVirtualCell(index: instr)
    }
  }
  
}
