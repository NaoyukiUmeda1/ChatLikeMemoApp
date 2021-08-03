//
//  SignUpViewController.swift
//  ChatLikeMemoApp
//
//  Created by Naoyuki Umeda on 2021/07/26.
//

import UIKit
import Firebase


struct  User {
    let name : String
    let createdAt : Timestamp
    let email : String
    var uid : String?
    
    init(dic: [String: Any]){
        self.name = dic["name"] as! String
        self.createdAt = dic["createdAt"] as! Timestamp
        self.email = dic["email"] as! String
    }
}


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountButton: UIButton!
    @IBOutlet weak var noRegisterToUseButton: UIButton!
    
    
    @IBAction func tappedResisterButton(_ sender: Any) {
        handleAuthToFirebase()
    }
    
    
    @IBAction func tappedNonResisterButton(_ sender: Any) {
        nonResisterAuthToFirebase()
    }
    
    private func handleAuthToFirebase() {
        guard let email = emailTextField.text else { return }
        //デフォルトでは6桁以上のパスワードでないと登録できない
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("認証情報の保存に失敗しました \(err)")
            }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let name = self.usernameTextField.text else { return }
            let docData = ["email": email, "name": name, "createdAt": Timestamp()] as [String : Any]
            
            Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
                if let err = err {
                    print("firestoreへの保存に失敗しました \(err)")
                    return
                }
                print("firestoreへの保存に成功しました")
                Firestore.firestore().collection("users").document(uid).getDocument{(snapshot, err) in
                    if let err = err {
                        print("ユーザー情報の取得に失敗しました\(err)")
                        return
                    }
                    guard let data = snapshot?.data() else { return }
                    let user = User.init(dic: data)
                    print("ユーザー情報の取得ができました\(user.name)")
                    
                    let storyboard = UIStoryboard(name: "ChatList", bundle: nil)
                    let chatListViewController = storyboard.instantiateViewController(identifier: "ChatListViewController") as ChatListViewController
                    chatListViewController.user = user
                    chatListViewController.modalPresentationStyle = .fullScreen
                    self.present(chatListViewController, animated: true, completion: nil)
                    }
        }
        }
        
    }
    
    private func nonResisterAuthToFirebase()  {
        //FirebaseApp.configure()
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else { return
            }
            print(user.uid)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.layer.cornerRadius = 15
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.rgb(red: 240, green: 240, blue: 240).cgColor
        registerButton.backgroundColor = .rgb(red: 198, green: 156, blue: 197)
        alreadyHaveAccountButton.addTarget(self, action: #selector(tappedAlreadyHaveAccountButton), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    @objc private func tappedAlreadyHaveAccountButton() {
        let storyboard = UIStoryboard(name: "LogIn", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    //キーボードが出てきた時の処理が受け取れる
    @objc func showKeyboard(notification: Notification){
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keyboardMinY = keyboardFrame?.minY else {return}
        let resisterButonMaxY = registerButton.frame.maxY
        
        let distance = resisterButonMaxY - keyboardMinY + 20
        
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = transform
        })
    }
    
    @objc func hideKeyboard(){
        print("hideKeyboard is hide")
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
            self.view.transform = .identity
        })
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension SignUpViewController : UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {

        let emailIsEmpty = emailTextField.text?.isEmpty ?? false
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? false
        let usernameIsEmpty = usernameTextField.text?.isEmpty ?? false
        
        if emailIsEmpty || passwordIsEmpty || usernameIsEmpty {
            registerButton.isEnabled = false
            registerButton.backgroundColor = .rgb(red: 198, green: 156, blue: 197)
        } else {
            registerButton.isEnabled = true
            registerButton.backgroundColor = .purple
        }
        
    }
}

