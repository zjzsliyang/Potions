//
//  Algorithms.swift
//  Paging
//
//  Created by Yang Li on 23/05/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import Foundation
import Buckets

var instrustionQueue = Queue<Int>()


// Satisfy the requirement of "50% of the instructions are executed sequentially, 25% are evenly distributed in the pre-address section, and 25% are evenly distributed in the post-address section."
func generateInstruction() {
  if instrustionQueue.count < 320 {
    let random = arc4random() % 320
    instrustionQueue.enqueue(Int(random))
    instrustionQueue.enqueue(Int((random + 1) % 320))
    if random != 0 {
      let preRandom = arc4random() % random
      instrustionQueue.enqueue(Int(preRandom))
      instrustionQueue.enqueue(Int((preRandom + 1) % 320))
    }
    if (320 - random) != 0 {
      let postRandom = arc4random() % (320 - random) + random
      instrustionQueue.enqueue(Int(postRandom))
      instrustionQueue.enqueue(Int(postRandom + 1) % 320)
    }
    generateInstruction()
  }
}
