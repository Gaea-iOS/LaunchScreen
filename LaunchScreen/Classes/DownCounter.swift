//
//  DownCounter.swift
//  Pods
//
//  Created by 王小涛 on 2017/6/26.
//
//

import Foundation

class DownCounter {
    
    private let step: Int
    private var left: Int = 60
    
    private(set) var isCounting: Bool = false
    
    private weak var target: AnyObject?
    private var timer: Timer?
    
    var down: ((Int) -> Void)? = nil
    var done: (() -> Void)? = nil
    
    init(step: Int = 1, target: AnyObject?) {
        self.step = step
        self.target = target
    }
    
    func start(count: Int) {
        
        self.stop()
        
        guard let target = target else {
            return
        }
        
        isCounting = true
        left = count
        
        timer = Timer.every(interval: TimeInterval(step), target: target) { [weak self] timer in
            
            guard let `self` = self else {return}
            
            guard self.target != nil else {
                self.stop()
                return
            }
            
            self.left -= 1
            
            self.down?(self.left)
            
            if self.left <= 0 {
                self.done?()
                self.stop()
            }
        }
    }
    
    private func stop() {
        isCounting = false
        timer?.invalidate()
    }
}
