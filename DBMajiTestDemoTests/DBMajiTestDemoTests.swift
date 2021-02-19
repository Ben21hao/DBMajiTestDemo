//
//  DBMajiTestDemoTests.swift
//  DBMajiTestDemoTests
//
//  Created by 谭东波 on 2021/2/19.
//  Copyright © 2021 谭东波. All rights reserved.
//

import XCTest
@testable import DBMajiTestDemo

class DBMajiTestDemoTests: XCTestCase {

    var dbManager: HistoryListManager!
    
    override func setUpWithError() throws {
        super.setUp()
        dbManager = HistoryListManager.shared
        
    }
    
    override func tearDownWithError() throws {
        dbManager = nil
        
        super.tearDown()
    }
    
    func testDBCreate() {
        dbManager.createDBTable()
        XCTAssertTrue(dbManager.tableExist == true, "创建数据库成功")
    }
    
    func testDBInsert() {
        if !dbManager.tableExist {
            return
        }
        dbManager.insertDBTable(content: "测试内容")
        XCTAssertTrue(dbManager.insertSuccess == true, "数据插入成功成功")
    }
    func testDBQuery() {
        let array = dbManager.queryDBTable()
        XCTAssertTrue(array.count > 0, "查询成功")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
