//
//  firstViewController.swift
//  myNote
//
//  Created by Mohan K on 04/04/23.
//

import UIKit
import CoreData

class firstViewController: UIViewController {

    @IBOutlet weak var tableNote : UITableView!
    @IBOutlet weak var createButton: UIBarButtonItem!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var product : [Product]?
    var prod : [Product] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        fetchProduct ()
        tableSetup()
       prod = product!.sorted(by: {$0.isPinned && !$1.isPinned})
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchProduct ()
    }
    
    func fetchProduct () {
        do {
            self.product = try context.fetch(Product.fetchRequest())
            DispatchQueue.main.async{
                self.tableNote.reloadData()
            }
        }
        catch {
            print()
        }
    }
    func tableSetup() {
        tableNote.delegate = self
        tableNote.dataSource = self
        DispatchQueue.main.async {
            self.tableNote.reloadData()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        tableNote.contentInset = .zero
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableNote.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height +  tableNote.rowHeight, right: 0)
            
        }
    }
    @IBAction func creatBarButton(_ sender: Any) {
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

extension firstViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.product?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableNote.dequeueReusableCell(withIdentifier: "noteTableViewCell", for: indexPath) as! noteTableViewCell
        let present = self.product![indexPath.row]
        cell.text1.text = present.title
        cell.text2.text = present.text
        let prod = present
        cell.config(with: prod)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let present = self.product![indexPath.row]
        let alert = UIAlertController(title: "Edit", message: "editText", preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
        
        let textTitle = alert.textFields![0]
        let textContent = alert.textFields![1]
        
        textTitle.text = present.title
        textContent.text = present.content
        
        let saveButton = UIAlertAction(title: "Save", style: .default)
        {
            (action) in
            let textTitle = alert.textFields![0]
            let textContent = alert.textFields![1]
            
            present.title = textTitle.text
            present.text = textContent.text
            do {
                try self.context.save()
            }
            catch {
                
            }
            
            self.fetchProduct()
        }
        alert.addAction(saveButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteaction = UIContextualAction(style: .destructive, title: "Delete") {  [self]  _, _, completionHandler  in
            
            let presentToRemove = self.product![indexPath.row]
            self.context.delete(presentToRemove)
            completionHandler(true)
            do {
                try self.context.save()
            }
            catch {
            }
            self.fetchProduct()
            self.tableNote.reloadData()
        }
        deleteaction.backgroundColor = .systemCyan
        let configuration = UISwipeActionsConfiguration(actions: [deleteaction])
        configuration.performsFirstActionWithFullSwipe = true
        
        let note = self.product![indexPath.row]
        let title = note.isPinned ? "Unpin" : "pin"
        let action = UIContextualAction(style: .normal, title: title) { [weak self] _, _, completionHandler in
            guard let self = self else {return}
            let updatenote = note
            updatenote.isPinned.toggle()
            self.product![indexPath.row] = updatenote
            self.product = self.prod.sorted(by: {$0.isPinned && !$1.isPinned})
            self.tableNote.reloadData()
            completionHandler(true)
            do {
                try self.context.save()
            }
            catch{
                
            }
            self.fetchProduct()
            self.tableNote.reloadData()
        }
        action.backgroundColor = note.isPinned ?.gray: .orange
        action.image = note.isPinned ? UIImage(systemName: "pin.fil") : UIImage(systemName: "pin")
        return UISwipeActionsConfiguration(actions: [action,deleteaction])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
