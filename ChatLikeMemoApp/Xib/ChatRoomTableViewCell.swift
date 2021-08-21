//
//  ChatRoomTableViewCell.swift
//  ChatLikeMemoApp
//
//  Created by Naoyuki Umeda on 2021/07/26.
//

import UIKit

//xibファイル
class ChatRoomTableViewCell: UITableViewCell {
    
    var messageText: String? {
        didSet {
            guard let text = messageText else { return }
            let width = estimateFrameForTextView(text: text).width + 50
            
            messageTextViewWithConstraint.constant = width
            messageTextView.text = text
            messageTextView.backgroundColor = UIColor.rgb(red: 90, green: 255, blue: 25)
        }
    }
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageTextViewWithConstraint: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageTextView.layer.cornerRadius = 15
        backgroundColor = .clear
        
        UIMenuController.shared.menuItems = [.init(title: "testFunc", action: #selector(ChatRoomTableViewCell.testFunc))]
        
    }
    
    
    @objc func testFunc() {
            guard let range = messageTextView.selectedTextRange, let text = messageTextView.text(in: range),
                !text.isEmpty else {
                return
            }
    }
    
    //メモ枠を自動で調整
    private func estimateFrameForTextView(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
}


