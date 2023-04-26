//
//  ViewController.swift
//  myNote
//
//  Created by Mohan K on 19/03/23.
//

import UIKit
import CoreData

struct Noted {
    var color: ColorsType
    var id : Int
    var colors: UIColor
}

enum ColorsType: String {
    case black = "black"
    case blue = "blue"
    case cyan = "cyan"
    case gray = "gray"
    case green = "green"
    case purple = "purple"
    case red = "red"
    case systemMint = "systemMint"
    case systemPink = "systemPink"
    case white = "white"
    
    var backgroundColor : String {
        switch self {
        case .black:
            return"black"
        case .blue:
            return"blue"
        case .cyan:
            return"cyan"
        case .gray:
            return"gray"
        case .green:
            return"green"
        case .purple:
            return"purple"
        case .red:
            return"red"
        case .systemMint:
            return"systemMint"
        case .systemPink:
            return"systemPink"
        case .white:
            return"white"
        }
    }
    
    var fontColor : String {
        switch self {
        case .black:
            return"black"
        case .blue:
            return"blue"
        case .cyan:
            return"cyan"
        case .gray:
            return"gray"
        case .green:
            return"green"
        case .purple:
            return"purple"
        case .red:
            return"red"
        case .systemMint:
            return"systemMint"
        case .systemPink:
            return"systemPink"
        case .white:
            return"white"
        }
    }
}



class ViewController: UIViewController {
    
//    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var notetableView: UITableView!
    @IBOutlet weak var notecollectionView: UICollectionView!
    @IBOutlet weak var listgridView: UIBarButtonItem!
    @IBOutlet weak var addBarBtn: UIBarButtonItem!
    @IBOutlet weak var listAndGrid:  UISegmentedControl!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let product = Product(context: persistentContainer.viewContext)
//
    var isGrid = false
    var product: [Product]?
    var notes : [Product] = []
    var note :  [Noted] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
      

//        notecollectionView.register(coreCollectionViewCell.self, forCellWithReuseIdentifier: "coreCollectionViewCell")
        fetchProduct()
        setup()
        notes = product!.sorted(by: {$0.isPinned && !$1.isPinned})
        let layout = ListGridCollectionViewLayout()

        notecollectionView.collectionViewLayout = layout
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchProduct()
    }
    
    func fetchProduct() {
        do {
            self.product = try context.fetch(Product.fetchRequest())
            DispatchQueue.main.async {
                self.notetableView.reloadData()
                self.notecollectionView.reloadData()
            }
        }
        catch {
            print(error)
        }
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch listAndGrid.selectedSegmentIndex {
        case 0:
            notetableView.isHidden = false
            notecollectionView.isHidden = true
        case 1:
            notetableView.isHidden = true
            notecollectionView.isHidden = false
        default:
            break
        }
    }
    @IBAction func toggleView(_ sender: Any) {
        isGrid = !isGrid

        DispatchQueue.main.async {
            if self.isGrid == false {
                self.notetableView.isHidden = false
                self.notecollectionView.isHidden = true
                self.notetableView.reloadData()
            }
            else {
                self.notecollectionView.isHidden = false
                self.notetableView.isHidden = true
                self.notecollectionView.reloadData()
            }

            self.view.layoutIfNeeded()

        }
    }
    
    @IBAction func addBarButton(_ sender: Any) {
  
    }
    @objc private func keyboardWillHide(notification: NSNotification) {
        notetableView.contentInset = .zero
        notecollectionView.contentInset = .zero
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            notetableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height +  notetableView.rowHeight, right: 0)
            notecollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height +  notecollectionView.zoomScale, right: 0)
        }
        
    }
    
    func setup() {
        notetableView.delegate = self
        notetableView.dataSource = self
        notecollectionView.delegate = self
        notecollectionView.dataSource = self
        DispatchQueue.main.async {
            self.notetableView.reloadData()
            self.notecollectionView.reloadData()
        }
    }
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.product?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notetableView.dequeueReusableCell(withIdentifier:"coreTableViewCell", for: indexPath) as! coreTableViewCell
        let present = self.product![indexPath.row]
        cell.titleLabel?.text = present.title
        cell.contentLabel?.text = present.content
