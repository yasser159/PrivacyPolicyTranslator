//
//  ViewController.swift
//  PrivacyPolicyTranslator
//
//  Created by Yasser Hajlaoui on 1/13/22.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var txt_Input: NSTextField!
    @IBOutlet weak var btn_generateFiles: NSButton!
    
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Secret", ofType: "plist") else {
                    fatalError("Couldn't find file 'Config.plist'.")
        }
     
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API-Key") as? String else {
                    fatalError("Couldn't find key 'API-Key' in 'Secret.plist'.")
            }
            return value
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    @IBAction func GenerateFiles(_ sender: Any) {
                
        let stringToSave = Html_Top + txt_Input.stringValue + Html_Bottom
        let path = FileManager.default.urls(for: .downloadsDirectory,
                                            in: .userDomainMask)[0].appendingPathComponent("generated.html")

        if let stringData = stringToSave.data(using: .utf8) {
            try? stringData.write(to: path)
        }
       print("File Saved: ", path)
       // print("api key:", apiKey)
        
    }
}
