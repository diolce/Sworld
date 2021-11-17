//
//  ImageManager.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 17/11/21.
//

import UIKit

class ImageManager {
    var cache:ImageCache
    static let shared = ImageManager()
    let baseURLimages = "image.tmdb.org"
     
    init(cache:ImageCache = ImageCache()) {
        self.cache = cache
    }
    
    func downloadImage(path:String, completion: @escaping (Result<UIImage, ErrorModel>)-> Void) {
        let imageRequest = ImageRequest(baseUrl: self.baseURLimages, path: path)
        self.getData(from: (imageRequest.urlRequest?.url)!) { data, response, error in
            guard let data = data, error == nil else { completion(.failure(ErrorModel(status: "", timeStamp: "", code: (error! as NSError).code, message: "")))
                return
            }
            completion(.success(UIImage(data: data)!))
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
