//
//  oneViewController.swift
//  myNote
//
//  Created by Mohan K on 05/04/23.
//

import UIKit
import CoreData

class oneViewController: UIViewController {

    @IBOutlet weak var createNote: UICollectionView!
    @IBOutlet weak var newAdd: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var product: [Product]?
    var prod : [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
      
        collectionSetup()
//        prod = product!.sorted(by: {$0.isPinned && !$1.isPinned})
        let layout = ListGridCollectionViewLayout()
        createNote.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchProduct()
    }
    
    func fetchProduct() {
        do {
            self.product = try context.fetch(Product.fetchRequest())
            DispatchQueue.main.async {
                self.createNote.reloadData()
            }
        }
        catch {
            print(error)
        }
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        createNote.contentInset = .zero
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            createNote.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height +  createNote.zoomScale, right: 0)

        }
    }
    
    func collectionSetup() {
        createNote.delegate = self
        createNote.dataSource = self
        DispatchQueue.main.async {
            self.createNote.reloadData()
        }
    }
    @IBAction func createAdd(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension oneViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.product?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = createNote.dequeueReusableCell(withReuseIdentifier: "oneCollectionViewCell", for: indexPath) as!
        oneCollectionViewCell
        let present = self.product![indexPath.item]
        cell.heading.text = present.title
        cell.bodyContent.text = present.text
        let prod = present
        cell.configr(with: prod)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let present = self.product![indexPath.item]
        let alert = UIAlertController(title: "Edit", message: "edit", preferredStyle: .alert)
       
        alert.addTextField()
        alert.addTextField()
        
        let titletextField = alert.textFields![0]
        let contenettextField = alert.textFields![1]
        
        titletextField.text = present.title
        contenettextField.text = present.text
        
        let SaveButton = UIAlertAction(title: "save", style: .default) {
            (action) in
            let titletextField = alert.textFields![0]
            let contenttextField = alert.textFields![1]
            
            present.title = titletextField.text
            present.text =  contenettextField.text
            do {
                try self.context.save()
            }
            catch {
                
            }
            self.fetchProduct()
        }
        alert.addAction(SaveButton)
        self.present(alert,animated: true, completion: nil)
    }
 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 2 - 10
        return CGSize(width: width, height: 150)
    }
}
