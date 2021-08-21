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
    }
    
//    }        if action == "onMenu1:" || action == "onMenu2:" || action == "Menu3:" {
//    return true
//}
//return false
        
//        let myMenuController: UIMenuController = UIMenuController.shared
//        myMenuController.isMenuVisible = true
//        myMenuController.arrowDirection = UIMenuController.ArrowDirection.down
//
//        let myMenuItem_1: UIMenuItem = UIMenuItem(title: "Menu1", action: "onMenu1:")
//        let myMenuItem_2: UIMenuItem = UIMenuItem(title: "Menu2", action: "onMenu2:")
//        let myMenuItem_3: UIMenuItem = UIMenuItem(title: "Menu3", action: "onMenu3:")
//
//        let myMenuItems: NSArray = [myMenuItem_1, myMenuItem_2, myMenuItem_3]
//        myMenuController.menuItems = myMenuItems as! [UIMenuItem]
//
//    }
//
//    func textFieldDidBeginEditing(textField: UITextField) {
//        print("textFieldDidBeginEditing:")
//    }
//
//    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
//            print("textFieldShouldEndEditing:")
//            return true
//        }
//
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        if action == "onMenu1:" || action == "onMenu2:" || action == "Menu3:" {
//            return true }; return false
//    }
//
//    internal func onMenu1(sender: UIMenuItem) {
//        print("onMenu1")
//    }
//    internal func onMenu2(sender: UIMenuItem) {
//        print("onMenu2")
//    }
//    internal func onMenu3(sender: UIMenuItem) {
//        print("onMenu3")
//    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

            // すべて選択，コピー，共有のみ利用可能
            if action == #selector(selectAll(_:)) ||
                action == #selector(copy(_:)) ||
                action == Selector(("_share:")) {
                return true
            } else {
                return false
            }
        }
    
    
//    override func becomeFirstResponder() -> Bool {
//        return true
//    }
//
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        if action == "remove:" || action == "edit:" || action == "regist:" {
//            return true
//        } else {
//            return false
//        }
//    }
//
//    func remove(sender: AnyObject) {
//       // 削除を押したときに呼ばれる
//     }
//
//     func edit(sender: AnyObject) {
//       // 編集を押したときに呼ばれる
//     }
//
//     func regist(sender: AnyObject) {
//       // 登録を押したときに呼ばれる
//     }
    
    
    //メモ枠を自動で調整
    private func estimateFrameForTextView(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
}


