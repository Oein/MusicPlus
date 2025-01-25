//
//  WRouter_Stack.swift
//  weblikerouter
//
//  Created by oein on 1/26/25.
//

import Foundation

struct WRouter_Stack<T> {
    private var stack: [T] = []
    
    public var count: Int {
        return stack.count
    }
    
    public var isEmpty: Bool {
        return stack.isEmpty
    }
    
    public mutating func push(_ element: T) {
        stack.append(element)
    }
    
    public mutating func pop() -> T? {
        return isEmpty ? nil : stack.popLast()
    }
    
    public mutating func clear() {
        stack.removeAll()
    }
}
