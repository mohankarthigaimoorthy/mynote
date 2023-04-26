//
//  noteTableViewCell.swift
//  myNote
//
//  Created by Mohan K on 04/04/23.
//
import Foundation
import UIKit
import CoreData

class noteTableViewCell: UITableViewCell {

    @IBOutlet weak var text1: UILabel!
    @IBOutlet weak var text2: UILabel!
    @IBOutlet weak var text3: UILabel!
    @IBOutlet weak var buttonPin: UIButton!
  
    var prod : [Product]? = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let newDate = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context) as! Product
        do {
            try context.save()
        }
        catch {
            print("Error saving date:\(error.localizedDescription)")
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(with prod: Product?) {
//        let request : NSFetchRequest<Product> = Product.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
//        do {
//            let dates = try context.fetch(request)
//            if let mostRecentDate = dates.first {
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateStyle = .medium
//                dateFormatter.timeStyle = .none
//                text3.text = dateFormatter.string(from: mostRecentDate.date!)
//            }
//        }
//        catch {
//            print ("Error fetching dates : \(error.localizedDescription)")
//        }
        if prod?.isPinned == true {
            buttonPin.alpha = 1
            buttonPin.setImage(UIImage(systemName: "pin.fill"), for: .normal)
        }
        else {
            buttonPin.alpha = 1
            buttonPin.setImage(UIImage(systemName: "pin"), for: .normal)
        }
    }
    @IBAction func pinButn(_ sender: Any) {
        
        
    }
}
