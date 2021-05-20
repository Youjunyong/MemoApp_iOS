//
//  TableViewController.swift
//  MemoApp
//
//  Created by 유준용 on 2021/05/15.
//

import UIKit

class TableViewController: UITableViewController {

//    let formatter : DateFormatter = {
//        let f = DateFormatter()
//        f.dateStyle = .long
//        f.timeStyle = .short
//        f.locale = Locale(identifier: "KO_kr")
//      return f
//    }()
    
    func dateFormat(inputDate : Date?) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "KO_kr")
        return formatter.string(for: inputDate)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataManager.shared.fetchMemo()
        tableView.reloadData()
        print(#function)
    }

    
    var token : NSObjectProtocol? = nil
    
    deinit{
      if let token = token{
        NotificationCenter.default.removeObserver(token)
      }
    }
    
    
    //다음 화면으로 데이터 전달할 함수
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            if let vc = segue.destination as? DetailViewController {
//                vc.memo = Memo.exampleList[indexPath.row]
                vc.memo = DataManager.shared.memoList[indexPath.row]
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main) { [weak self] (noti) in
            
            self?.tableView.reloadData() }
       
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataManager.shared.memoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let target = DataManager.shared.memoList[indexPath.row]
        
        cell.textLabel?.text = target.content
//        cell.detailTextLabel?.text = formatter.string(from: target.insertDate)
        
        cell.detailTextLabel?.text = dateFormat(inputDate: target.insertDate)
        return cell
    }
   
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let target = DataManager.shared.memoList[indexPath.row]
            DataManager.shared.delMemo(target)
            tableView.deleteRows(at: [indexPath] , with: .fade)
            
        }
    }
}

