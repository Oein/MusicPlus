//
//  WRouter_PathManager.swift
//  weblikerouter
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
    
    private var viewhistory = WRouter_Stack<WRouter_URL>();
    private var backward_history = WRouter_Stack<WRouter_URL>();
    
    func goto(path: String, qparm: String?) {
        self.viewhistory.push(WRouter_URL(path: self.path, qparm: self.queryparm));
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
        self.backward_history.push(WRouter_URL(path: self.path, qparm: self.queryparm));
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
        self.backward_history.push(WRouter_URL(path: self.path, qparm: self.queryparm));
        
        self.path = futurePath.path;
        self.queryparm = futurePath.qparm;
    }
}
