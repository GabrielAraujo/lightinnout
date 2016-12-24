//
//  Result.swift
//  lightinnout
//
//  Created by Gabriel Araujo on 21/12/16.
//  Copyright © 2016 Innuv. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(Error)
}
