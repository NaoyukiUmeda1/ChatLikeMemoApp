//
//  ChatInputAccesaryView.swift
//  ChatLikeMemoApp
//
//  Created by Naoyuki Umeda on 2021/07/26.
//

import UIKit

protocol ChatInputAccesaryViewDelegate: class {
    func tappedSendButton(text: String)
}


class ChatInputAccesaryView: UIView {
    
    
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    
    @IBAction func tappedSendButton(_ sender: Any) {
        
        guard let text = chatTextView.text else { return }
        //このtextをtappedSendButtonのtextに渡す
        delegate?.tappedSendButton(text: text)
        print("tapped send button")
    }
    
    weak var delegate: ChatInputAccesaryViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nibInit()
        setupViews()
        autoresizingMask = .flexibleHeight
        
    }
    
    private func setupViews (){
        chatTextView.layer.cornerRadius = 15
        chatTextView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
        chatTextView.layer.borderWidth = 1
        sendButton.layer.cornerRadius = 15
        sendButton.imageView?.contentMode = .scaleAspectFit
        sendButton.contentHorizontalAlignment = .fill
        sendButton.contentVerticalAlignment = .fill
        sendButton.isEnabled = false
        
        chatTextView.text = ""
        chatTextView.delegate = self
        
    }
    
    func removeText(){
        chatTextView.text = ""
        sendButton.isEnabled = false
    }
    
    
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    
    
    //メッセージインプットの画面のメソッド
    private func nibInit(){
        let nib = UINib(nibName: "ChatInputAccesaryView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(view)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatInputAccesaryView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        print("textView.text:", textView.text)
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
        
        
        
    }
    
}

