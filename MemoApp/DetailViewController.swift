//
//  DetailViewController.swift
//  MemoApp
//
//  Created by 유준용 on 2021/05/15.
//

import UIKit

class DetailViewController: UIViewController {

    @IBAction func shareBtn(_ sender: Any) {
        
        guard let memo = memo?.content else { return }
        
        let activityVC = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        
        present(activityVC, animated: true, completion: nil)
        
        
    }
    
    
    
    @IBOutlet weak var tableView: UITableView!
    var memo : Memo?
    var token : NSObjectProtocol? = nil
    
    deinit{
        if let token = token{
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    @IBAction func deleteBtn(_ sender: Any) {
        let alert = UIAlertController(title: "알림", message: "메모를 삭제하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] (action) in
            DataManager.shared.delMemo(self?.memo)
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    func dateFormat(inputDate : Date) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "KO_kr")
        return formatter.string(from: inputDate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController {
            vc.editTarget = memo
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidUpdate, object: nil, queue: OperationQueue.main) {
            [weak self] (noti) in
            self?.tableView.reloadData()
        }
    }
    
    
    
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
//            if let vc = segue.destination as? DetailViewController {
////                vc.memo = Memo.exampleList[indexPath.row]
//                vc.memo = DataManager.shared.memoList[indexPath.row]
//            }
//        }
//    }
    
    
    
    
}

extension DetailViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
            cell.textLabel?.text = memo?.content
            
            return cell
            
        case 1 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            cell.textLabel?.text = dateFormat(inputDate: memo?.insertDate ?? Date())
            return cell
        default:
            fatalError()
        }
        
    }
    
    
}


