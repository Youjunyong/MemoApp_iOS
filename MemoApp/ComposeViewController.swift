//
//  ComposeViewController.swift
//  MemoApp
//
//  Created by 유준용 on 2021/05/15.
//

import UIKit

class ComposeViewController: UIViewController {

    var editTarget : Memo?
    var originalMemoContent : String?
    
    
    @IBOutlet weak var textView: UITextView!
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func saveBtn(_ sender: Any) {
        print("SaveBtn Clicked !!")
        guard let memo = textView.text, memo.count > 0 else{
            alert(message: "메모를 입력하세요.")
            return
        }
        
//        let newMemo = Memo(inputContent: memo)
//        Memo.exampleList.append(newMemo)
        
        if let target = editTarget {
            target.content = memo
            
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidUpdate, object: nil)
        }else {
            DataManager.shared.addNewMemo(memo)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object:nil)
        }
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    var willShowToken : NSObjectProtocol?
    var willHideToken : NSObjectProtocol?
    
    
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        
        if let token = willHideToken{
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let memo = editTarget{
            navigationItem.title = "Edit memo"
            textView.text = memo.content
            originalMemoContent = memo.content
        }else{
            navigationItem.title = "New Memo"
            textView.text = ""
        }
        textView.delegate = self
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else {return}
            //키보드가 나타날때 본문 text와 키보드 사이에 여백을 준다.
            if let frame =  noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.textView.contentInset
                inset.bottom = height
                strongSelf.textView.contentInset = inset

                inset = strongSelf.textView.scrollIndicatorInsets
                inset.bottom = height
                strongSelf.textView.scrollIndicatorInsets = inset
            }
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else {return}
            var inset = strongSelf.textView.contentInset
            inset.bottom = 0
            strongSelf.textView.contentInset = inset
            
            inset = strongSelf.textView.scrollIndicatorInsets
            inset.bottom = 0
            strongSelf.textView.scrollIndicatorInsets = inset
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        textView.resignFirstResponder()
        navigationController?.presentationController?.delegate = nil
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ComposeViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if let original = originalMemoContent , let changed = textView.text {
            isModalInPresentation = original != changed
            
        }
    }
}

extension ComposeViewController : UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(title: "Alert!!" , message: "내용을 저장하시겠습니까 ?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in self?.saveBtn(action)
            
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { [weak self] (action) in self?.cancelBtn(action)
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ComposeViewController {
  static let newMemoDidInsert = Notification.Name(rawValue : "newMemoDidInsert")
    static let memoDidUpdate = Notification.Name(rawValue: "memoDidUpdate")
}
