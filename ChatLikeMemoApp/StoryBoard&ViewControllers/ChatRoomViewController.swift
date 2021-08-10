//
//  ChatRoomViewController.swift
//  ChatLikeMemoApp
//
//  Created by Naoyuki Umeda on 2021/07/26.
//

import UIKit
import Firebase

class ChatRoomViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    private let cell = "cellId"
    private var messages = [String]()
    private var messageCreatedTime  = [Date]()
    
    var selectedMemoTitle : String?
    var selectedMemoTitleId : String?
    
    private lazy var chatInputAccesasryView: ChatInputAccesaryView = {
        let view = ChatInputAccesaryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        view.delegate = self
        return view
    }()
    
    
    @IBOutlet weak var chatRoomTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        chatRoomTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil),forCellReuseIdentifier: "cellId")
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem?.tintColor = .white
        
        self.navigationItem.title = selectedMemoTitle
        
        self.chatRoomTableView.backgroundColor = .white
        
        guard let unwrappedSelectedMemoTitleId = selectedMemoTitleId else { return }
        
        //firebaseに保存してあるmemoDetailのうち、特定のmemotitleRefだけをもってくる
        self.db.collection("memoDetail").whereField("memoTitleRef", isEqualTo: unwrappedSelectedMemoTitleId).order(by: "createdAt", descending: false).getDocuments(completion: { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                var memoDetailArray:[String] = []
                var memoDetailCreatedTimeArray:[Date] = []
                for doc in querySnapshot.documents {
                    let data = doc.data()
                    let timestamp = data["createdAt"] as! Timestamp
                    
                    memoDetailArray.append(data["memoDetail"] as! String)
                    memoDetailCreatedTimeArray.append(timestamp.dateValue())
                }
                self.messages = memoDetailArray
                self.messageCreatedTime = memoDetailCreatedTimeArray
                //時刻の表示もされるようにデータをもってこれるようにした
                print(self.messages)
                print(self.messageCreatedTime)
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
        
        self.db.collection("memoDetail").document().setData(
                        ["memoDetail": text,
                         "memoTitleRef": unwrappedSelectedMemoTitleId,
                        "createdAt": createdTime,
                        "updatedAt": createdTime,
                        "uid": Auth.auth().currentUser?.uid,
                        ],merge: true,completion: { err in
                            if let err = err {
                            print("Error")
                        } else {
                            
                            Firestore.firestore().collection("memoDetail").whereField("memoTitleRef", isEqualTo: unwrappedSelectedMemoTitleId).order(by: "createdAt", descending: false).getDocuments(completion: { (querySnapshot, error) in
                                if let querySnapshot = querySnapshot {
                                    var memoDetailArray:[String] = []
                                    var memoDetailCreatedTimeArray:[Date] = []
                                    
                                    for doc in querySnapshot.documents {
                                        let data = doc.data()
                                        let timestamp = data["createdAt"] as! Timestamp
                                        memoDetailArray.append(data["memoDetail"] as! String)
                                        memoDetailCreatedTimeArray.append(timestamp.dateValue())
                                    }
                                    self.messages = memoDetailArray
                                    self.messageCreatedTime = memoDetailCreatedTimeArray
                                    self.chatRoomTableView.reloadData()
                                }
                            })
                            self.chatRoomTableView.reloadData()
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
        cell.dateLabel.text = dateFormatterForlastUpdatedTimeLabel(date: messageCreatedTime[indexPath.row])
        cell.dateLabel.textColor = .black
        return cell
    }
    
    //時刻のデザインを請け負う部分
    func dateFormatterForlastUpdatedTimeLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = .current
        return formatter.string(from: date)
    }
    
    
    
    
    

    
}

