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
var instrOPTLinkedList = LinkedList<Int>()
var currentInstrLinkedList = LinkedList<Int>()

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
    print("instrLRUQueue is empty.")
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
  if instrOPTLinkedList.isEmpty {
    print("instrOPTLinkedList is empty.")
    return -1
  }
  let frameIndex: Int = -1
  let iter = instrustionQueue.makeIterator()
  while let currentInstr = iter.next()  {
    var iterLL = instrOPTLinkedList.makeIterator()
    while let tempInstr = iterLL.next() {
      if tempInstr.value == currentInstr {
        // delete the node
      }
    }
    if instrOPTLinkedList.count < 7 {
      // add the node
    }
    break;
  }
  var iterLL = instrOPTLinkedList.makeIterator()
  while let futureInstr = iterLL.next() {
    var iterCurrentLL = currentInstrLinkedList.makeIterator()
    while let currentInstr = iterCurrentLL.next() {
      if futureInstr.value == currentInstr.value {
        if currentInstrLinkedList.count == 1 {
          // delete the node
          // frame = this node value
        }
        // delete the node
      }
    }
  }
  // frame = current node value
  return frameIndex
}
