//
//  ViewController.swift
//  DBMajiTestDemo
//
//  Created by 谭东波 on 2021/2/19.
//  Copyright © 2021 谭东波. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var limitTime = 5
    var codeTimer: DispatchSource?
    var dataArray = Array<String>()
    
    let dbManager = HistoryListManager.shared
    
    var button = UIButton()
    var label = UILabel()
    var dataText = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "首页"
        setViewConstraint()
        
        codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global()) as? DispatchSource;
        startCountDown()
        
        //local data
        dbManager.createDBTable()
        if dbManager.tableExist {
            dataArray = dbManager.queryDBTable()
            dataText.text = dataArray.last
        }
        else {
            requestData()
        }
    }
    
    deinit {
        cancelTimer()
    }
    
    @objc func buttonAction(sender: UIButton) {
        guard dataArray.count > 0 else {
            print("暂无历史记录")
            return
        }
        let historyVc = HistoryListViewController()
        historyVc.dataArray = dataArray
        navigationController?.pushViewController(historyVc, animated: true)
    }
    
    //MARK: data
    func requestData() {
        let lock = NSLock()
        lock.lock()
        
        AF.request("https://api.github.com/").responseJSON { [weak self](respons) in
            print("请求成功：\(respons)")
            
            guard let dic = respons.value as? Dictionary<String, Any> else {
                DispatchQueue.main.async {
                    self?.dataText.text = "\(respons)"
                }
                return
            }
            let content = "\(dic)"
            self?.dataArray.insert(content, at: 0)
            self?.dbManager.insertDBTable(content: content)
            DispatchQueue.main.async {
                self?.dataText.text = content
            }
            
            lock.unlock()
        }
    }
    
    //MARK: cut time
    func startCountDown() {
        limitTime = 5
        
        codeTimer?.schedule(deadline: .now(), repeating: .seconds(1));
        codeTimer?.setEventHandler(handler: {
            DispatchQueue.main.async { [weak self] in
                self?.updateJumpBtn();
            }
        })
        
        if codeTimer!.isCancelled {
            return;
        }
        
        codeTimer?.resume();
    }
    
    func updateJumpBtn() {
        label.text = "\(limitTime) S"
        
        if (limitTime <= 0) {
            codeTimer?.suspend();
            startCountDown()
            requestData()
        }
        else {
            limitTime = limitTime - 1;
        }
    }
    
    func cancelTimer() {
        codeTimer?.cancel()
        codeTimer = nil
    }
    
    //MARK: UI
    func setViewConstraint() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        button.frame = CGRect(x: view.bounds.size.width/2 + 28, y: view.safeAreaInsets.top + 8, width: 88, height: 33)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitle("历史加载", for: .normal)
        button.addTarget(self, action: #selector(buttonAction(sender: )), for: .touchUpInside)
        button.backgroundColor = .blue
        view.addSubview(button)
        
        label.frame = CGRect(x: 28, y: view.safeAreaInsets.top + 8, width: 88, height: 33)
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.backgroundColor = .blue
        view.addSubview(label)
        
        dataText.frame = CGRect(x: 0, y: view.safeAreaInsets.top + 48, width: view.bounds.size.width, height: view.bounds.size.height - 188)
        dataText.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        dataText.backgroundColor = .red
        dataText.isEditable = false
        view.addSubview(dataText)
    }
}

