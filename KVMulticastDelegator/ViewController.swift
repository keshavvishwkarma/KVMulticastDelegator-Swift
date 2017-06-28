//
//  ViewController.swift
//  KVMulticastDelegator
//
//  Created by Keshav on 6/29/17.
//  Copyright © 2017 Keshav. All rights reserved.
//

import UIKit

protocol Printable: class {
    func print(sender: Any)
}

extension ViewController : Printable {
    func print(sender: Any){
        Swift.print(sender)
    }
}

class ViewController: UIViewController
{
    var delegate = KVMulticastDelegator<Printable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate += self
        
        delegate.addDelegate(self)
        
        delegate.invoke { obj in
            obj.print(sender: obj)
        }
        
    }
    
}
