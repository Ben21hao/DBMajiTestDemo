//
//  HistoryListViewController.swift
//  DBMajiTestDemo
//
//  Created by 谭东波 on 2021/2/19.
//  Copyright © 2021 谭东波. All rights reserved.
//

import UIKit

class HistoryListViewController: UIViewController {

    let tableView = UITableView()
    var dataArray: Array<String>?
    
    lazy var detailView: HistoryDetailView = {
        let screenSize = UIScreen.main.bounds.size
        let detailView = HistoryDetailView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        let keyView = UIApplication.shared.windows.last?.rootViewController?.view
        keyView?.addSubview(detailView)
        return detailView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "历史加载"
        setViewConstraint()
    }

    func setViewConstraint() {
        view.backgroundColor = .white
        
        tableView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height-88)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }

}

extension HistoryListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "history_list_cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: identifier)
        }
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        cell?.textLabel?.text = "第\(indexPath.row+1)条记录"
        
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        cell?.detailTextLabel?.numberOfLines = 1
        cell?.detailTextLabel?.text = dataArray?[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let content = dataArray?[indexPath.row]
        detailView.showHistoryDetail(content: content)
    }
}
