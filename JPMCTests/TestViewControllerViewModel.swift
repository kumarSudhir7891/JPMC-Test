//
//  TestViewControllerViewModel.swift
//  JPMC TestTests
//
//  Created by Sudhir Kumar on 08/01/19.
//  Copyright © 2019 Sudhir Kumar. All rights reserved.
//

import XCTest
@testable import JPMC

class TestViewControllerViewModel: XCTestCase {

    let viewModel = ViewControllerViewModel()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testResetDataSource() {
         let dataSource = viewModel.dataSource
         viewModel.resetDataSource()
         XCTAssert(dataSource !== viewModel.dataSource)
            }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
