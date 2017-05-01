//
//  ViewController.swift
//  Lift
//
//  Created by Yang Li on 24/04/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  let floorCount = 20
  let liftCount = 5
  let distanceX: CGFloat = 170
  let distanceY: CGFloat = 60
  var upDownButton = [[UIButton]]()
  var liftDisplay = [UILabel]()
  var lift = [UIButton]()

  override func viewDidLoad() {
    super.viewDidLoad()
    initFloorSign()
    initUpDownButton()
    initLiftDisplay()
    initLift()
  }
  
  func initLift() {
    var liftX: CGFloat = 250
    for _ in 1...liftCount {
      let liftUnit = UIButton(frame: CGRect(x: liftX, y: 1290, width: 33.6, height: 45.7))
      liftUnit.setImage(UIImage(named: "lift"), for: .normal)
      self.view.addSubview(liftUnit)
      liftX = liftX + distanceX
    }
  }

  func initFloorSign() {
    var floorY: CGFloat = 1300
    for floorNum in 1...floorCount {
      let floorNumView = UIImageView(image: UIImage(named: String(floorNum)))
      floorNumView.frame = CGRect(x: 36, y: floorY, width: 30, height: 30)
      floorNumView.contentMode = .scaleAspectFill
      self.view.addSubview(floorNumView)
      floorY = floorY - distanceY
    }
  }
  
  func initLiftDisplay() {
    var liftDisplayX: CGFloat = 220
    for _ in 1...liftCount {
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
    for _ in 1...floorCount {
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

