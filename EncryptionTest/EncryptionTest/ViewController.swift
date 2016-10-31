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
    
    let textView = UITextView(frame: UIScreen.main.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(textView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Use an autorelease pool to close the Realm at the end of the block, so
        // that we can try to reopen it with different keys
        autoreleasepool {
            let configuration = Realm.Configuration(encryptionKey: getKey())
            let realm = try! Realm(configuration: configuration)
            
            // Add an object
            try! realm.write {
                let obj = EncryptionObject()
                obj.stringProperty = "abcd"
                realm.add(obj)
            }
        }
        
        // Opening with wrong key fails since it decrypts to the wrong thing
        autoreleasepool {
            do {
                let configuration = Realm.Configuration(encryptionKey: "1234567890123456789012345678901234567890123456789012345678901234".data(using: String.Encoding.utf8, allowLossyConversion: false))
                _ = try Realm(configuration: configuration)
            } catch {
                log(text: "Open with wrong key: \(error)")
            }
        }
        
        // Opening wihout supplying a key at all fails
        autoreleasepool {
            do {
                _ = try Realm()
            } catch {
                log(text: "Open with no key: \(error)")
            }
        }
        
        // Reopening with the correct key works and can read the data
        autoreleasepool {
            let configuration = Realm.Configuration(encryptionKey: getKey())
            let realm = try! Realm(configuration: configuration)
            if let stringProp = realm.objects(EncryptionObject.self).first?.stringProperty {
                log(text: "Saved object: \(stringProp)")
            }
        }
        
        
    }

    func log(text : String) {
        textView.text = textView.text + text + "\n\n"
        
    }
    
    func getKey() -> Data {
        let keychainIdentifier = "io.Realm.EncryptionExampleKey"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        
        // First check in the keychain for an existing key
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]
        
        // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
        // See also: http://stackoverflow.com/questions/24145838/querying-ios-keychain-using-swift/27721328#27721328
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return (dataTypeRef as! NSData) as Data
        }
        
        
        // No pre-existing key from this application, so generate a new one
        var keyData = Data(count: 64)
        let result = keyData.withUnsafeMutableBytes { mutableBytes in SecRandomCopyBytes(kSecRandomDefault, keyData.count, mutableBytes)}

        assert(result == 0, "Failed to get random bytes")
        

        
        // Store the key in the keychain
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: keyData as AnyObject
        ]
        
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        
        return keyData
        

        
        
    }
    
    


}

