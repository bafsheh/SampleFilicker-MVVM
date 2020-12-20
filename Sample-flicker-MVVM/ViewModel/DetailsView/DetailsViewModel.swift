//
//  DetailsViewModel.swift
//  Sample-flicker-MVVM
//
//  Created by Babak Afsheh on 12/20/20.
//

import Foundation

class  DetailsViewModel {
    // MARK: - Input
    weak var dataSource: DetailsDataSource<DetailModel>?

    init(dataSource: DetailsDataSource<DetailModel>?) {
        self.dataSource = dataSource
    }

    func fetchDataSource(photoData: PhotosModel?,
                         completion: ((Result<Bool, ErrorResult>) -> Void)? = nil) {
        self.dataSource?.data.value = DetailModel.setupDetailModel(photoData)
        completion?(Result.success(true))
    }
}
