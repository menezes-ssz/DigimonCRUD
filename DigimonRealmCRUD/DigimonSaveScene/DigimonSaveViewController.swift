//
//  ViewControllerInsert.swift
//  DigimonRealmCRUD
//
//  Created by Leonardo da Silva Menezes on 01/02/19.
//  Copyright © 2019 Leonardo da Silva Menezes. All rights reserved.
//

import UIKit

class ViewControllerInsert: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var levelPicker: UIPickerView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    let types : [String] = ["Vaccine", "Virus", "Data", "Free", "Variable"]
    let levels : [String] = ["Fresh", "In-Training", "Rookie", "Champion","Ultimate", "Mega"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typePicker.dataSource = self
        levelPicker.dataSource = self
        typePicker.delegate = self
        levelPicker.delegate = self
        
        profileImageView.image = UIImage(named: "lady-devimon.jpg")
        
        addButton.addTarget(self, action: #selector(insertDigimon), for: .touchDown)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return pickerView == levelPicker ? levels.count : types.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView == levelPicker ? levels[row] : types[row]
    }

    @objc func insertDigimon(sender: UIButton) {
        if (nameTextField.text?.isEmpty)! {
          showAlert(title: "Message", message: "Please choose a digimon name!")
          return
        }

       Digimon.init(name: nameTextField.text!, type: types[typePicker.selectedRow(inComponent: 0)], level: levels[levelPicker.selectedRow(inComponent: 0)], image: "")
    }
    
    private func showAlert(title: String, message : String){
       let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction.init(title: "close", style: .default, handler: nil))
       self.present(alert, animated: true, completion: nil)
    }

    @IBAction func dismissKeyboardOnEndOfEditing(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func onImageViewClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImageView.image = (info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onCloseButtonClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
