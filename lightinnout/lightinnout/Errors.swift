//
//  Errors.swift
//  lightinnout
//
//  Created by Gabriel Araujo on 22/12/16.
//  Copyright © 2016 Innuv. All rights reserved.
//

import Foundation

enum Errors : Error {
    case missingAddress
    case defineAddress
    
    
    static func getMessage(error:Error) -> String {
        if error is Errors {
            switch error as! Errors {
            case .missingAddress:
                return "Delize o dedo para baixo e defina o endereço da lampada!"
            case .defineAddress:
                return "Defina o endereço da lampada!"
            }
        }else{
            return error.localizedDescription
        }
    }
}
