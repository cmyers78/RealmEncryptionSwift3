//
//  SecondViewController.swift
//  EncryptionTest
//
//  Created by Christopher Myers on 4/5/17.
//  Copyright © 2017 Dragoman Developers, LLC. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var decrypted2Label: UILabel!
    
    let encDec2 = EncDecEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoreleasepool {
            print("Item decrypted")
            if let dec2 = encDec2.decrypt() {
                decrypted2Label.text = dec2
            }
            
        }
        
        autoreleasepool {
            let allEncObjects = encDec2.decryptedList()
            print(allEncObjects)
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func buttonTwoTapped(_ sender: UIButton) {
        
        encDec2.addMoreToEncrypted(with: "Minecraft with Lily")
        
        performSegue(withIdentifier: "thirdVC", sender: nil)
    }

}
