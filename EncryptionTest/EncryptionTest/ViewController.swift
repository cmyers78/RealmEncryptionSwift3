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
    
    @IBOutlet weak var decryptLabel: UILabel!
    
    let encDec = EncDecEngine()
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Testing encryption")
        encDec.encrypt(with: "Franks and Beans")
        
        print("Item encrypted")
        autoreleasepool {
            if let dec = encDec.decrypt() {
                decryptLabel?.text = (dec)
            }
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    
    @IBAction func buttonTapped(_ sender: UIButton) {
        autoreleasepool {
            encDec.encrypt(with: "I hate rude behvaior in a man. Won't tolerate it.")
        }
        
        performSegue(withIdentifier: "secondVC", sender: nil)
    }
}

