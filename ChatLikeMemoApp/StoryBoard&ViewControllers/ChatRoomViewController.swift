//
//  ChatRoomViewController.swift
//  ChatLikeMemoApp
//
//  Created by Naoyuki Umeda on 2021/07/26.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController {
    
    private let cell = "cellId"
    private var messages = [String]()
    
    var selectedMemoTitle : String?
    var selectedMemoTitleId : String?
    
    private lazy var chatInputAccesasryView: ChatInputAccesaryView = {
        let view = ChatInputAccesaryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        view.delegate = self
        return view
    }()
    
    
    @IBOutlet weak var chatRoomTableView: UITableView!
    
    @IBOutlet weak var memoDeleteButton: UIBarButtonItem!

    
    //ゴミ箱ボタン（あとでやる）
    @IBAction func memoDeleteButtonAction(_ sender: Any) {
        chatRoomTableView.isEditing = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        chatRoomTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil),forCellReuseIdentifier: "cellId")
        
        //navigationbarの文字を白くする
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        memoDeleteButton.tintColor = .white
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        //optionalでprintされる
        //print("ドキュメントIDは\(String(describing: selectedMemoTitleId))")
        
        guard let unwrappedSelectedMemoTitleId = selectedMemoTitleId else { return }
        //print("unwrappedSelectedMemoTitleIdは\(unwrappedSelectedMemoTitleId)")
        
        //firebaseに保存してあるmemoDetailのうち、特定のmemotitleRefだけをもってくる
        Firestore.firestore().collection("memoDetail").whereField("memoTitleRef", isEqualTo: unwrappedSelectedMemoTitleId).getDocuments(completion: { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                var memoDetailArray:[String] = []

                for doc in querySnapshot.documents {
                    let data = doc.data()
                    memoDetailArray.append(data["memoDetail"] as! String)
                }
                self.messages = memoDetailArray
                print(self.messages)
                self.chatRoomTableView.reloadData()
            }
        })
    }
    
    //このプロパティがxcodeの中に用意されている
    override var inputAccessoryView: UIView? {
        get {
            return chatInputAccesasryView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
}

extension ChatRoomViewController: ChatInputAccesaryViewDelegate {
    
    func tappedSendButton(text: String) {

        //Firebaseにデータを保存
        let createdTime = FieldValue.serverTimestamp()
        guard let unwrappedSelectedMemoTitleId = selectedMemoTitleId else { return }
                //インプットする欄に入力した文字を消す
        chatInputAccesasryView.removeText()
        Firestore.firestore().collection("memoDetail").document().setData(
                        ["memoDetail": text,
                         "memoTitleRef": unwrappedSelectedMemoTitleId,
                        "createdAt": createdTime,
                        "updatedAt": createdTime,
                        "uid": Auth.auth().currentUser?.uid,
                        ],merge: true,completion: { err in
                            if let err = err {
                            print("Error")
                        } else {
                            
                            Firestore.firestore().collection("memoDetail").whereField("memoTitleRef", isEqualTo: unwrappedSelectedMemoTitleId).getDocuments(completion: { (querySnapshot, error) in
                                if let querySnapshot = querySnapshot {
                                    var memoDetailArray:[String] = []
                                    
                                    for doc in querySnapshot.documents {
                                        let data = doc.data()
                                        memoDetailArray.append(data["memoDetail"] as! String)
                                    }
                                    self.messages = memoDetailArray
                                    print(self.messages)
                                    self.chatRoomTableView.reloadData()
                                    print("配列にメモ題名追加成功")
                                }
                            })
                            self.chatRoomTableView.reloadData()
                            print(self.messages)
                        return
                        }
                        }
                        )}
    
}




extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatRoomTableView.estimatedRowHeight = 20
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ChatRoomTableViewCell
        
        cell.messageTextView.text = messages[indexPath.row]
        cell.messageText = messages[indexPath.row]
        return cell
    }
    
    //メッセージをdeleteするためのもの
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        messages.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    //deleteする表示の名前変更
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "削除"
    }
    
    //ゴミ箱ボタンを押した時に並び替え機能は無効にする
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    
}

