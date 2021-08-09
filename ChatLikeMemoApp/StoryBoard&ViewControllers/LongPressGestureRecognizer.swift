//
//  LongPressGestureRecognizer.swift
//  ChatLikeMemoApp
//
//  Created by Naoyuki Umeda on 2021/08/09.
//

//ここに挑戦
//import UIKit
//
//class LongPressGestureRecognizer: UITextView {
//    override init(frame: CGRect) {
//        //superclass：親クラス
//        super.init(frame: frame)
//        self.copyInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.copyInit()
//    }
//
//    func copyInit() {
//        self.isUserInteractionEnabled = true
//        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(LongPressGestureRecognizer.showMenu(sender:))))
//    }
//
//    @objc func showMenu(sender:AnyObject?) {
//        self.becomeFirstResponder()
//        let contextMenu = UIMenuController.shared
//        if !contextMenu.isMenuVisible {
//            contextMenu.setTargetRect(self.bounds, in: self)
//            contextMenu.setMenuVisible(true, animated: true)
//        }
//    }
//
//    override func copy(_ sender: Any?) {
//        let pasteBoard = UIPasteboard.general
//        pasteBoard.string = text
//        let contextMenu = UIMenuController.shared
//        contextMenu.setMenuVisible(false, animated: true)
//    }
//
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
//
//    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        return action == #selector(UIResponderStandardEditActions.copy)
//    }
//}