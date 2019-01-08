//
//  RemoteDataSource.swift
//  JPMC Test
//
//  Created by Sudhir Kumar on 08/01/19.
//  Copyright © 2019 Sudhir Kumar. All rights reserved.
//
import Foundation



protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}
protocol UrlSessionProtocol {
     func  dataTask(with url: URL, onCompletion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}


extension URLSession :UrlSessionProtocol {
    func dataTask(with url: URL, onCompletion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
       return dataTask(with: url) { (data, response, error) in
            onCompletion(data,response as? HTTPURLResponse , error)
        }
    }
    
}
extension URLSessionDataTask : URLSessionDataTaskProtocol {
    
}

class RemoteDataSource{
        
     // Helper json get method
    func responseGet(url:String,session : UrlSessionProtocol = URLSession.shared,
                     completionHandler:@escaping(Data?,HTTPURLResponse?,Error?)->Void) -> URLSessionDataTaskProtocol? {
        guard let url = URL(string: url) else{
            return nil
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            completionHandler(data,response,error)
        }
        task.resume()
        return task
    }
    
}

