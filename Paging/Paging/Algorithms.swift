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
var instrFIFOQueue = Queue<Int>()
var instrLRUQueue = Queue<Int>()
var instrOPTQueue = Queue<Int>()
var currentInstrQueue = Queue<Int>()

/* Satisfy the requirement of "50% of the instructions are executed sequentially,
   25% are evenly distributed in the pre-address section,
   and 25% are evenly distributed in the post-address section." */
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

func pagingFIFO(instr: Int) -> Int {
  if instrFIFOQueue.isEmpty {
    print("instrFIFOQueue is empty.")
    return -1
  }
  let frameIndex: Int = instrFIFOQueue.dequeue()
  let iter = instrFIFOQueue.makeIterator()
  var tag = 0 // 1 for already have the instr in the queue
  while let currentInstr = iter.next() {
    if currentInstr == instr {
      tag = 1
    }
  }
  if tag == 0 {
    instrFIFOQueue.enqueue(instr)
  }
  return frameIndex
}

func pagingLRU(instr: Int) -> Int {
  if instrLRUQueue.isEmpty {
    print("instrLRUQueue is empty")
    return -1
  }
  let frameIndex: Int = instrLRUQueue.dequeue()
  let tempLRUQueue = instrLRUQueue
  instrLRUQueue.removeAll()
  let iter = tempLRUQueue.makeIterator()
  while let currentInstr = iter.next() {
    if currentInstr != instr {
      instrLRUQueue.enqueue(currentInstr)
    }
  }
  instrLRUQueue.enqueue(instr)
  return frameIndex
}

func pagingOPT(instr: Int) -> Int {
  if instrOPTQueue.isEmpty {
    print("instrOPTQueue is empty")
    return -1
  }
  let frameIndex: Int = -1
  let iter = instrustionQueue.makeIterator()
  var distinctCount = 0
  while let currentInstr = iter.next()  {
    
  }
  return frameIndex
}
