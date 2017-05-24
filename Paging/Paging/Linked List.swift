//
//  Linked List.swift
//  Paging
//
//  Created by Yang Li on 24/05/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//

import Foundation

class LLNode<T> {
  var key: T?
  var next: LLNode?
  var previous: LLNode?
}

public class LinkList<T: Equatable> {
  private var head: LLNode<T> = LLNode<T>()
  
  func addLink(key: T) {
    if head.key == nil {
      head.key = key
      return
    }
    var current: LLNode? = head
    while current != nil {
      if current?.next == nil {
        let childToUse: LLNode = LLNode<T>()
        childToUse.key = key
        childToUse.previous = current
        current!.next = childToUse
        break
      }
      current = current?.next
    }
  }
  
  func removeLinkAtIndex(index: Int) {
    var current: LLNode<T>? = head
    var trailer: LLNode<T>?
    var listIndex: Int = 0
    
    if index == 0 {
      current = current?.next
      head = current!
      return
    }
    
    while current != nil {
      if listIndex == index {
        trailer!.next = current?.next
        current = nil
        break
      }
      
      trailer = current
      current = current?.next
      listIndex += 1
    }
  }
  
  var count: Int {
    if head.key == nil {
      return 0
    } else {
      var current: LLNode = head
      var x: Int = 1
      while current.next != nil {
        current = current.next!
        x += 1
      }
      return x
    }
  }
}
