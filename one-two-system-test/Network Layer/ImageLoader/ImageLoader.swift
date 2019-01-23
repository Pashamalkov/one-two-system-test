//
//  ImageLoader.swift
//

import Alamofire
import AlamofireImage

class ImageLoader {
    static let sharedInstance = ImageLoader()
    private init(){}
    
    func dowloadImage(url: String, completion: ((UIImage)->())?) {
        Alamofire.request("https://httpbin.org/image/png").responseImage { response in
            debugPrint(response)
            
            print(response.request)
            print(response.response)
            debugPrint(response.result)
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
                completion?(image)
            }
        }
    }
}


