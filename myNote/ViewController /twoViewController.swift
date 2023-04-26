//
//  twoViewController.swift
//  myNote
//
//  Created by Mohan K on 04/04/23.
//

import UIKit

class twoViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var titletext: UITextField!
    @IBOutlet weak var contentText: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var placeholderLabel: UILabel!
    var product: [Product]?

    override func viewDidLoad() {
        super.viewDidLoad()
        titletext.becomeFirstResponder()
        placeholderLabel = UILabel()
        placeholderLabel.text = "Note"
        placeholderLabel.font = .italicSystemFont(ofSize: (contentText.font?.pointSize)!)
        contentText.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (contentText.font?.pointSize)! / 2)
        placeholderLabel.textColor = .tertiaryLabel
        placeholderLabel.isHidden = !contentText.text.isEmpty
//        self.contentText.delegate = self
        self.titletext.delegate = self
        self.contentText.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender: )))
        // Do any additional setup after loading the view.
    }
    
    @objc func tapDone(sender: Any) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titletext.resignFirstResponder()
        contentText.resignFirstResponder()
        return true
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        let newProduct = Product(context: self.context)
        let date = Date()
               let dateFormatter = DateFormatter()
               let dateString = dateFormatter.string(from: date)
               
        newProduct.title = titletext.text
        newProduct.text = contentText.text
                newProduct.dateString = dateString

        do {
            try self.context.save()
        }
        catch {
            print("error saving context : \(error)")

        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func textTitle(_ sender: Any) {
        
        
        
    }
}

//extension UITextView {
//    func addDoneButton(title: String, target: Any, selector: Selector) {
//        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
//                                              y: 0.0,
//                                              width: UIScreen.main.bounds.size.width, height: 44.0))
//        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
//        toolBar.setItems([flexible, barButton], animated: false)
//        self.inputAccessoryView = toolBar
//    }
//}

extension twoViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel?.isHidden = !contentText.text.isEmpty
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = !contentText.text.isEmpty
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = true
    }
}
