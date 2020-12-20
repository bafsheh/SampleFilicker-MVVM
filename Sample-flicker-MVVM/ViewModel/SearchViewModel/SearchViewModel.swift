//
//  SearchViewModel.swift
//  Sample-flicker-MVVM
//
//  Created by Babak Afsheh on 12/20/20.
//

import Foundation


class  SearchViewModel {
    // MARK: - Input
    weak var dataSource: GenericDataSource<PhotosModel>?
    private var pageNumber  = 1
    private var searchTermString:String?

    // MARK: - Output
    weak var service: SearchServiceCallProtocol?
    var onErrorHandling: ((ErrorResult?) -> Void)?
    var selectedData: PhotosModel?

    init(service: SearchServiceCallProtocol? = SearchServiceCall.shared, dataSource: GenericDataSource<PhotosModel>?) {
        self.dataSource = dataSource
        self.service = service
    }

    func fetchServiceCall(_ searchTerm: String,
                          completion: ((Result<Bool, ErrorResult>) -> Void)? = nil) {

        guard let service = service else {
            onErrorHandling?(ErrorResult.custom(string: "Missing service"))
            return
        }
        self.pageNumber = 1
        service.fetchPhotos(searchTerm, pageNumber: pageNumber) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let converter) :
                    if let results = converter.photos?.photo {
                        
                        self.dataSource?.data.value = results
                        completion?(Result.success(false))
                    } else {
                        self.onErrorHandling?(ErrorResult.parser(string: "unable to parse"))
                        completion?(Result.failure(ErrorResult.parser(string: "unable to parse")))
                    }
                    self.searchTermString = searchTerm

                    break
                case .failure(let error) :
                    print("Parser error \(error)")
                    self.onErrorHandling?(error)
                    completion?(Result.failure(error))
                    break
                }
            }
        }
    }

    func fetchNextPage(completion: ((Result<Bool, ErrorResult>) -> Void)? = nil) {
        guard let searchTermString = searchTermString else {
            return
        }
        self.pageNumber += 1
        service?.fetchPhotos(searchTermString, pageNumber: pageNumber) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let converter) :
                    if let results = converter.photos?.photo,results.count > 0 {
                        self.dataSource?.data.value.append(contentsOf: results)
                        completion?(Result.success(false))
                    }else {
                        completion?(Result.success(true))
                    }
                    
                    
                    break
                case .failure(let error) :
                    print("Parser error \(error)")
                    self.onErrorHandling?(error)
                    completion?(Result.failure(error))
                    break
                }
            }
        }
    }
    func presentProfile(_ indexPath: IndexPath,
                        completion: ((PhotosModel) -> Void)? = nil) {
        if let data = self.dataSource?.data.value[indexPath.row] {
            self.selectedData = data
            completion!(data)
        }
    }
}
