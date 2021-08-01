//
//  ChatListViewController.swift
//  ChatLikeMemoApp
//
//  Created by Naoyuki Umeda on 2021/07/26.
//

import UIKit
import Firebase

class ChatListViewController: UIViewController {
    
    var user: User? {
        didSet {
            print("user", user?.name)
        }
    }
    
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    //var documentIdArray:[String] = []
    
    public var selectedMemoList : String?
    public var selectedMemoListDocId : String?
    

    private let cellID = "cellId"
    
    //メモの題名の配列
    var memoListTheme : [String] = []
    
    //メモ題名のドキュメントIDの配列
    var memoListThemeDocId : [String] = []
    
    
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
                    
                    //firebaseにデータを保存
                    if let user = Auth.auth().currentUser {
                        let createdTime = FieldValue.serverTimestamp()
                        self.db.collection("memoTitle").document().setData(
                            ["memoTitle": text,"createdAt": createdTime,"updatedAt": createdTime,"uid": Auth.auth().currentUser?.uid,],merge: true,completion: { err in
                                if let err = err {
                                print("Error")
                            } else {
                                print("配列にメモ題名追加成功")
                                //ここからFirebaseからデータを取得して一覧表示する
                                // FirestoreからTodoを取得する処理
                                self.db.collection("memoTitle").order(by: "createdAt", descending: false).getDocuments(completion: { (querySnapshot,error) in
                                    if let querySnapshot = querySnapshot {
                                        var titleArray:[String] = []
                                        var documentIdArray:[String] = []
                                        
                                        for doc in querySnapshot.documents {
                                            let data = doc.data()
                                            titleArray.append(data["memoTitle"] as! String)
                                            documentIdArray.append(doc.documentID)
                                        }
                                        self.memoListTheme = titleArray
                                        self.memoListThemeDocId = documentIdArray
                                        self.chatListTableView.reloadData()
                                    }
                                })
                                self.chatListTableView.reloadData()
                            return
                            }
                            }
                        )}
                    }
                }
            )
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        //Firebaseに保存してあるメモタイトルを取得
        self.db.collection("memoTitle").order(by: "updatedAt", descending: true).getDocuments(completion: { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                var titleArray:[String] = []
                var documentIdArray:[String] = []
                
                for doc in querySnapshot.documents {
                    let data = doc.data()
                    titleArray.append(data["memoTitle"] as! String)
                    documentIdArray.append(doc.documentID)
                }
                self.memoListTheme = titleArray
                self.memoListThemeDocId = documentIdArray
                self.chatListTableView.reloadData()
            }
        })
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
        
        self.selectedMemoList = memoListTheme[indexPath.row]
        self.selectedMemoListDocId = memoListThemeDocId[indexPath.row]
        
        guard let unwrappedSelectedMemoList = selectedMemoList else { return }
        guard let unwrappedSelectedMemoListDocId = selectedMemoListDocId else { return }
        
        let storyboard = UIStoryboard.init(name: "ChatRoom", bundle: nil)
        let next = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
        navigationController?.pushViewController(next, animated: true)
        
        //memoRoomViewControllerに情報を渡す
        next.selectedMemoTitle = unwrappedSelectedMemoList
        next.selectedMemoTitleId = unwrappedSelectedMemoListDocId
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


