//
//  ChatListViewController.swift
//  ChatLikeMemoApp
//
//  Created by Naoyuki Umeda on 2021/07/26.
//

import UIKit

class ChatListViewController: UIViewController {
    
    
    private let cellID = "cellId"
    //メモの題名の配列
    var memoListTheme : [String] = []
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    
    @IBOutlet weak var addNewMemoListButton: UIBarButtonItem!
    
    @IBAction func addNewMemoListButton(_ sender: Any) {
        var alertTextField: UITextField?
        
        let alert = UIAlertController(
            title: "新しいメモリストを作成",
            message: "",
            preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField(
            configurationHandler: {(textField: UITextField!) in
                alertTextField = textField
            })
        alert.addAction(
            UIAlertAction(
                title: "Cancel",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default) { _ in
                if let text = alertTextField?.text {
                    
                    self.memoListTheme.append(text)
                    //self.memoListTheme(IndexPath.row) = text
                    //変数の中身をUDに追加（firebaseを使っていないので）
                    //forkeyのところは何でも可能
                    UserDefaults.standard.set(self.memoListTheme, forKey: "memoListTheme" )
                    self.chatListTableView.reloadData()
                                }
                            }
        )
                            self.present(alert, animated: true, completion: nil)
                        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        navigationItem.title = "メモ一覧"
        navigationController?.navigationBar.barTintColor = .purple
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        let logoutBarButton = UIBarButtonItem(title: "ログアウト", style: .plain, target: self, action: #selector(tappedLogoutButton))
        
        var preferredStatusBarStyle: UIStatusBarStyle {
                return .lightContent
            }
        
        navigationItem.leftBarButtonItem = logoutBarButton
        navigationItem.leftBarButtonItem?.tintColor = .white
        addNewMemoListButton.tintColor = .white
        
        
        let storyboard = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let nav = UINavigationController(rootViewController: signUpViewController)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc private func tappedLogoutButton() {
        //ログアウトのコード記述
    }
}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoListTheme.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ChatListTableViewCell
        
        cell.memoTitleLabel.text = memoListTheme[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped table view")
        
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let chatRoomViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController")
        navigationController?.pushViewController(chatRoomViewController, animated: true)
    }
    
    //セルの編集許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    //スワイプしたセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            memoListTheme.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    
}


class ChatListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memoTitleLabel: UILabel!
    
    @IBOutlet weak var lastUpdatedTimeLabel: UILabel!
    
    override func awakeFromNib() {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


