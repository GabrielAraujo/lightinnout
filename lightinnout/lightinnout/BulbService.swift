//
//  BulbService.swift
//  lightinnout
//
//  Created by Gabriel Araujo on 21/12/16.
//  Copyright © 2016 Innuv. All rights reserved.
//

import Foundation
import Alamofire

class BulbService {
    
    class func correctAddress(_ address:String) -> String {
        var addr = address
        if address.contains("http://") {
            addr = addr.replacingOccurrences(of: "http://", with: "")
        }
        if address.contains("https://") {
            addr = addr.replacingOccurrences(of: "https://", with: "")
        }
        return addr
    }
    
    class func setOn(completion: @escaping (Result<Bool>) -> Void){
        if let address = UD.string(forKey: kAddress) {
            let url = "http://\(self.correctAddress(address))/on"
            
            Alamofire.request(url).responseString { response in
                switch response.result {
                case .success( _):
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }else{
            completion(.failure(Errors.missingAddress))
        }
    }
    
    class func setOff(completion: @escaping (Result<Bool>) -> Void){
        if let address = UD.string(forKey: kAddress) {
            let url = "http://\(self.correctAddress(address))/off"
            
            Alamofire.request(url).responseString { response in
                switch response.result {
                case .success( _):
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }else{
            completion(.failure(Errors.missingAddress))
        }
    }
}
