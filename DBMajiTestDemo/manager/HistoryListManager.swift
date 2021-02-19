//
//  HistoryListManager.swift
//  DBMajiTestDemo
//
//  Created by 谭东波 on 2021/2/19.
//  Copyright © 2021 谭东波. All rights reserved.
//

import Foundation
import FMDB

class HistoryListManager {
    public static let shared = HistoryListManager()
    var tableExist = false
    var insertSuccess = false
    
    let tableName = "demoTable"
    
    fileprivate lazy var dbQueue: FMDatabaseQueue = {
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        let filePath = documentPath.appending("/history")
        let dbQueue = FMDatabaseQueue(path: filePath)
        return dbQueue!
    }()
    
    init() {
        
    }
    
    // create
    public func createDBTable() {
        let sql = "create table if not exists \(tableName)(id integer primary key autoincrement,content text default '空')"
        dbQueue.inDatabase { (db) in
            let result = db.executeUpdate(sql, withArgumentsIn: [])
            tableExist = db.tableExists(tableName)
            if result {
                print("创建成功")
            }
            else {
                print("创建失败\(db.lastErrorMessage())")
            }
        }
    }
    
    //增
    public func insertDBTable(content: String) {
        insertSuccess = false
        let sql = "insert into \(tableName)(content) values ('\(content)')"
        dbQueue.inDatabase { (db) in
            let result = db.executeUpdate(sql, withArgumentsIn: [])
            insertSuccess = result
            if result {
                print("增加成功")
            }
            else {
                print("增加失败\(db.lastErrorMessage())")
            }
        }
    }
    
    //查
    public func queryDBTable() -> Array<String> {
        var array = Array<String>()
        let sql = "select * from \(tableName)"
        dbQueue.inDatabase { (db) in
            guard let resultSet = db.executeQuery(sql, withArgumentsIn: []) else {
                return
            }
            while resultSet.next() == true {
                let content = resultSet.string(forColumn: "content") ?? "空内容"
                array.append(content)
            }
        }
        return array
    }
}
