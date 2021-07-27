//
//  SignUpViewController.swift
//  ChatLikeMemoApp
//
//  Created by Naoyuki Umeda on 2021/07/26.
//

import UIKit
import Firebase

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
        }
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

