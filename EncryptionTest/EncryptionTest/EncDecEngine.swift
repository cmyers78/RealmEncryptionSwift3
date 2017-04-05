//
//  EncDecEngine.swift
//  EncryptionTest
//
//  Created by Christopher Myers on 4/5/17.
//  Copyright © 2017 Dragoman Developers, LLC. All rights reserved.
//

import Foundation
import RealmSwift

class EncDecEngine {
    init() {
        
    }
    
    func encrypt(with stringProperty : String) {
        let configuration = Realm.Configuration(encryptionKey: getKey())
        let realm = try! Realm(configuration: configuration)
        
        // Add an object
        try! realm.write {
            let obj = EncryptionObject()
            obj.stringProperty = stringProperty
            realm.add(obj)
        }
    }
    
    func decrypt() -> String {
            let configuration = Realm.Configuration(encryptionKey: getKey())
            let realm = try! Realm(configuration: configuration)
            if let stringProp = realm.objects(EncryptionObject.self).last?.stringProperty {
                return stringProp
            } else {
                return "Not able to decrypt"
            }
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
