//
//  RemoteDataSource.swift
//  JPMC TestTests
//
//  Created by Sudhir Kumar on 08/01/19.
//  Copyright © 2019 Sudhir Kumar. All rights reserved.
//

import XCTest
@testable import JPMC
class MockUrlSessionDataTask : URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    private (set) var cancelWasCalled = false

    func resume() {
        resumeWasCalled = true
    }
    func cancel() {
        cancelWasCalled = true
    }
}
class MockURLSessionSuccess :  UrlSessionProtocol {

    private (set) var lastURL: URL?
    func  dataTask(with url: URL, onCompletion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURL = url
        onCompletion(Data(), HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!, nil)
        return MockUrlSessionDataTask()
    }
}
struct error : Error {
    
}
class MockURLSessionFailed :  UrlSessionProtocol {
    private (set) var lastURL: URL?
    func  dataTask(with url: URL, onCompletion: @escaping (Data?, HTTPURLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURL = url
        onCompletion(nil,nil , error())
        return MockUrlSessionDataTask()
    }
}

class TestRemoteDataSource: XCTestCase {
    var remoteDataSource: RemoteDataSource!

    override func setUp() {
        super.setUp()
        self.remoteDataSource = RemoteDataSource()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

   
    func testGetSuccessResponse()  {

       _ = remoteDataSource.responseGet(url:"https://swapi.co/api/planets/" , session: MockURLSessionSuccess() ) { (data, response, error) in
            XCTAssert(error == nil)
            XCTAssert(data != nil)
            XCTAssert(response != nil)
        }
    }
    func testGetFailedResponse()  {
        
      _ =  remoteDataSource.responseGet(url:"https://swapi.co/api/planets/" , session: MockURLSessionFailed() ) { (data, response, error) in
            XCTAssert(error != nil)
        }
    }

    func test_get_resume_called() {
       let dataTask = remoteDataSource.responseGet(url: "https://swapi.co/api/planets/",session: MockURLSessionSuccess()) { (data, response, error) in
        } as? MockUrlSessionDataTask
        XCTAssert((dataTask?.resumeWasCalled)!)
    }
    
    
   

}
