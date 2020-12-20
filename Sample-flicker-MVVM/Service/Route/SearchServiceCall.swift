//
//  SearchServiceCall.swift
//  Sample-flicker-MVVM
//
//  Created by Babak Afsheh on 12/20/20.
//

import Foundation
import Alamofire

protocol SearchServiceCallProtocol: class {
    func fetchPhotos(_ searchTerm: String , pageNumber:String, completion: @escaping ((Result<SearchResultsModel, ErrorResult>) -> Void))
}

final class SearchServiceCall: SearchServiceCallProtocol {
    
    
    static let shared = SearchServiceCall()
    let endpoint = APIConstants.baseURLString

    

    func fetchPhotos(_ searchTerm: String,pageNumber:String, completion: @escaping ((Result<SearchResultsModel, ErrorResult>) -> Void)) {

        var parameters: [String: String] = [
            "method":APIConstants.APIMethods_PhotosSearch,
            "api_key":APIConstants.apiKeyValue,
            "nojsoncallback":"1",
            "format":"json",
            "safe_search":"1",
            "text":searchTerm,
            "per_page":APIConstants.limit,
            "page":pageNumber
        ]

        if searchTerm.isEmpty {
            guard let location = LocationService.sharedInstance.lastLocation else {
                return
            }
            
            parameters["lat"] = "\(location.coordinate.latitude)"
            parameters["lon"] = "\(location.coordinate.longitude)"
            parameters["text"] = "Nearby"
        }
        
    
        
        AF.request(endpoint,method: .get,parameters: parameters)
           .validate(statusCode: 200..<300)
           .responseJSON(completionHandler: { (response) in
               switch response.result {
               case .success:
                   guard response.error == nil else {
                    completion(.failure(.custom(string: response.error?.localizedDescription ?? "")))
                       return
                   }
                   
                do {
                    if   let data:Data = response.data {
                        let resultModel = try JSONDecoder().decode(SearchResultsModel.self, from: data)
                        completion(.success(resultModel))
                       }
                }catch {
                    completion(.failure(.custom(string: "jason pars error")))
                }
                   break
               case .failure:
                   if let status = response.response?.statusCode {
                    completion(.failure(.custom(string: "\(status) - problem happend")))
                   }
                   break
               }
           })
    }
}
