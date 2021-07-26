//
//  LoginViewController.swift
//  ChatLikeMemoApp
//
//  Created by Naoyuki Umeda on 2021/07/26.
//

import UIKit

class LoginViewController : UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var dontHaveAccountButton: UIButton!
    @IBOutlet weak var noRegisterToUse: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dontHaveAccountButton.addTarget(self, action: #selector(tappedDontHaveAccoutButton), for: .touchUpInside)
    }
    
    @objc private func tappedDontHaveAccoutButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
}