//        cell.backgroundColor = note[indexPath.row].colors
        let prod = present
        cell.configure(with: prod)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let present = self.product![indexPath.row]
            let alert = UIAlertController(title: "Edit", message: "edit name: ", preferredStyle: .alert)
        alert .addTextField()
        alert .addTextField()

        let titletextField = alert.textFields![0]
        let contenttextField = alert.textFields![1]
        titletextField.text = present.title
        contenttextField.text = present.content

        let saveButton = UIAlertAction(title: "Save", style: .default) {
            (action) in
            let titletextField = alert.textFields![0]
            let contenttextField = alert.textFields![1]

           present.title = titletextField.text
            present.content = contenttextField.text
            do {
                try self.context.save()
                

            }
            catch{
                
                
            }
            
            self.fetchProduct()
        }
        alert.addAction(saveButton)
        
        self.present(alert, animated: true, completion:  nil)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteaction = UIContextualAction(style: .destructive, title: "Delete") {  [self]  _, _, completionHandler  in
            
            let presentToRemove = self.product![indexPath.row]
//            self.notes.delete(presentToRemove)
//            self.notes.remove(at: indexPath.row)
            self.context.delete( presentToRemove )
            completionHandler(true)

            do {
                try self.context.save()
            }
            catch{
            
            }
            self.fetchProduct()
            self.notetableView.reloadData()
        }
        deleteaction.backgroundColor = .systemCyan
        let configuration = UISwipeActionsConfiguration(actions: [deleteaction])
        configuration.performsFirstActionWithFullSwipe = true
            let note = self.product![indexPath.row]
            let title = note.isPinned ? "Unpin" : "Pin"
            let action = UIContextualAction(style: .normal, title: title) { [weak self] _, _, completionHandler in
                guard let self = self else { return }
                var updatenote = note
                updatenote.isPinned.toggle()
                self.product![indexPath.row] = updatenote
                self.product = self.notes.sorted(by: {$0.isPinned && !$1.isPinned})
                self.notetableView.reloadData()
                completionHandler(true)
            do {
                try self.context.save()
            }
            catch{
        
            }
        self.fetchProduct()
        self.notetableView.reloadData()
            }
        action.backgroundColor = note.isPinned ?.gray: .orange
        action.image = note.isPinned ? UIImage(systemName: "pin.fil") : UIImage(systemName: "pin")
        return UISwipeActionsConfiguration(actions: [action,deleteaction])
    }

}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.product?.count ?? 0

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = notecollectionView.dequeueReusableCell(withReuseIdentifier: "coreCollectionViewCell", for: indexPath) as! coreCollectionViewCell
        let present = self.product![indexPath.item]
        cell.title?.text = present.title
        cell.bodytext?.text = present.content
//        cell.backgroundColor = note[indexPath.item].colors
        let prod = present
        cell.configure(with: prod)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let present = self.product![indexPath.item]
        let alert = UIAlertController(title: "Edit", message: "edit", preferredStyle: .alert)
        alert .addTextField()
        alert .addTextField()
        
        let titletextField = alert.textFields![0]
        let contenttextField = alert.textFields![1]
        titletextField.text = present.title
        contenttextField.text = present.content
        
        let saveButton = UIAlertAction(title: "save", style: .default) {
            (action) in
            let titletextField = alert.textFields![0]
            let contenttextField = alert.textFields![1]
            
            present.title =  titletextField.text
            present.content = contenttextField.text
            do {
                try self.context.save()
            }
            catch{
                
            }
            self.fetchProduct()
        }
        alert.addAction(saveButton)
        self.present(alert,animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width / 2 - 10
        return CGSize(width: width, height: 150)
    }
//    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
}

extension ViewController : BackgroundColorDelegate {
    func setBackgroundColor(color: Noted?) {
        guard let noted = color else {return}
        if let index = note.firstIndex(where: {$0.id == noted.id })
        {
            note[index] = noted
            DispatchQueue.main.async{
                self.notecollectionView.reloadData()
                self.notetableView.reloadData()
            }
        }
    }

}
