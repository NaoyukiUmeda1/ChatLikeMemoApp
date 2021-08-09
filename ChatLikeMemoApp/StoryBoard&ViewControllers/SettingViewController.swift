//
//  SettingViewController.swift
//  ChatLikeMemoApp
//
//  Created by Naoyuki Umeda on 2021/08/09.
//

import UIKit

class SettingViewController: UITableViewController {
    
    
    @IBAction func tappedReturnToChatList(_ sender: Any) {
        print("ボタン：tappedReturnToChatList")
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = "設定"
        self.navigationController?.navigationBar.barTintColor = UIColor.purple
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(
//                    title: "戻る",
//                    style: .plain,
//                    target: nil,
//                    action: nil
//                )
        
        
    }
    
}

