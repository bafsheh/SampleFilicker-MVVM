//
//  Result.swift
//  SampleFlicker-MVVm
//
//  Created by Babak Afsheh on 12/18/20.
//

import Foundation

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

