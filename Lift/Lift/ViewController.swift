//
//  ViewController.swift
//  Lift
//
//  Created by Yang Li on 24/04/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
      liftUnit.addTarget(self, action: #selector(popoverChosenView), for: .touchUpInside)
      self.view.addSubview(liftUnit)
      liftX = liftX + distanceX
    }
  }
  
  func popoverChosenView() {
    let layout = UICollectionViewFlowLayout()
    let chosenView = UICollectionView(frame: CGRect(x: 520, y: 620, width: 300, height: 240), collectionViewLayout: layout)
    chosenView.delegate = self
    chosenView.dataSource = self
    chosenView.register(LiftButtonViewCell.self, forCellWithReuseIdentifier: "cell")
    chosenView.backgroundColor = UIColor.lightGray
    self.view.addSubview(chosenView)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LiftButtonViewCell
    cell.liftButton?.setTitle(convertNumber(number: indexPath.row + 1), for: .normal)
    return cell
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
