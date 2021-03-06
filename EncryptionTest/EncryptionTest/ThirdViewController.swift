//
//  ThirdViewController.swift
//  EncryptionTest
//
//  Created by Christopher Myers on 4/7/17.
//  Copyright © 2017 Dragoman Developers, LLC. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var thirdVCLabel: UILabel!
    let encDec3 = EncDecEngine()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoreleasepool {
            if let dec3 = encDec3.decrypt() {
                thirdVCLabel.text = dec3
            }
        }
        
        autoreleasepool {
            let allEncObjects = encDec3.decryptedList()
            print(allEncObjects)
            let dir = getDocumentsDirectory()
            print(dir)
        }
        
        // Do any additional setup after loading the view.
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

}
