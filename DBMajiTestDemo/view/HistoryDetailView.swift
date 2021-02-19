//
//  HistoryDetailView.swift
//  DBMajiTestDemo
//
//  Created by 谭东波 on 2021/2/19.
//  Copyright © 2021 谭东波. All rights reserved.
//

import UIKit

class HistoryDetailView: UIView {
    let textView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        textView.frame = frame
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.isEditable = false
        self.addSubview(textView)
        
        self.alpha = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        textView.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showHistoryDetail(content: String?) {
        
        self.alpha = 1
        detailText(text: content)
    }
    
    @objc func tapAction() {
        self.alpha = 0
        detailText(text: "")
    }
    
    func detailText(text: String?) {
        textView.text = text
        constraintUpdate()
    }
    
    func constraintUpdate() {
        let maxHeight = frame.height
        
        let constraintSize = CGSize(width: frame.width, height: CGFloat(MAXFLOAT))
        var size = textView.sizeThatFits(constraintSize)
        if size.height <= frame.size.height {
            let y = (frame.height - size.height)/2.0
            textView.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: size.height)
        }
        else {
            if size.height >= maxHeight {
                size.height = CGFloat(maxHeight)
            }
            textView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: size.height)
        }
        
    }
}

