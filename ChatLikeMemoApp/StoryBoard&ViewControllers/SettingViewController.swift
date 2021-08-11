//
//  SettingViewController.swift
//  ChatLikeMemoApp
//
//  Created by Naoyuki Umeda on 2021/08/09.
//

import UIKit
import Firebase

class SettingViewController: UIViewController {
    
    private let cellID = "settingCell"
    
    var settingList : [String] = ["ログアウト","お問い合わせ","バージョン"]
    
    @IBAction func tappedReturnToChatList(_ sender: Any) {
        print("ボタン：tappedReturnToChatList")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var settingTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "設定"
        self.navigationController?.navigationBar.barTintColor = UIColor.purple
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = .white
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingTableViewCell
        cell.settingCellLabel.text = settingList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped table view")
        if indexPath.row == 0 {
            print("ログアウト")
            let firebaseAuth = Auth.auth()
           do {
            try firebaseAuth.signOut()
            print("ログアウト成功&サインアップ画面へ移動")
            
            
            
            
            
           } catch let signOutError as NSError {
             print("ログアウトエラー内容", signOutError)
           }
             
        }
        else if indexPath.row == 1 {
            print("お問い合わせフォームへ移動")
            //タップした時の選択色を消す
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
            let url = NSURL(string: "https://tayori.com/form/635db211196f258d238d4f05e177c3e11f78a337")
            if UIApplication.shared.canOpenURL(url! as URL) {
                UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            }
        }
        else if indexPath.row == 2 {
            print("アプリのバージョン")
        }
        
    }
}

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingCellLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
