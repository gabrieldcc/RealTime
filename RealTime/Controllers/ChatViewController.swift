////
////  ChatViewController.swift
////  Messenger
////
////  Created by Gabriel de Castro Chaves on 20/06/23.
////
//
//import UIKit
//import MessageKit
//import InputBarAccessoryView
//
//struct Message: MessageType {
//    public var sender: SenderType
//    public var messageId: String
//    public var sentDate: Date
//    public var kind: MessageKind
//}
//
//extension MessageKind {
//    var messageKindString: String {
//        switch self {
//        case .text(let string):
//            return "text"
//        case .attributedText(let nSAttributedString):
//            return "attributed_text"
//        case .photo(let mediaItem):
//            return "photo"
//        case .video(let mediaItem):
//            return "media_item"
//        case .location(let locationItem):
//            return "location"
//        case .emoji(let string):
//            return "emoji"
//        case .audio(let audioItem):
//            return "audio"
//        case .contact(let contactItem):
//            return "contact"
//        case .linkPreview(let linkItem):
//            return "link_preview"
//        case .custom(let optional):
//            return "custom"
//        }
//    }
//}
//
//struct Sender: SenderType {
//    public var photoURL: String
//    public var senderId: String
//    public var displayName: String
//}
//
//class ChatViewController: MessagesViewController {
//    
//    public static let dateFormatter:DateFormatter = {
//        let component = DateFormatter()
//        component.dateStyle = .medium
//        component.timeStyle = .long
//        component.locale = .current
//        return component
//    }()
//    public var isNewConversation = false
//    public let otherUserEmail: String
//    private var messages: [Message] = []
//    private var selfSender: Sender? {
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
//            return nil
//        }
//        return Sender(photoURL: "",
//                      senderId:  email,
//                      displayName: "Joe Smith")
//    }
//    
//    
//    //MARK: - Init
//    init(with email: String) {
//        self.otherUserEmail = email
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    //MARK: - View lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        messagesCollectionView.messagesDataSource = self
//        messagesCollectionView.messagesLayoutDelegate = self
//        messagesCollectionView.messagesDisplayDelegate =  self
//        messageInputBar.delegate = self
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        messageInputBar.inputTextView.becomeFirstResponder()
//    }
//}
//
//    //MARK: - InputBarAccessory
//extension ChatViewController: InputBarAccessoryViewDelegate {
//    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
//              let selfSender = self.selfSender,
//              let messageId = createMessageId() else {
//            return
//        }
//        print("Sending: \(text)")
//        //Send message
//        if isNewConversation {
//            let message = Message(
//                sender: selfSender,
//                messageId: messageId,
//                sentDate: Date(),
//                kind: .text(text)
//            )
//            DatabaseManager.shared.createNewConversation(with: otherUserEmail, firstMessage: message, completion: { success in
//                if success {
//                    print("message sent")
//                } else {
//                    print("failed to send")
//                }
//            })
//        } else {
//            //append to existing conversation data
//        }
//    }
//    
//    private func createMessageId() -> String? {
//        //date, otherUserEmail, senderEmail, randomInt
//        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
//            return nil
//        }
//        let safeCurrentEmail = DatabaseManager.safe(string: currentUserEmail)
//        let dateString = Self.dateFormatter.string(from: Date())
//        let safeDate = DatabaseManager.safe(string: dateString)
//        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(safeDate)"
//        print("created message id: \(newIdentifier)")
//        return newIdentifier
//    }
//}
//
//    //MARK: - Messages
//extension ChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
//    func currentSender() -> SenderType {
//        if let sender = selfSender {
//            return sender
//        }
//        fatalError("Self sender is nil, email should be cached")
//        return Sender(photoURL: "", senderId: "12", displayName: "")
//    }
//    
//    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
//        return messages[indexPath.section]
//    }
//    
//    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
//        return messages.count
//    }
//    
//    
//}
