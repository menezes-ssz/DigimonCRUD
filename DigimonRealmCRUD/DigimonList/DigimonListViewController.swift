//
//  ViewController.swift
//  DigimonRealmCRUD
//
//  Created by Leonardo da Silva Menezes on 01/02/19.
//  Copyright © 2019 Leonardo da Silva Menezes. All rights reserved.
//

import UIKit
import RealmSwift
import Spring

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var digimonCollectionView: UICollectionView!
    var digimonsList : Results<Digimon>?
    @IBOutlet weak var emptyStateText: SpringLabel!
    @IBOutlet weak var insertDigimon: SpringButton!
    
    @IBOutlet var mainView: SpringView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let flowLayout = digimonCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width =  UIScreen.main.bounds.size.width / 2 - 30
        flowLayout.estimatedItemSize = CGSize(width: width, height: 260)
        
         self.digimonCollectionView.register(UINib(nibName: "DigimonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DigimonCell")
        
        self.digimonCollectionView.dataSource = self;
        self.digimonCollectionView.delegate = self;
        
        insertDigimon.addTarget(self, action: #selector(callInsertDigimonScene), for: .touchUpInside)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if digimonsList?.count == 0 {
            digimonCollectionView.isHidden = true
            emptyStateText.isHidden = false
            emptyStateText.animation = "squeezeDown"
            emptyStateText.animate()
        }else{
            digimonCollectionView.isHidden = false
            emptyStateText.isHidden = true
            mainView.animation = "squeezeUp"
            mainView.animate()
        }
        return digimonsList!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DigimonCell", for: indexPath) as! DigimonCollectionViewCell
        return  cell.createDigiCell(digimon: digimonsList![indexPath.row])
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController.init(title: "Message", message: "What you need to do with \(digimonsList![indexPath.row].name)", preferredStyle: .alert)
        
        let editAction = UIAlertAction.init(title: "Edit", style: .default, handler: { (UIAlertAction) in
            self.performSegue(withIdentifier: "insertScreen", sender: self.digimonsList![indexPath.row])
        })
        
        let deleteAction = UIAlertAction.init(title: "Delete", style: .destructive, handler: { (UIAlertAction) in
            let realm = try! Realm()
            try! realm.write {
                realm.delete(self.digimonsList![indexPath.row])
                self.digimonCollectionView.reloadData()
            }
        })
        
        let cancelAction = UIAlertAction.init(title: "cancel", style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc  func callInsertDigimonScene(sender : UIButton) {
        self.performSegue(withIdentifier: "insertScreen", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let realm = try! Realm()
        digimonsList = realm.objects(Digimon.self)
        digimonCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender != nil {
            let digimonSaveVC = segue.destination as! DigimonSaveViewController
            digimonSaveVC.digimonToSave = sender as? Digimon
        }
    }
}

