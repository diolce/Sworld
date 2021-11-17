//
//  ImageCaching.swift
//  SWorld
//
//  Created by Diego Olmo Cejudo on 14/11/21.
//

import UIKit

protocol ImageCaching {
    func saveImageToCache(image:UIImage?,url:URL)
    func imageFromCacheWithURL(url:URL) -> UIImage?
}

class ImageCache: ImageCaching {
    let imageCache = NSCache<AnyObject, AnyObject>()
    func saveImageToCache(image: UIImage?, url: URL) {
        imageCache.setObject(image! as UIImage, forKey: url as AnyObject)
    }
    
    func imageFromCacheWithURL(url: URL) -> UIImage? {
        return imageCache.object(forKey: url as AnyObject) as? UIImage
    }
}
