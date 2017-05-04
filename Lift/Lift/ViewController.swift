//
//  ViewController.swift
//  Lift
//
//  Created by Yang Li on 24/04/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import UIKit
import PSOLib
import Buckets

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
  
  let floorCount = 20
  let liftCount = 5
  let distanceX: CGFloat = 170
  let distanceY: CGFloat = 60
  
  let liftVelocity: Double = 0.3
  let liftDelay: Double = 0.5
  
  var upDownButton = [[UIButton]]()
  var liftDisplay = [UILabel]()
  var lift = [UIView]()
  var liftCurrentButton: [[Bool]] = Array(repeating: Array(repeating: false, count: 20), count: 5)
  var liftCurrentDirection: [Int] = Array(repeating: 0, count: 5)  // 0 represents static, 1 represents Up Direction, -1 represents Down Direction
  var liftBeingSet: [Bool] = Array(repeating: false, count: 5)
  var liftDestinationQueue = Array(repeating: Queue<Int>(), count: 5)

  override func viewDidLoad() {
    super.viewDidLoad()
    initFloorSign()
    initUpDownButton()
    initLiftDisplay()
    initLift()
  }
  
  func initLift() {
    var liftX: CGFloat = 250
    for liftIndex in 0..<liftCount {
      let liftUnit = UIView(frame: CGRect(x: liftX, y: 1290, width: 33.6, height: 45.7))
      let liftUnitButton = UIButton(frame: CGRect(x: 0, y: 0, width: liftUnit.frame.width, height: liftUnit.frame.height))
      liftUnit.addSubview(liftUnitButton)
      liftUnitButton.setImage(UIImage(named: "lift"), for: .normal)
      liftUnitButton.tag = liftIndex
      liftUnitButton.addTarget(self, action: #selector(popoverChosenView(sender:)), for: .touchUpInside)
      self.view.addSubview(liftUnit)
      lift.append(liftUnit)
      liftX = liftX + distanceX
    }
  }
  
  func popoverChosenView(sender: UIButton) {
    let layout = UICollectionViewFlowLayout()
    let chosenView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 300, height: 240), collectionViewLayout: layout)
    chosenView.delegate = self
    chosenView.dataSource = self
    chosenView.tag = sender.tag
    liftBeingSet[sender.tag] = true
    chosenView.register(LiftButtonViewCell.self, forCellWithReuseIdentifier: "cell")
    chosenView.backgroundColor = UIColor.lightGray
    let popoverViewController = UIViewController()
    popoverViewController.modalPresentationStyle = .popover
    popoverViewController.popoverPresentationController?.sourceView = sender
    popoverViewController.popoverPresentationController?.sourceRect = sender.bounds
    popoverViewController.preferredContentSize = chosenView.bounds.size
    popoverViewController.popoverPresentationController?.delegate = self
    popoverViewController.view.addSubview(chosenView)
    self.present(popoverViewController, animated: true, completion: nil)
  }
  
  func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    for i in 0..<liftCount {
      if liftBeingSet[i] {
        // how to start animation
        print("current lift: " + String(i))
        liftAnimation(liftIndex: i)
        liftBeingSet[i] = false
      }
    }
  }
  
  func scanDispatch(liftIndex: Int) {
    for i in 0..<floorCount {
      if liftCurrentButton[liftIndex][i] {
        liftDestinationQueue[liftIndex].enqueue(i)
        liftCurrentButton[liftIndex][i] = false
      }
    }
  }
  
  func liftAnimation(liftIndex: Int) {
    // add animation
    scanDispatch(liftIndex: liftIndex)
    let destinationFloor = liftDestinationQueue[liftIndex].dequeue() + 1
    print("destinationFloor: " + String(destinationFloor))
    let destinationDistance = CGFloat(destinationFloor - getLiftCurrentFloor(liftIndex: liftIndex)) * (distanceY)
    let destinationTime = liftVelocity * Double(destinationFloor - getLiftCurrentFloor(liftIndex: liftIndex))
    UIView.animate(withDuration: destinationTime, delay: liftDelay, options: [], animations: {
      print(destinationDistance)
      self.lift[liftIndex].center.y -= destinationDistance
    }, completion: { (finished) in
      self.updateLiftDisplay(currentFloor: self.getLiftCurrentFloor(liftIndex: liftIndex), liftIndex: liftIndex)
      while !self.liftDestinationQueue[liftIndex].isEmpty {
        self.liftAnimation(liftIndex: liftIndex)
      }
    })
  }
  
  func getLiftCurrentFloor(liftIndex: Int) -> Int {
    return (Int(floor((1290 - lift[liftIndex].frame.minY) / distanceY)) + 1)
  }
  
  func updateLiftDisplay(currentFloor: Int, liftIndex: Int) {
    // how to update liftDisplay
    liftDisplay[liftIndex].text = String(currentFloor)
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LiftButtonViewCell
    cell.liftButton?.setTitle(convertNumber(number: indexPath.row + 1), for: .normal)
    cell.liftButton?.setTitleColor(UIColor.blue, for: .selected)
    cell.liftButton?.tag = collectionView.tag
    cell.liftButton?.addTarget(self, action: #selector(liftButtonTapped(sender:)), for: .touchUpInside)
    return cell
  }
  
  func liftButtonTapped(sender: UIButton) {
    sender.isSelected = !sender.isSelected
    let currentLift = sender.tag
    let currentFloorButton = convertLetter(letter: sender.currentTitle!)
    liftCurrentButton[currentLift][currentFloorButton - 1] = !liftCurrentButton[currentLift][currentFloorButton - 1]
  }
  
  func convertLetter(letter: String) -> Int {
    let asciiLetter = Character(letter).asciiValue
    if asciiLetter < 65 {
      return asciiLetter - 48
    } else {
      return asciiLetter - 55
    }
  }
  
  func convertNumber(number: Int) -> String {
    if number < 10 {
      return String(number)
    } else {
      return String(describing: UnicodeScalar(number - 10 + 65)!)
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return floorCount
  }

  func initFloorSign() {
    var floorY: CGFloat = 1300
    for floorNum in 0..<floorCount {
      let floorNumView = UIImageView(image: UIImage(named: String(floorNum + 1)))
      floorNumView.frame = CGRect(x: 36, y: floorY, width: 30, height: 30)
      floorNumView.contentMode = .scaleAspectFill
      self.view.addSubview(floorNumView)
      floorY = floorY - distanceY
    }
  }
  
  func initLiftDisplay() {
    var liftDisplayX: CGFloat = 220
    for _ in 0..<liftCount {
      let liftDisplayUnit = UILabel(frame: CGRect(x: liftDisplayX, y: 100, width: 50, height: 50))
      liftDisplayUnit.text = String(1)
      liftDisplayUnit.font = UIFont(name: "Digital-7", size: 50)
      liftDisplayUnit.textAlignment = .right
      self.view.addSubview(liftDisplayUnit)
      liftDisplay.append(liftDisplayUnit)
      liftDisplayX = liftDisplayX + distanceX
    }
  }
  
  func initUpDownButton() {
    var upDownButtonY: CGFloat = 1305
    for _ in 0..<floorCount {
      var upDownButtonUnit = [UIButton]()
      let upDownButtonUp = UIButton(frame: CGRect(x: 90, y: upDownButtonY, width: 25, height: 25))
      upDownButtonUp.setImage(UIImage(named: "up"), for: .normal)
      upDownButtonUp.setImage(UIImage(named: "up-active"), for: .selected)
      upDownButtonUp.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
      let upDownButtonDown = UIButton(frame: CGRect(x: 130, y: upDownButtonY, width: 25, height: 25))
      upDownButtonDown.setImage(UIImage(named: "down"), for: .normal)
      upDownButtonDown.setImage(UIImage(named: "down-active"), for: .selected)
      upDownButtonDown.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
      upDownButtonUnit.append(upDownButtonUp)
      upDownButtonUnit.append(upDownButtonDown)
      self.view.addSubview(upDownButtonUp)
      self.view.addSubview(upDownButtonDown)
      upDownButton.append(upDownButtonUnit)
      upDownButtonY = upDownButtonY - distanceY
    }
  }
  
  func buttonTapped(sender: UIButton) {
    sender.isSelected = !sender.isSelected
  }
}

class LiftButtonViewCell: UICollectionViewCell {
  var liftButton: UIButton?
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func initView() {
    liftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    liftButton?.titleLabel?.font = UIFont(name: "Elevator Buttons", size: 50)
    self.addSubview(liftButton!)
  }
}

extension Character {
  var asciiValue: Int {
    get {
      let unicodeString = String(self).unicodeScalars
      return Int(unicodeString[unicodeString.startIndex].value)
    }
  }
}
