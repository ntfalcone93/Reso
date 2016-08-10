//
//  ImageController.swift
//  HighCardMiniProject
//
//  Created by Nathan on 4/26/16.
//  Copyright © 2016 Falcone Development. All rights reserved.
//

import UIKit

class ImageController {
    
    // Fetches data at url and turns the data in an image
    static func imageForURL(url: NSURL, completion: (image: UIImage?) -> Void) {
        NetworkController.performRequestForURL(url, httpMethod: .Get) { (data, error) in
            if let error = error {
                print("There was an error on line \(#line), func \(#function), file \(#file). \n Error: \(error.localizedDescription)")
                completion(image: nil)
            } else {
                guard let data = data else {
                    completion(image: nil)
                    return
                }
                let image = UIImage(data: data)
                dispatch_async(dispatch_get_main_queue(), {
                    completion(image: image)
                })
            }
        }
    }
}