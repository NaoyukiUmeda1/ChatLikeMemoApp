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
    
    var settingList : [String] = ["ログアウト","お問い合わせ","バージョン","利用規約","プライバシーポリシー"]
    
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
        return 5
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
            
            let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
            let toSignUpViewController = storyboard.instantiateViewController(identifier: "SignUpViewController") as SignUpViewController
            
            //let toSettingViewControllerNavi = UINavigationController(rootViewController: toSettingViewController)
            toSignUpViewController.modalPresentationStyle = .fullScreen
            self.present(toSignUpViewController, animated: true, completion: nil)
            
            
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
        
        else if indexPath.row == 3 {
            print("利用規約")
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
            let url = NSURL(string: "https://naoyukiumeda1.tumblr.com/post/661309119501942784/%E5%88%A9%E7%94%A8%E8%A6%8F%E7%B4%84")
            if UIApplication.shared.canOpenURL(url! as URL) {
                UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            }
        }
        
        else if indexPath.row == 4 {
            print("プライバシーポリシー")
            tableView.deselectRow(at: indexPath as IndexPath, animated: true)
            let url = NSURL(string: "https://naoyukiumeda1.tumblr.com/post/661309138947735552/%E3%83%97%E3%83%A9%E3%82%A4%E3%83%90%E3%82%B7%E3%83%BC%E3%83%9D%E3%83%AA%E3%82%B7%E3%83%BC")
            if UIApplication.shared.canOpenURL(url! as URL) {
                UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
            }
        }
        
    }
}

class SettingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingCellLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
