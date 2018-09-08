//
//  ImageViewController.swift
//  Calendar
//
//  Created by koki on 2018/09/07.
//  Copyright © 2018年 user. All rights reserved.
//

import UIKit
import RealmSwift

class ImageViewController: UIViewController {
    var selectedDate : String = ""
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBAction func deletImage(_ sender: Any) {
        let alert = UIAlertController(
            title:"写真を消去しますか？", message: nil, preferredStyle: .alert)
        
        alert.addAction(
            UIAlertAction(
                title: "消去",
                style: .destructive,
                handler: {(action) -> Void in
                    self.delet(action.title!)
            })
        )
        
        
        
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: .cancel,
                handler: nil))
        
        
        self.present(
            alert,
            animated: true,
            completion: {
                // 表示完了後に実行
                print("アクションシートが表示された")
        }
        )
        
        
    }
    
    
    func delet (_ msg:String){
        if msg == "消去" {
        let realm = try! Realm()
        var result = realm.objects(Event.self)
        result = result.filter("date = '\(selectedDate)'")
        print(result)
        for ev in result {
            if ev.date == selectedDate {
                try! realm.write() {
                    realm.delete(ev)
                }
                
            }
            
        }
        }
        
        if let controller = self.presentingViewController as? ViewController {
            controller.loadView()
            controller.viewDidLoad()
        }
        //前のページに戻る
        dismiss(animated: true, completion: nil)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         selectedImage.contentMode = .scaleAspectFit
        selectedImage.image = UIImage(named : "noImage")
        
        let realm = try! Realm()
        var result = realm.objects(Event.self)
        result = result.filter("date = '\(selectedDate)'")
        print(result)
        for ev in result {
            if ev.date == selectedDate {
                print ("表示開始")
                print (ev.Camepic)
                self.selectedImage.image = UIImage(data: ev.Camepic)
                
                
                print ("画像表示")
                
            }
            
        }
       
        

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
