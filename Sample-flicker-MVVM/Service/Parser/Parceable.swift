//
//  Parceable.swift
//  SampleFlicker-MVVm
//
//  Created by Babak Afsheh on 12/18/20.
//

import Foundation

protocol Parceable {
    static func parseObject(data: Data) -> Result<Self, ErrorResult>
}

final class ParserHelper {

    static func parse<T: Parceable>(data: Data, completion: (Result<[T], ErrorResult>) -> Void) {
        switch T.parseObject(data: data) {
        case .failure(let error):
            completion(.failure(error))
            break
        case .success(let newModel):
            completion(.success([newModel]))
            break
        }
    }

    static func parse<T: Parceable>(data: Data, completion: (Result<T, ErrorResult>) -> Void) {
        switch T.parseObject(data: data) {
        case .failure(let error):
            completion(.failure(error))
            break
        case .success(let newModel):
            completion(.success(newModel))
            break
        }
    }
}
