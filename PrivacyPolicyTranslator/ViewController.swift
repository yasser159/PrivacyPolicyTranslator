//
//  ViewController.swift
//  PrivacyPolicyTranslator
//
//  Created by Yasser Hajlaoui on 1/13/22.
//
import SwiftUI

class ViewController: NSViewController {

    @IBOutlet weak var txt_input: NSTextField!
    @IBOutlet weak var txt_filePrefix: NSTextField!
    @IBOutlet weak var btn_generateFiles: NSButton!
    @IBOutlet weak var chkbx_french: NSButtonCell!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    var languages = [String]()
    
    @IBOutlet weak var useTestData: NSButtonCell!
    
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Secret", ofType: "plist") else {
                    fatalError("Couldn't find file 'Config.plist'.")
        }
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                    fatalError("Couldn't find key 'API_KEY' in 'Secret.plist'.")
            }
            return value
        }
    }
    
    @IBAction func useTestDataClicked(_ sender: Any) {
        checkIf_UsingTestData()
    }
    
    func checkIf_UsingTestData(){
        if useTestData.state == .on {
            txt_input.stringValue = Html_testData
            //processCheckboxes(language: "fr", checkBoxState: NSControl.StateValue.on)
            //chkbx_french.state = NSControl.StateValue.on
        }else {
            txt_input.stringValue = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIf_UsingTestData()
        
    }

    @IBAction func CheckBoxManager(_ sender: NSButton) {
        processCheckboxes(language: sender.title, checkBoxState: sender.state)
    }
    
    func processCheckboxes(language: String, checkBoxState: NSControl.StateValue){
        
        let  languageCode = dict_languageCodes[language] ?? "en"
        
            switch checkBoxState {
            case .on:
                languages.append(languageCode)
            case .off:
                while let idx = languages.firstIndex(of: languageCode) {
                    languages.remove(at: idx)
                }
            case .mixed:
                print("check box was set to mixed")
            default: break
            }
    }
    
    
    override var representedObject: Any? {
        didSet {  // Update the view, if already loaded.
        }
    }
    
@IBAction func GenerateFiles(_ sender: Any) {
    SwiftGoogleTranslate.shared.start(with: apiKey)
    
    
   for languageCode in languages {
       
               if languageCode == "en" {  //if english print and Exit, No translation needed
                   saveTranslationToFile(prefix: self.txt_filePrefix.stringValue, languageCode: languageCode, translatedText: txt_input.stringValue )
                   return
               }
       
               var translatedTotal = ""
               let inputText = txt_input.stringValue
       
               var components = inputText.components(separatedBy: "</p>") //Split The HTML Over </p> paraghraps
               for (index, _) in components.enumerated() {
                   if index < components.count - 1 {
                       components[index].append("</p>")
                   }
               }
       
       
       
       
              
       let progressBar_Increment = Double(100/components.count)
       
              print("components.count:  ", components.count)
              print("progressBar_Increment: ",progressBar_Increment)
       
               var progress = 0.0
               progressBar.doubleValue = progress
       
               for paraghraph in components {
                   SwiftGoogleTranslate.shared.translate(paraghraph, languageCode, "en") { (text, error) in
                                                   if  let translatedText = text {
                                                    translatedTotal.append(contentsOf: translatedText)
                                                           //print(translatedText)
                                                   }
                                            }
           
                       //print(paraghraph)
                       let second: Double = 1000000
                       usleep(useconds_t(0.2 * second)) // Sleep for 200 milliseconds
                   
                       // Progress Bar Increments:
                       progress += progressBar_Increment
                       print(progress)
                       self.progressBar.doubleValue = progress
                       }
       
        //print(translatedTotal)
       
        let filePrefix = self.txt_filePrefix.stringValue
        self.saveTranslationToFile(prefix: filePrefix, languageCode: languageCode, translatedText: translatedTotal)
       
       progress = 100.0
       progressBar.doubleValue = progress
        }
}

    func saveTranslationToFile(prefix: String, languageCode: String, translatedText: String ){
        let myLanguage    = dict_languageCodes.someKey(forValue: languageCode) ?? "Default"
        let stringToSave  = getHtml(languageCode: languageCode, contentBody: translatedText)
        let fileName      = prefix + "-" + myLanguage + ".html"
        let path          = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        if let stringData = stringToSave.data(using: .utf8) { try? stringData.write(to: path)}
    }
    
}// Last Bracket
extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
