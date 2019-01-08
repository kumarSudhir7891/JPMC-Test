//
//  BaseService.swift
//  JPMC Test
//
//  Created by Sudhir Kumar on 08/01/19.
//  Copyright © 2019 Sudhir Kumar. All rights reserved.
//


import Foundation

enum ServiceError: Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    case noInternetConnection
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .invalidData: return "Invalid Data"
        case .responseUnsuccessful: return "Response Unsuccessful"
        case .jsonParsingFailure: return "JSON Parsing Failure"
        case .jsonConversionFailure: return "JSON Conversion Failure"
        case .noInternetConnection : return "No internert Connection. You are appear to be offline"
        }
    }
}

protocol ContainsUrl {
    var url:String{get set}
}
protocol GetRequestDTOProtocol : ContainsUrl {
    associatedtype Parameters : Encodable
    var queryParameter : Parameters?{get set}
}

protocol GettableService{
    associatedtype Request: GetRequestDTOProtocol
    associatedtype Response : Decodable
    func getRequest(requestDto :Request , responseDto:Response.Type , completion:@escaping(ApiResult<Response>)->Void)
}


enum ApiResult<T> {
    case Success(T)
    case Failure(ServiceError)
}

protocol Cancelable {
    func cancel()
}




protocol ServiceCallerName {
    var apiCallerName : ClassName{get set}
}

struct EmptyQueryParameter : Encodable {
    
}
struct GetRequestDTO <QueryParameter : Encodable> : GetRequestDTOProtocol {
    var queryParameter: QueryParameter?
    var url: String
}
extension GetRequestDTO {
    init(url: String, queryParameter: QueryParameter?) {
        self.url = url
        self.queryParameter = queryParameter
    }
}




class GetBaseService<Request:GetRequestDTOProtocol,Response:Decodable> : BaseService<Response>, GettableService {

    func getRequest(requestDto :Request , responseDto:Response.Type , completion:@escaping(ApiResult<Response>)->Void) {
            let remoteDataSource =  RemoteDataSource.init()
            let url = makeUrl(url: requestDto.url, queryParmaters: requestDto.queryParameter.dictionary)
            self.request = remoteDataSource.responseGet(url: url) { (data, httpUrlResponse, error) in
                self.decodeResponse(data: data, response: httpUrlResponse, error: error,responseDto:responseDto, completion: completion)
                print("Name of Calling object **** \(self.apiCallerName.className) ****\n\n")
            }
    }
    private func makeUrl(url:String , queryParmaters : [String : Any]?) -> String {
        if let query = queryParmaters , query.count > 0{
            var queryItems = [URLQueryItem]()
            for (key , value) in query {
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
            var urlComps = URLComponents(string:url)!
            urlComps.queryItems = queryItems
            return "\(urlComps.url!)"
        }
        return url
        
    }
}

class BaseService<ResponseDTO : Decodable> : ServiceCallerName,ClassName {
    var apiCallerName: ClassName
    init(callerName : ClassName){
        self.apiCallerName = callerName
    }
    fileprivate var request : URLSessionDataTaskProtocol?
    
    fileprivate func decodeResponse(data : Data?,response:HTTPURLResponse?,error :Error?,responseDto:ResponseDTO.Type , completion :  (ApiResult<ResponseDTO>)->Void) ->Void {
        guard let httpResponse = response else {
            completion(ApiResult.Failure(.requestFailed))
            return
        }
        if httpResponse.status?.responseType == .success {
            if let data = data {
                do {
                    let genericModel = try JSONDecoder().decode(responseDto, from: data)
                    completion(ApiResult.Success(genericModel))
                } catch {
                    print("Conversion Failure \(error)")
                    completion(ApiResult.Failure(.jsonConversionFailure))
                }
            } else {
                completion(ApiResult.Failure(.invalidData))
            }
        } else {
            debugPrint("Response Failure : \(httpResponse)")
            completion(ApiResult.Failure(.responseUnsuccessful))
        }
    }
    func getDictionary(parameterBody : Encodable) -> [String : Any] {
        return parameterBody.dictionary
    }
}


extension BaseService : Cancelable {
    func cancel() {
        self.request?.cancel()
    }
}
