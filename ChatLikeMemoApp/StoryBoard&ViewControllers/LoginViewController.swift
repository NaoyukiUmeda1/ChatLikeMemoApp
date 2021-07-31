//
//  LoginViewController.swift
//  ChatLikeMemoApp
//
//  Created by Naoyuki Umeda on 2021/07/26.
//

import UIKit
import Firebase

class LoginViewController : UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    @IBOutlet weak var noRegisterToUse: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dontHaveAccountButton.addTarget(self, action: #selector(tappedDontHaveAccoutButton), for: .touchUpInside)
    
        loginButton.isEnabled = false
        loginButton.layer.cornerRadius = 15
        loginButton.layer.borderWidth = 1
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
    
    }
    
    @IBAction func tappedLogInButton(_ sender: Any) {
        print("loginButton")
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
            if let err = err {
                print("認証情報の取得に失敗しました。\(err)")
                return
                
            }
            print("ログインに成功しました")
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let userRef = Firestore.firestore().collection("users").document(uid)
            
            userRef.getDocument{(snapshot, err) in
                if let err = err {
                    print("ユーザー情報の取得に失敗しました\(err)")
                    return
                }
                
                guard let data = snapshot?.data() else { return }
                let user = User.init(dic: data)
                print("ユーザー情報の取得ができました")
                self.presentToChatListViewController()
                }
            }
    }
    
    private func presentToChatListViewController() {
        let storyboard = UIStoryboard(name: "ChatList", bundle: nil)
        let chatlistViewController = storyboard.instantiateViewController(identifier: "ChatListViewController") as ChatListViewController
        chatlistViewController.modalPresentationStyle = .fullScreen
        self.present(chatlistViewController, animated: true, completion: nil)
    }
    
    @objc private func tappedDontHaveAccoutButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //キーボードが出てきた時の処理が受け取れる
    //キーボード以外のところを触るとキーボードが下になくなってくれる
    @objc func showKeyboard(notification: Notification){
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        guard let keyboardMinY = keyboardFrame?.minY else {return}
        let resisterButonMaxY = loginButton.frame.maxY
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

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {

        let emailIsEmpty = emailTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true
        
        if emailIsEmpty || passwordIsEmpty {
            loginButton.isEnabled = false
        } else {
            loginButton.isEnabled = true
        }
}
}
