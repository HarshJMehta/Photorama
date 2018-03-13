//
//  PhotoStore.swift
//  Photorama
//
//  Created by Harsh Mehta on 2018-03-12.
//  Copyright © 2018 Harsh Mehta. All rights reserved.
//
import Foundation

class PhotoStore{
    
    enum PhotoResult{
        case success ([Photo])
        case failure(Error)
    }
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    func fetchInterestingPhotos(){
        
        
        let url = FlickrAPI.interestingPhotosURL
        let request = URLReuqest(url: url)
        let task = session.dataTask (with:request){
            (data, response, error) -> Void in
            
            if let jsonData = data {
                
                do{
                    let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
                    print(jsonObject)
                }
                catch let error {
                    print("Error creating JSON object: \(error)")
                    
                }
                
            } else if let requestError = error {
                print ("Error fetching interesting photos: \(requestError)")
                
            } else {
                print ("Unexpected error with the request")
                
            }
        }
        task.resume()
}
}
