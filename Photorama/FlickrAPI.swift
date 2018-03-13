import Foundation



enum FlickrError: Error {
    case invalidJSONData
}

enum Method: String {
    
    case interestingPhotos = "flickr.interestingness.getList"
}


struct FlickrAPI
{
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "0c4c4bdf87b445d92011d67403b7c124"
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    private static func flickrURL(method: Method, parameters: [String:String]?) -> URL {
        
        var components = URLComponents(string: baseURLString)!
        
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]
        
        for (key, value) in baseParams{
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
       if let additionalParams = parameters {
            
            for (key, value) in additionalParams{
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
       }
        
        components.queryItems = queryItems
       
        return components.url!
        
       // return URL(string: "")!
    }
    
    static var interestingPhotosURL: URL {
        return flickrURL (method: .interestingPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
    static func photos(fromJSON data: Data) -> PhotosResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard
            let jsonDictionary = jsonObject as? [AnyHashable:Any],
            let photos = jsonDictionary["photos"] as? [String:Any],
                let photosArray = photos["photo"] as? [[String:Any]] else {
                    return .failure(FlickrError.invalidJSONData)
            }
            
            
            var finalPhotos = [Photo]()
            return .success(finalPhotos)
        } catch let error {
            return .failure(error)
            
        }
    }
    
    
}
