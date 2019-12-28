//
//  PgpApi.swift
//  Runner
//
//  Created by Alexander Orlov on 26.12.2019.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
import DMSOpenPGP
import BouncyCastle_ObjC

class PgpApi{
    let pgp = Pgp()
    var privateKey : String?=nil
    var publicKey : BCOpenpgpPGPPublicKeyRing?=nil
    
    func setPrivateKey(_ data:String?) throws{
        privateKey=data;
    }
    
    func setPublicKey(_ data:String?) throws{
        if data==nil  {
            publicKey=nil
            return
        }
        publicKey=try DMSPGPKeyRing.publicKeyRing(from: data!)
    }
    
    func decryptBytes(_ data:Data,_ password:String)throws->Data{
        let byteArray = IOSByteArray(nsData: data)!
        let input = JavaIoByteArrayInputStream(byteArray: byteArray)
        let output = JavaIoByteArrayOutputStream()
        try  decrypt(input,output,password)
        return output.toByteArray().toNSData()
    }
    
    func decryptFile(_ inputFile:String,_ outputFile:String,_ password:String)throws{
        let input = JavaIoFileInputStream(  javaIoFile: JavaIoFile(nsString: inputFile))
        let output = JavaIoFileOutputStream(  javaIoFile: JavaIoFile(nsString: outputFile))
        try decrypt(input,output,password)
    }
    
    func encryptBytes(_ data:Data)throws->Data{
        let byteArray = IOSByteArray(nsData: data)!
        let input = JavaIoByteArrayInputStream(byteArray: byteArray)
        let input2 = JavaIoByteArrayInputStream(byteArray: byteArray)
        let output = JavaIoByteArrayOutputStream()
        try  encrypt(input,input2,output)
        return output.toByteArray().toNSData()
    }
    
    func encryptFile(_ inputFile:String,_ outputFile:String)throws{
        let input = JavaIoFileInputStream(  javaIoFile: JavaIoFile(nsString: inputFile))
        let input2 = JavaIoFileInputStream(  javaIoFile: JavaIoFile(nsString: inputFile))
        let output = JavaIoFileOutputStream(  javaIoFile: JavaIoFile(nsString: outputFile))
        try encrypt(input,input2,output)
    }
    
    func encrypt(_ input:JavaIoInputStream,_ input2:JavaIoInputStream,_ output:JavaIoOutputStream) throws {
        assert(publicKey != nil)
        try pgp.encrypt(input,input2,output,publicKey!)
    }
    func decrypt(_ input:JavaIoInputStream,_ output:JavaIoOutputStream,_ password:String) throws {
        assert(privateKey != nil)
        try pgp.decrypt(input,output,privateKey!,password)
    }
    func getKeyDescription(_ key:Data) throws->KeyInfo{
        return try pgp.getKeyDescription(key)
    }
    func createKeys(_ length:Int32,_ email:String,_ password:String) throws->[String]{
        return try pgp.createKeys(length,email,password)
    }
    
    func setTempFile(_ file:String){
        
    }
}
