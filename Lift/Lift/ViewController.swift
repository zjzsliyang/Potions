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
  var liftCurrentPosition: [CGFloat] = Array(repeating: 1290.0, count: 5)
  var liftCurrentButton: [[Bool]] = Array(repeating: Array(repeating: false, count: 20), count: 5)
  var liftCurrentDirection: [Int] = Array(repeating: 0, count: 5)  // 0 represents static, 1 represents Up Direction, -1 represents Down Direction
  var liftBeingSet: [Bool] = Array(repeating: false, count: 5)
  var liftDestinationDeque = Array(repeating: Deque<Int>(), count: 5)
  var liftRandomDestinationDeque = Array(repeating: Deque<Int>(), count: 5)
  var liftRequestQueue = Queue<Int>()
  
//  var sAWT: [Double] = Array(repeating: 0, count: 5)
//  var sART: [Double] = Array(repeating: 0, count: 5)
//  var sRPC: [Double] = Array(repeating: 0, count: 5)

  override func viewDidLoad() {
    super.viewDidLoad()
    initFloorSign()
    initUpDownButton()
    initLiftDisplay()
    initLift()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    let deviceModelName = UIDevice.current.modelName
    if deviceModelName != "iPad Pro 12.9" {
      let alertController = UIAlertController(title: "CAUTION", message: "This app can only run on the\n 12.9-inch iPad Pro", preferredStyle: .alert)
      let alertActionOk = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(alertActionOk)
      present(alertController, animated: true, completion: nil)
    }
    
    let timer = Timer(timeInterval: 0.1, repeats: true) { (timer) in
      for i in 0..<self.liftCount {
        self.updateLiftDisplay(currentFloor: self.getLiftCurrentFloor(liftIndex: i), liftIndex: i)
        self.updateCurrentDirection(liftIndex: i)
      }
    }
    RunLoop.current.add(timer, forMode: .commonModes)
    timer.fire()
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
        print("current lift: " + String(i))
        inLiftScan(liftIndex: i)
        liftBeingSet[i] = false
      }
    }
  }
  
  func inLiftScan(liftIndex: Int) {
    for i in 0..<floorCount {
      if liftCurrentButton[liftIndex][i] {
        liftDestinationDeque[liftIndex].enqueueFirst(i)
        liftCurrentButton[liftIndex][i] = false
      }
    }
    _ = liftDestinationDeque[liftIndex].sorted()
    liftAnimation(liftIndex: liftIndex)
  }
  
  func randomGenerateDestination(destinationTag: Int) -> Int {
    if destinationTag < 0 {
      return Int(arc4random() % UInt32(abs(destinationTag + 1))) + 1
    } else {
      return floorCount - Int(arc4random() % UInt32(floorCount - destinationTag))
    }
  }
  
  func updateCurrentDirection(liftIndex: Int) {
    if lift[liftIndex].layer.presentation()?.position == nil {
      liftCurrentDirection[liftIndex] = 0
      return
    }
    let currentPresentationY = lift[liftIndex].layer.presentation()?.frame.minY
    if currentPresentationY! < liftCurrentPosition[liftIndex] {
      liftCurrentDirection[liftIndex] = 1
    }
    if currentPresentationY! > liftCurrentPosition[liftIndex] {
      liftCurrentDirection[liftIndex] = -1
    }
    if currentPresentationY! == liftCurrentPosition[liftIndex] {
      liftCurrentDirection[liftIndex] = 0
    }
    liftCurrentPosition[liftIndex] = currentPresentationY!
    return
  }

  func naiveDispatch() {
    if liftRequestQueue.isEmpty {
      return
    }
    let currentRequest = liftRequestQueue.dequeue()
    print("currentRequest: " + String(currentRequest))
    if currentRequest < 0 {
      var closestLiftDistance = 20
      var closestLift = -1
      for i in 0..<liftCount {
        if liftCurrentDirection[i] <= 0 {
          if closestLiftDistance > abs(getLiftCurrentFloor(liftIndex: i) + currentRequest) {
            closestLift = i
            closestLiftDistance = abs(getLiftCurrentFloor(liftIndex: i) + currentRequest)
          }
        }
      }
      if closestLift != -1 {
        liftDestinationDeque[closestLift].enqueueFirst(-currentRequest - 1)
        _ = liftDestinationDeque[closestLift].sorted()
        liftRandomDestinationDeque[closestLift].enqueueFirst((randomGenerateDestination(destinationTag: currentRequest) - 1))
        return
      } else {
        liftRequestQueue.enqueue(currentRequest)
      }
    } else {
      var closestLiftDistance = 20
      var closestLift = -1
      for j in 0..<liftCount {
        if liftCurrentDirection[j] >= 0 {
          if closestLiftDistance > abs(getLiftCurrentFloor(liftIndex: j) - currentRequest) {
            closestLift = j
            closestLiftDistance = abs(getLiftCurrentFloor(liftIndex: j) - currentRequest)
          }
        }
      }
      if closestLift != -1 {
        liftDestinationDeque[closestLift].enqueueFirst(currentRequest - 1)
        _ = liftDestinationDeque[closestLift].sorted()
        liftRandomDestinationDeque[closestLift].enqueueFirst((randomGenerateDestination(destinationTag: currentRequest) - 1))
        return
      } else {
        liftRequestQueue.enqueue(currentRequest)
      }
    }
  }
  
  /*
  func SPODispatch() {
    let spaceMin: [Int] = Array(repeating: 0, count: liftRequestQueue.count)
    let spaceMax: [Int] = Array(repeating: 5, count: liftRequestQueue.count)
    let searchSpace = PSOSearchSpace(boundsMin: spaceMin, max: spaceMax)
    let optimizer = PSOStandardOptimizer2011(for: searchSpace, optimum: 0, fitness: { (positions: UnsafeMutablePointer<Double>?, dimensions: Int32) -> Double in
      // AWT: Average Waiting Time
      var liftTempDestinationDeque = Array(repeating: Deque<Int>(), count: 5)
      var fMax: [Int] = Array(repeating: 0, count: self.liftCount)
      var fMin: [Int] = Array(repeating: 0, count: self.liftCount)
      for i in 0..<self.liftRequestQueue.count {
        switch Int((positions?[i])!) {
        case 0:
          liftTempDestinationDeque[0].enqueueFirst(self.liftRequestQueue.dequeue())
          self.liftRequestQueue.enqueue(liftTempDestinationDeque[0].first!)
        case 1:
          liftTempDestinationDeque[1].enqueueFirst(self.liftRequestQueue.dequeue())
          self.liftRequestQueue.enqueue(liftTempDestinationDeque[1].first!)
        case 2:
          liftTempDestinationDeque[2].enqueueFirst(self.liftRequestQueue.dequeue())
          self.liftRequestQueue.enqueue(liftTempDestinationDeque[2].first!)
        case 3:
          liftTempDestinationDeque[3].enqueueFirst(self.liftRequestQueue.dequeue())
          self.liftRequestQueue.enqueue(liftTempDestinationDeque[3].first!)
        default:
          liftTempDestinationDeque[4].enqueueFirst(self.liftRequestQueue.dequeue())
          self.liftRequestQueue.enqueue(liftTempDestinationDeque[4].first!)
        }
      }
      // ART: Average Riding Time
      // RPC: Per Energy Consumption
      // Total
      var sFitnessFunc: Double = 0
      return sFitnessFunc
    }, before: nil, iteration: nil) { (optimizer: PSOStandardOptimizer2011?) in
      // to do
    }
    optimizer?.operation.start()
  }
  */
 
  func liftAnimation(liftIndex: Int) {
    if liftDestinationDeque[liftIndex].isEmpty {
      return
    }
    var destinationFloor: Int = 0
    if liftCurrentDirection[liftIndex] == 0 {
      let currentFloor = getLiftCurrentFloor(liftIndex: liftIndex)

      if abs(currentFloor - (liftDestinationDeque[liftIndex].first! + 1)) < abs(currentFloor - (liftDestinationDeque[liftIndex].last! + 1)) {
        destinationFloor = liftDestinationDeque[liftIndex].dequeueFirst() + 1
      } else {
        destinationFloor = liftDestinationDeque[liftIndex].dequeueLast() + 1
      }
    } else {
      if liftCurrentDirection[liftIndex] > 0 {
        destinationFloor = liftDestinationDeque[liftIndex].dequeueLast() + 1
      } else {
        destinationFloor = liftDestinationDeque[liftIndex].dequeueFirst() + 1
      }
    }
    print("destination floor: " + String(destinationFloor))
    let destinationDistance = CGFloat(destinationFloor - getLiftCurrentFloor(liftIndex: liftIndex)) * (distanceY)
    let destinationTime = liftVelocity * abs(Double(destinationFloor - getLiftCurrentFloor(liftIndex: liftIndex)))
    UIView.animate(withDuration: destinationTime, delay: liftDelay, options: .curveEaseInOut, animations: {
      self.lift[liftIndex].center.y = self.lift[liftIndex].center.y - destinationDistance
    }, completion: { (finished) in
      self.updateLiftDisplay(currentFloor: self.getLiftCurrentFloor(liftIndex: liftIndex), liftIndex: liftIndex)
      self.updateUpDownButton(destinationTag: (self.liftCurrentDirection[liftIndex] * destinationFloor), liftIndex: liftIndex)
      if !self.liftDestinationDeque[liftIndex].isEmpty {
        self.liftAnimation(liftIndex: liftIndex)
      }
    })
  }
  
  func updateUpDownButton(destinationTag: Int, liftIndex: Int) {
    print(destinationTag)
    if destinationTag == 0 {
      return
    }
    if destinationTag > 0 {
      if upDownButton[destinationTag - 1][0].isSelected {
        upDownButton[destinationTag - 1][0].isSelected = false
      }
    } else {
      if upDownButton[-destinationTag - 1][1].isSelected {
        upDownButton[-destinationTag - 1][1].isSelected = false
      }
    }
    if !liftRandomDestinationDeque[liftIndex].isEmpty {
      liftDestinationDeque[liftIndex].enqueueFirst(liftRandomDestinationDeque[liftIndex].dequeueFirst())
      upDownButton[abs(destinationTag) - 1][0].isSelected = false
      upDownButton[abs(destinationTag) - 1][1].isSelected = false
    }
  }
  
  func getLiftCurrentFloor(liftIndex: Int) -> Int {
    if lift[liftIndex].layer.presentation()?.position != nil {
      return (Int(floor((1290 - (lift[liftIndex].layer.presentation()!.frame.minY)) / distanceY)) + 1)
    } else {
      print("returning model layer position")
      return (Int(floor((1290 - (lift[liftIndex].layer.model().frame.minY)) / distanceY)) + 1)
    }
  }
  
  func updateLiftDisplay(currentFloor: Int, liftIndex: Int) {
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
    for i in 0..<floorCount {
      var upDownButtonUnit = [UIButton]()
      let upDownButtonUp = UIButton(frame: CGRect(x: 90, y: upDownButtonY, width: 25, height: 25))
      upDownButtonUp.setImage(UIImage(named: "up"), for: .normal)
      upDownButtonUp.setImage(UIImage(named: "up-active"), for: .selected)
      upDownButtonUp.tag = i + 1
      upDownButtonUp.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
      let upDownButtonDown = UIButton(frame: CGRect(x: 130, y: upDownButtonY, width: 25, height: 25))
      upDownButtonDown.setImage(UIImage(named: "down"), for: .normal)
      upDownButtonDown.setImage(UIImage(named: "down-active"), for: .selected)
      upDownButtonDown.tag = -(i + 1)
      upDownButtonDown.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
      upDownButtonUnit.append(upDownButtonUp)
      upDownButtonUnit.append(upDownButtonDown)
      self.view.addSubview(upDownButtonUp)
      self.view.addSubview(upDownButtonDown)
      upDownButton.append(upDownButtonUnit)
      upDownButtonY = upDownButtonY - distanceY
    }
    upDownButton[0][1].isEnabled = false
    upDownButton[19][0].isEnabled = false
  }
  
  func buttonTapped(sender: UIButton) {
    sender.isSelected = !sender.isSelected
    if sender.isSelected {
      liftRequestQueue.enqueue(sender.tag)
      naiveDispatch()
      for i in 0..<liftCount {
        liftAnimation(liftIndex: i)
      }
    }
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

public extension UIDevice {
  var modelName: String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    switch identifier {
      case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9"
      case "i386", "x86_64":                          return "Simulator"
      default:                                        return identifier
    }
  }
}
