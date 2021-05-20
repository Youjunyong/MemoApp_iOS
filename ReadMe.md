# Launch Screen



1. Assetes 로 이동해서 launch Screen에 사용될 png 파일을 왼쪽 리스트에 추가한다.

2. 다음 해상도를 2x 로 바꾸어준다.

![image-20210515124620039](/Users/yujun-yong/Library/Application Support/typora-user-images/image-20210515124620039.png)



3. Launch Screen.storyBoard 파일로 이동한다.
4. 화면 구성 후에 뷰들을 모두 묶어서 Stack View 를 선택한다.

* stackView는 수평이나 수직으로 컨트롤을 배치할때 사용된다.





### Navigation UI

* `Navigation Contorller` - 는 화면을 관리해주는 컨트롤러일뿐, 화면에 나타나지는 않는다.

* 버튼, 이미지, 레이블들을`View`라고 부른다.

* 그리고 하나 이상의 뷰들을 관리하는 객체를 `ViewController`라고 한다.

* `Initial ViewContorller` 를 활성화 시켜야 앱 실행시에 화면이 표시된다. ( 디폴트 값은 활성화가 안되어있다.)



![image-20210515132540743](/Users/yujun-yong/Library/Application Support/typora-user-images/image-20210515132540743.png)



Navigation Title은 오른쪽 TableView에서 입력하지만, `prefer largeTitle`옵션은 왼쪽 네비에이션 바에서 선택해야한다.





## Table View

ViewController Class 를 작성하여 cell 을 표시하도록 한다.



```swift
import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return Memo.exampleList.count
    }
  
  s 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let target = Memo.exampleList[indexPath.row]
        
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = target.insertDate.description

        return cell
    }
```





## Delegate Pattern



## Table view 구현 Step

1. 테이블 뷰 배치
2. 프로토타입 셀 디자인, 셀 아이덴티티파이어 지정
3. 데이터 소스, 델리게이트 연결
4. 데이터 소스 구현
5. 델리게이트 구현



## Date Formatter



```swift
let formatter : DateFormatter = {
  let f = DateFormatter()
  f.dateStyle = .long
  f.timeStyle = .short
  f.locale = Locale(identifier : "KO_kr")
  return f
}()
```





모달 화면을 sheet가 아닌 fullscreen 으로 설정하는 방법

`StoryBoard Segue - Presentation - Fullscreen`







```swift
extension UIViewController {
  func alert(title: String = "Alert!!", aessage : String){
    let alert = UIAlertController(title : title, message : message, preferredStyle : .alert)
    
    let okAction = UIAlertAction(title : "확인", style : .default, handler : nil)
    alert.addAction(okAction)
    present(alert, animated : true)
  }
}
```







## table view update



```swift
 override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        print(#function)
    
```

`  tableView.reloadDate()`



## ios 12에서 화면이 까맣게 나온다면 appdelegate파일에 `**var** window: UIWindow?` 를 추가해주어야한다.





ios12까지는 기본값이 `fullscreen`이다.

ios13 부터 기본값이 `sheet`이다.



`sheet` 방식과 `full screen`방식의 화면 전환 처리방식이 다르기 때문에 

view Will Appear가 실행되지 않는다.



### notification

라디오

Notification 은 broadcasting 이라서

앱을 구성하는 모든 객체로 전달된다.





> in savefunc

```swift
NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object:nil)
```





```swift
extension ComposeViewController {
  static let newMemoDidInsert = Notification.Name(rawValue : "newMemoDidInsert")
}
```







> 실행부

```swift
NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in self?.tableView.reloadData()})

//Closure	부분 이해안감 #13
```

* Observer는 사용후에 반드시 해제해주어야한다.



`var token : NSObjectProtocol?`

```swift
deinit{
  if let token = token{
    NotificationCenter.default.removeObserver(token)
  }
}

```





### 네비게이션의 화면 전환

* `push` : 새로운 화면이 오른쪽에서 왼쪽으로 슬라이드되면서 나타나는것.
* `pop`  : 반대방향으로 슬라이드되면서 화면이 사라지는것





    ```swift
    switch indexPath.row
    ```





`fatalError()`  : 호출시 크러시를 발생시켜 프로세스를 중단시킨다. 





### 데이터 전달

세그웨이는 화면을 만들고, 화면을 전환하기 전에 특별한 메소드를 호출한다.





> 다음화면

```swift
var memo : Memo? //이전화면에서 전달한 메모

```





> 이전화면 `prepare()` 메소드

```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            if let vc = segue.destination as? DetailViewController {
                vc.memo = Memo.exampleList[indexPath.row]
            }
        }
    }
```

**AS? TYPECAST** 

세그웨이가 화면 전환하기 직전에 호출된다. 

`segue.source` : 세그웨이를 실행하는 화면 

`segue.destination` : 새롭게 표시하는 화면







## 테이블 뷰의 Separator 지우기 , 줄바꿈



속성 `Separator` = None 선택

선택될때 회색되는것 `Selection` = No Selection 선택



셀에서는 사이즈에 Table View는 `Automatic`에 체크를 해주면 알아서 조절된다.

다음 `Lable`에서 여러줄로 표시하도록 바꾸면 된다.

`Lines` : 0으로 바꾸면 라인수에 관계없이 모든 텍스트를 표시하게된다.

`LineBreak` 옵션... (말줄임표로 초과되는 문자를 자르는)





## Core Data



ModelFile 데이터의 형태를 설계하는 파일이라고 생각하면 된다.

`AddEntity`



* 엔티티는 클래스로 다루어야 한다.

```swift
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
    newMemo.content= memo
    newMemo.insertDate = Date()
    saveContext()
  }
  
}
```



> Scene Delegate 맨아랫부분

```swift
func sceneDidEnterBackground(_ scene: UIScene){
  Datamanager.shared.saveContext()
}
```











## 메모 편집



```swift
override func prepare(for segue : UIStoryboardSegue, sender : Any?) {
  if let vc = segue.destination.chidren.first as? ComposeViewController {
    vc.editTarget = memo
  }
}
```





> composeViewController - viewDidLoad()

```swift
if let memo = editTarget {
  navigationItem.title = "Edit memo"
  memoTextView.text = memo.content
} else{
  navigationItem.title = "New memo"
}
```











`UIAdaptivePresentationControllerDelegate`

`presentationControllerDidAttemptToDismiss` 





