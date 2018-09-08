//
//  PhotoLibrary.swift
//  Calendar
//
//  Created by koki on 2018/09/06.
//  Copyright © 2018年 user. All rights reserved.
//

import UIKit
import RealmSwift

class PhotoLibrary: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var selectedDayLabel: UILabel!
    var selectedDate : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDayLabel.text = selectedDate
        photoView.contentMode = .scaleAspectFit
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openLibrary(_ sender: Any) {
        let sourceType:UIImagePickerControllerSourceType =
            UIImagePickerControllerSourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.photoLibrary){
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage]  as? UIImage else {fatalError("エラー") }
        photoView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func saveToCalendar(_ sender: Any) {
        guard let image = photoView.image else {
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
        
        if let controller = self.presentingViewController as? ViewController {
            controller.loadView()
            controller.viewDidLoad()
        }
        //前のページに戻る
        dismiss(animated: true, completion: nil)
        
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
