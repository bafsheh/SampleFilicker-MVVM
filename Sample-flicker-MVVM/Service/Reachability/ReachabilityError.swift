//
//  ReachabilityError.swift
//  SampleFlicker-MVVm
//
//  Created by Babak Afsheh on 12/18/20.
//

import Foundation

public enum ReachabilityError: Error {
    case FailedToCreateWithAddress(sockaddr_in)
    case FailedToCreateWithHostname(String)
    case UnableToSetCallback
    case UnableToSetDispatchQueue
}

