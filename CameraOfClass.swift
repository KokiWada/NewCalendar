//
//  CameraOfClass.swift
//  Calendar
//
//  Created by koki on 2018/08/25.
//  Copyright © 2018年 user. All rights reserved.
//

import UIKit
import RealmSwift

class CameraOfClass: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
       var selectedDate : String = ""
    
   
    @IBOutlet var cameraView : UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var selectedDayLabel: UILabel!
    
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      cameraView.contentMode = .scaleAspectFit
        selectedDayLabel.text = selectedDate
       
        
    }
    
    // カメラの撮影開始
    @IBAction func startCamera(_ sender : AnyObject) {
        
        let sourceType:UIImagePickerControllerSourceType =
            UIImagePickerControllerSourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
        else{
            print("error")
            
        }
    }
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage]
            as? UIImage {
            
            cameraView.contentMode = .scaleAspectFit
            cameraView.image = pickedImage
            
        }
        
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
        
        
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        print("Canceled")
    }
    
    
   
    

    @IBAction func saveToCalendar(_ sender: Any) {
        guard let image = cameraView.image else {
            print ("error")
            return
        }
        let picData =  UIImageJPEGRepresentation(image, 0.1)! as Data
        print("データ書き込み開始")
        
        let realm = try! Realm()
        print ("Realm作成")
        try! realm.write {
             print (picData)
            let Events = [Event(value: ["date": selectedDate , "Camepic": picData ])]
            realm.add(Events)
            print("データ書き込み中")
           
          
        }
     
           
        print("データ書き込み完了")
        //前のページに戻る
        if let controller = self.presentingViewController as? ViewController {
            controller.loadView()
            controller.viewDidLoad()
        }
        dismiss(animated: true, completion: nil)
              
    }

    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
