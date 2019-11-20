//
//  Pgp.swift
//  crypto_plugin
//
//  Created by Алекс on 20/11/2019.
//

import Foundation
import ObjectivePGP

class  Pgp {
    var privateKey:Key?=nil
    var publicKey:Key?=nil
    
    func setPrivateKey(_ data:Data) throws{
       let key = try ObjectivePGP.readKeys(from: data)[0]
       if(key.isSecret){
         self.privateKey=key
       }else{
           throw CryptionError("is not a private key")
       }
    }
    
    func setPublicKey(_ data:Data) throws{
        let key = try ObjectivePGP.readKeys(from: data)[0]
        if(key.isPublic){
            self.publicKey=key
        }else{
            throw CryptionError("is not a public key")
        }
    }
    
    func decrypt(_ message:Data,_ password:String) throws->Data {
       return try ObjectivePGP.decrypt(message, andVerifySignature: false, using: [self.privateKey!], passphraseForKey: { (_:Key?) -> String? in
            return password
        })
    }
    func encrypt(_ message:Data) throws->Data {
        return try ObjectivePGP.encrypt(message, addSignature: false, using: [self.publicKey!])
    }
    
    func getEmailFromKey(_ key:Data) throws->[String] {
        let key = try ObjectivePGP.readKeys(from: key)[0]
        if(key.isPublic){
            return key.publicKey!.users.map { (user:User) -> String in
                return user.userID
            }
        }else{
            throw CryptionError("is not a public key")
        }
    }
}
