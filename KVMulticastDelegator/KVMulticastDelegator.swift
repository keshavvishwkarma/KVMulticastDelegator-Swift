//
//  KVMulticastDelegator.swift
//  https://github.com/keshavvishwkarma/KVMulticastDelegator-Swift.git
//
//  Distributed under the MIT License.
//
//  Created by Keshav on 7/26/16.
//  Copyright © 2016 Keshav. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

open class KVMulticastDelegator<T>: NSObject
{
    private final class WeakWrapper:Equatable {
        weak var value: AnyObject?
        init(value: AnyObject) {
            self.value = value
        }
        
        static func ==(lhs: WeakWrapper, rhs: WeakWrapper) -> Bool {
            return lhs.value === rhs.value
        }
    }
    
    private var delegates: [WeakWrapper] = []
    
    open func addDelegate(_ delegate: T) {
        let weak = WeakWrapper(value: delegate as AnyObject)
        if !delegates.contains(weak) {
            delegates.append(weak)
        }
    }
    
    open func removeDelegate(_ delegate: T) {
        let weak = WeakWrapper(value: delegate as AnyObject)
        if let index = delegates.index(of: weak) {
            delegates.remove(at: index)
        }
    }
    
    open func invoke(_ invocation: @escaping (T) -> ()) {
        delegates = delegates.filter { $0.value != nil }
        
        delegates.forEach {
            if let delegate = $0.value as? T {
                invocation(delegate)
            }
        }
        
    }
    
    public static func += (lhs: KVMulticastDelegator<T>, rhs: T) {
        lhs.addDelegate(rhs)
    }
    
    public static func -= (lhs: KVMulticastDelegator<T>, rhs: T) {
        lhs.removeDelegate(rhs)
    }
    
}
