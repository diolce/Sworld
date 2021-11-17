//
//  ImageDownloader.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 14/11/21.
//

import Foundation
import RxSwift
import RxCocoa


extension ImageManager {
    
    func image(path:String,cache:ImageCaching) -> UIImage? {
        let request = ImageRequest(baseUrl: self.baseURLimages, path: path)
        if let image = cache.imageFromCacheWithURL(url: (request.urlRequest?.url)!) {
            return image
        } else {
            var image:UIImage?
            do {
                let data = try Data(contentsOf: (request.urlRequest?.url)!)
                image = UIImage(data: data)
                cache.saveImageToCache(image: image, url: (request.urlRequest?.url)!)
                return image
            } catch {
                return nil
            }
        }
    }
    
    func image(path:String) -> UIImage? {
        return image(path: path, cache: self.cache)
    }
    
    func rx_image(path:String,cache:ImageCaching) -> Driver<UIImage?> {
        let request = ImageRequest(baseUrl: self.baseURLimages, path: path)
        return Observable.create({ observer -> Disposable in
            if let image = cache.imageFromCacheWithURL(url: (request.urlRequest?.url)!) {
                observer.onNext(image)
                observer.onCompleted()
            } else {
                //Sincronous reques change
                var image:UIImage?
                do {
                    let data = try Data(contentsOf: (request.urlRequest?.url)!)
                    image = UIImage(data: data)
                    cache.saveImageToCache(image: image, url: (request.urlRequest?.url)!)
                    observer.onNext(image)
                    observer.onCompleted()
                } catch let error {
                    observer.onError(error)
                }
            }
            return Disposables.create() 
        }).subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .asDriver(onErrorJustReturn:nil)
    }
    
    func rx_image(path:String) -> Driver<UIImage?> {
        return rx_image(path: path, cache: self.cache)
    }
    
}
