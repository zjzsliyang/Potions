//
//  LinkedList.swift
//  Paging
//
//  Created by Yang Li on 24/05/2017.
//  Copyright © 2017 Yang Li. All rights reserved.
//
//  Reference: https://hugotunius.se/2016/07/17/implementing-a-linked-list-in-swift.html

import Foundation

public class Node<T: Equatable> {
  typealias NodeType = Node<T>
  
  public let value: T
  var next: NodeType? = nil
  var previous: NodeType? = nil
  
  public init(value: T) {
    self.value = value
  }
}

extension Node: CustomStringConvertible {
  public var description: String {
    get {
      return "Node(\(value))"
    }
  }
}

public final class LinkedList<T: Equatable> {
  public typealias NodeType = Node<T>
  
  fileprivate var start: NodeType? {
    didSet {
      if end == nil {
        end = start
      }
    }
  }
  
  fileprivate var end: NodeType? {
    didSet {
      if start == nil {
        start = end
      }
    }
  }
  
  public fileprivate(set) var count: Int = 0
  
  public var isEmpty: Bool {
    get {
      return count == 0
    }
  }

  public init() {
    
  }

  public init<S: Sequence>(_ elements: S) where S.Iterator.Element == T {
    for element in elements {
      append(value: element)
    }
  }
}

extension LinkedList {
  public func append(value: T) {
    let previousEnd = end
    end = NodeType(value: value)
    
    end?.previous = previousEnd
    previousEnd?.next = end
    
    count += 1
  }
}

extension LinkedList {
  fileprivate func iterate(block: (_ node: NodeType, _ index: Int) throws -> NodeType?) rethrows -> NodeType? {
    var node = start
    var index = 0
    
    while node != nil {
      let result = try block(node!, index)
      if result != nil {
        return result
      }
      index += 1
      node = node?.next
    }
    
    return nil
  }
}

extension LinkedList {
  public func nodeAt(index: Int) -> NodeType {
    precondition(index >= 0 && index < count, "Index \(index) out of bounds")
    
    let result = iterate {
      if $1 == index {
        return $0
      }
      return nil
    }
    return result!
  }
  
  public func valueAt(index: Int) -> T {
    let node = nodeAt(index: index)
    return node.value
  }
}

extension LinkedList {
  public func remove(node: NodeType) {
    let nextNode = node.next
    let previousNode = node.previous
    
    if node === start && node === end {
      start = nil
      end = nil
    } else if node === start {
      start = node.next
    } else if node === end {
      end = node.previous
    } else {
      previousNode?.next = nextNode
      nextNode?.previous = previousNode
    }
    
    count -= 1
    assert(
      (end != nil && start != nil && count >= 1) || (end == nil && start == nil && count == 0),
      "Internal invariant not upheld at the end of remove"
    )
  }

  public func remove(atIndex index: Int) {
    precondition(index >= 0 && index < count, "Index \(index) out of bounds")
    
    let result = iterate {
      if $1 == index {
        return $0
      }
      return nil
    }
    
    remove(node: result!)
  }
}

public struct LinkedListIterator<T: Equatable>: IteratorProtocol {
  public typealias Element = Node<T>
  fileprivate var currentNode: Element?
  
  fileprivate init(startNode: Element?) {
    currentNode = startNode
  }
  
  public mutating func next() -> LinkedListIterator.Element? {
    let node = currentNode
    currentNode = currentNode?.next
    return node
  }
}

extension LinkedList: Sequence {
  public typealias Iterator = LinkedListIterator<T>
  
  public func makeIterator() -> LinkedList.Iterator {
    return LinkedListIterator(startNode: start)
  }
}

extension LinkedList {
  func copy() -> LinkedList<T> {
    let newList = LinkedList<T>()
    
    for element in self {
      newList.append(value: element.value)
    }
    
    return newList
  }
}
