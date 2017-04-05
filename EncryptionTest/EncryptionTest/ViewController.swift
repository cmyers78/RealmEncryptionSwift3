//
//  ViewController.swift
//  EncryptionTest
//
//  Created by Christopher Myers on 10/31/16.
//  Copyright © 2016 Dragoman Developers, LLC. All rights reserved.
//

import UIKit
import RealmSwift
import Security

    // Model Definition
    class EncryptionObject : Object {
        dynamic var stringProperty = ""
    }

class ViewController: UIViewController {
    
    let encDec = EncDecEngine()
    
    let textView = UITextView(frame: UIScreen.main.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Testing encryption")
        encDec.encrypt(with: "In the valley of Death rode the 600")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(textView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        print("Item encrypted")
        // Use an autorelease pool to close the Realm at the end of the block, so
        // that we can try to reopen it with different keys
        let dec = encDec.decrypt()
        
        textView.text = dec
    }
}

