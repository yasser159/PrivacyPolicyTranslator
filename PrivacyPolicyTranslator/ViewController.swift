//
//  ViewController.swift
//  PrivacyPolicyTranslator
//
//  Created by Yasser Hajlaoui on 1/13/22.
//
import SwiftUI

class ViewController: NSViewController {

    @IBOutlet weak var txt_Input: NSTextField!
    @IBOutlet weak var txt_filePrefix: NSTextField!
    @IBOutlet weak var btn_generateFiles: NSButton!
    
    var languages = [String]()

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func CheckBoxManager(_ sender: NSButton) {

        let languageCode = getLanguageCode[sender.title] ?? "en"
        print("CheckBox Title: ", languageCode)
        
        switch sender.state {
        case .on:
            languages.append(languageCode)
        case .off:
            while let idx = languages.firstIndex(of: languageCode) {
                languages.remove(at: idx)
            }
        case .mixed:
            print("mixed")
        default: break
        }
        print("languages: ", languages)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func callAPI(_ sender: Any) {

        SwiftGoogleTranslate.shared.start(with: apiKey)
        
        for languageCode in languages {
            //print(languageCode)
            
            //Dynamic Translation:
            SwiftGoogleTranslate.shared.translate(txt_Input.stringValue, languageCode, "en") { (text, error) in
              if let t = text {
                print(t)
              }
            }
        }
    }
    
    @IBAction func GenerateFiles(_ sender: Any) {
                
        let stringToSave = Html_Top + txt_Input.stringValue + Html_Bottom
        let path = FileManager.default.urls(for: .downloadsDirectory,
                                            in: .userDomainMask)[0].appendingPathComponent("generated.html")

        if let stringData = stringToSave.data(using: .utf8) {
            try? stringData.write(to: path)
        }
    }
}// Last One

//Translation:

//            SwiftGoogleTranslate.shared.translate("Hello!", "es", "en") { (text, error) in
//              if let t = text {
//                print(t)
//              }
//            }
    
//            //Detection:
//
//            SwiftGoogleTranslate.shared.detect("¡Hola!") { (detections, error) in
//              if let detections = detections {
//                for detection in detections {
//                  print(detection.language)
//                  print(detection.isReliable)
//                  print(detection.confidence)
//                  print("---")
//                }
//              }
//            }
//
//            //A list of languages:

//            SwiftGoogleTranslate.shared.languages { (languages, error) in
//              if let languages = languages {
//                for language in languages {
//                  print(language.language)
//                  print(language.name)
//                  print("---")
//                }
//              }
//            }
