import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    
    
    @IBOutlet weak var dateLable: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var myImageView: UIImageView!
    @IBAction func comeHome (segue: UIStoryboardSegue){
        
    }
    
    @IBAction func showAlert(_ sender: Any) {
        let actionSheet = UIAlertController(
            title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(
            UIAlertAction(
                title: "カメラで撮影",
                style: .default,
                handler: {(action) -> Void in
                    self.nextPage(action.title!)
            })
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "写真を選択",
                style: .default,
                handler: {(action) -> Void in
                    self.nextPage(action.title!)
            })
        )
        
        actionSheet.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: .cancel,
                handler: nil))
        
        
        self.present(
            actionSheet,
            animated: true,
            completion: {
                // 表示完了後に実行
                print("アクションシートが表示された")
        }
        )
        
        
    }
    
    
    
    func nextPage (_ msg:String){
        if msg == "カメラで撮影" {
            self.performSegue(withIdentifier: "toCameraView", sender: nil)
        }
        else {
            self.performSegue(withIdentifier: "toPhotoSelect", sender: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // デリゲートの設定
        self.calendar.dataSource = self
        self.calendar.delegate = self
        myImageView.contentMode = .scaleAspectFit
        myImageView.isUserInteractionEnabled = true
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
   
    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }
        
        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }
        
        return nil
    }
    
    var tapedDate : String = ""
    //日付がタップされた時の処理
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition){
        
        myImageView.image = UIImage(named: "noImage")
        //日付の取得
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        
        let da = "\(year)/\(m)/\(d)"
        tapedDate = da
        
        //クリックしたら、日付が表示される。
        dateLable.text = "\(m)/\(d)"
        
        //Realmから取得
        let realm = try! Realm()
        var result = realm.objects(Event.self)
        result = result.filter("date = '\(da)'")
        print(result)
        for ev in result {
            if ev.date == da {
               print ("表示開始")
               print (ev.Camepic)
                self.myImageView.image = UIImage(data: ev.Camepic)
              
                    
                print ("画像表示")
                    
                }
           
            }
       
    
}
    func calendar(_ calendar: FSCalendar, hasEventFor date: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let checkDate = formatter.string(from: date)
        
        let realm = try! Realm()
        
        // Realmに保存されてるDog型のオブジェクトを全て取得
        let evs = realm.objects(Event.self)
        var checkValue : Bool = false
                for ev in evs {
            if ev.date == checkDate {
                checkValue = true
            }
    }
        
       
        return checkValue
            
            
        }
    
    
    @IBAction func imageTap(_ sender: UITapGestureRecognizer) {
        print ("tapednow")
        self.performSegue(withIdentifier: "toPhotoPreview", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPhotoPreview"{
        let previewController =
        segue.destination as! ImageViewController
            previewController.selectedDate = tapedDate
        }
        
        if segue.identifier == "toCameraView" {
        let cameraViewController =
        segue.destination as! CameraOfClass
        cameraViewController.selectedDate = tapedDate
    }
        if segue.identifier == "toPhotoSelect" {
            let photoViewController =
                segue.destination as! PhotoLibrary
            photoViewController.selectedDate = tapedDate
        }
        
        
    }
       
    
}
    

