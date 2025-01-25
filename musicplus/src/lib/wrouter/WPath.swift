//
//  WPath 2.swift
//  musicplus
//
//  Created by oein on 1/26/25.
//


import Foundation
import SwiftUI

@Observable class WPath {
    static let shared = WPath()
    private init() { }
    
    public var path = "::blank";
    public var queryparm = "";
    public var background: Color? = Color.backgroundMain;
    
    private var history = WRouter_Stack<WRouter_URL>();
    private var forward_stack = WRouter_Stack<WRouter_URL>();
    
    func goto(path: String, qparm: String?) {
        self.history.push(WRouter_URL(path: self.path, qparm: self.queryparm));
        self.forward_stack.clear()
        
        self.path = path;
        self.queryparm = qparm ?? "";
    }
    
    func set_path(path: String, qparm: String?) {
        self.history.clear();
        self.forward_stack.clear()
        
        self.path = path;
        self.queryparm = qparm ?? "";
    }
    
    func replace(path: String, qparm: String?) {
        self.path = path;
        self.queryparm = qparm ?? "";
    }
    
    func backward() {
        if history.isEmpty {
            return;
        }
        
        let lastPath = self.history.pop()!;
        self.forward_stack.push(WRouter_URL(path: self.path, qparm: self.queryparm));
        self.path = lastPath.path;
        self.queryparm = lastPath.qparm;
    }
    
    func forward() {
        if self.forward_stack.isEmpty {
            return;
        }
        
        let futurePath = self.forward_stack.pop()!;
        self.history.push(WRouter_URL(path: self.path, qparm: self.queryparm));
        
        self.path = futurePath.path;
        self.queryparm = futurePath.qparm;
    }
}
