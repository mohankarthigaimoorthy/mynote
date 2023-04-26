//
//  oneCollectionViewCell.swift
//  myNote
//
//  Created by Mohan K on 05/04/23.
//
import Foundation
import UIKit
import CoreData

class oneCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var bodyContent: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var pinFunc: UIButton!
    
    var product : [Product]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let newDate = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as! Product
        newDate.date = Date()
        do {
            try context.save()
        }
        catch {
            print("Error saving date:\(error.localizedDescription)")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
   }
    
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func configr(with prod: Product?) {
        let request : NSFetchRequest<Product> = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let dates = try context.fetch(request)
            if let mostRecentDate = dates.first {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                date.text = dateFormatter.string(from: mostRecentDate.date!)
                
            }
        }
        catch {
            
                    print ("Error fetching dates : \(error.localizedDescription)")
        }
        if prod?.isPinned == true {
            pinFunc.alpha = 1
            pinFunc.setImage(UIImage(systemName: "pin.fil"), for: .normal)
        }
        
        else{
            pinFunc.alpha = 0
            pinFunc.setImage(UIImage(systemName: "pin"), for: .normal)
        }
    }
   
    @IBAction func pinBtnFunc(_ sender: Any) {
    }
}
