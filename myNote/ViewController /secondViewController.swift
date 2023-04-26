//
//  secondViewController.swift
//  myNote
//
//  Created by Mohan K on 05/04/23.
//

import UIKit
import CoreData

class secondViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var titlText: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
   
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var placeholderLabel: UILabel!
    var product: [Product]?

    override func viewDidLoad() {
        super.viewDidLoad()

        titlText.becomeFirstResponder()
        placeholderLabel = UILabel()
        placeholderLabel.text = "Note"
        placeholderLabel.font = .italicSystemFont(ofSize: (bodyTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        bodyTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (bodyTextView.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !bodyTextView.text.isEmpty
        self.bodyTextView.delegate = self
        self.titlText.delegate = self
        self.bodyTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
//        setupCollection()
        // Do any additional setup after loading the view.
    }
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titlText.resignFirstResponder()
   bodyTextView.resignFirstResponder()
        return true
    }
    @IBAction func noteTitleText(_ sender: Any) {
    }
    
    @IBAction func doneButton(_ sender: Any) {
        
        let newProduct = Product(context: self.context)
        let date = Date()
        let dateFormatter = DateFormatter()
        let dateString = dateFormatter.string(from: date)
        newProduct.title = titlText.text
        newProduct.text = bodyTextView.text
        newProduct.dateString = dateString
        do {
            try self.context.save()
        }
        catch {
            print("error saving context : \(error)")
        }
    }    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UITextView {
    func addDoneButton(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}

extension secondViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !bodyTextView.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !bodyTextView.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = true
    }
}
