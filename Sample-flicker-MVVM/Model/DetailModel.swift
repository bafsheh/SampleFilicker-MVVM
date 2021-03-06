//
//  DetailModel.swift
//  Sample-flicker-MVVM
//
//  Created by Babak Afsheh on 12/20/20.
//

import Foundation

struct DetailModel {
    let title: String?
    let description: String?
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

extension DetailModel {
    static func setupDetailModel(_ data: PhotosModel?) -> [DetailModel] {
        if let data = data {
            let body: [DetailModel] = [
                DetailModel(title: data.title ?? "", description: data.flickrImageURL() ?? ""),
                DetailModel(title: "Farm", description: "\(data.farm ?? 0)"),
                DetailModel(title: "ID", description: data.id ?? ""),
                DetailModel(title: "Owner", description: data.owner ?? ""),
                DetailModel(title: "Secret", description: data.secret ?? ""),
                DetailModel(title: "Server", description: data.server ?? "")
                ]
            return body
        } else {
            let body: [DetailModel] = []
            return body
        }
    }

}
