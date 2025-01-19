//
//  PathManager.swift
//  musicplus
//
//  Created by oein on 1/19/25.
//

import Foundation


struct Stack<T> {
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

struct IURL {
    var path: String;
    var qparm: String;
}

@Observable class PathManager {
    static let shared = PathManager()
    private init() { }
    
    var path = "::blank";
    var queryparm = "";
    
    var viewhistory = Stack<IURL>();
    var backward_history = Stack<IURL>();
    
    func goto(path: String, qparm: String?) {
        self.viewhistory.push(IURL(path: self.path, qparm: self.queryparm));
        self.backward_history.clear();
        
        self.path = path;
        self.queryparm = qparm ?? "";
    }
    
    func set_path(path: String, qparm: String?) {
        self.viewhistory.clear();
        self.backward_history.clear();
        
        self.path = path;
        self.queryparm = qparm ?? "";
    }
    
    func replace(path: String, qparm: String?) {
        self.path = path;
        self.queryparm = qparm ?? "";
    }
    
    func backward() {
        if viewhistory.isEmpty {
            return;
        }
        
        let lastPath = self.viewhistory.pop()!;
        self.backward_history.push(IURL(path: self.path, qparm: self.queryparm));
        self.path = lastPath.path;
        self.queryparm = lastPath.qparm;
    }
    
    func canForward() -> Bool {
        return !self.backward_history.isEmpty;
    }
    
    func forward() {
        if self.backward_history.isEmpty {
            return;
        }
        
        let futurePath = self.backward_history.pop()!;
        self.backward_history.push(IURL(path: self.path, qparm: self.queryparm));
        
        self.path = futurePath.path;
        self.queryparm = futurePath.qparm;
    }
}
