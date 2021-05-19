//
//  DataManager.swift
//  MemoApp
//
//  Created by 유준용 on 2021/05/17.
//
import CoreData
import Foundation



class DataManager{
  static let shared = DataManager()
  private init(){
    
  }
  var mainContext : NSManagedObjectContext{
    
    return persistentContainer.viewContext
    
  }
    var memoList = [Memo]()
      
    func fetchMemo() {
        let request : NSFetchRequest<Memo> = Memo.fetchRequest()
        let sortByDateDesc = NSSortDescriptor(key : "insertDate", ascending : false)
        request.sortDescriptors = [sortByDateDesc]
        do{
            try memoList = mainContext.fetch(request)
        }catch{
            print(error)
        }
      }
    
    func addNewMemo(_ memo: String?){
      let newMemo = Memo(context : mainContext) // Memo 는 coredata의 클래스이다.
      newMemo.content = memo
      newMemo.insertDate = Date()
    
      saveContext()
        fetchMemo()
    }
    
    func delMemo(_ memo: Memo?){
        if let memo = memo{
            
//            let index = memoList.firstIndex(of: memo)
            
            mainContext.delete(memo)
            saveContext()
            fetchMemo()
        }
        
        
    }
    
    
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "MemoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
  
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
