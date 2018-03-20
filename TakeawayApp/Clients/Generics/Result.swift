//
//  Result.swift
//  TakeawayApp
//
//  Created by Andrey on 3/19/18.
//

import Foundation

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}
