//
//  TextManipulationTools.swift
//  PrivacyPolicyTranslator
//
//  Created by Yasser Hajlaoui on 1/21/22.
//

import Foundation

//this is a workaround google translate's 5000 Character limit
func paragraphsSplitter(input: String,characterLimit: Int, splitterString: String)->[String]{

    let inputText = input
    var under5KWord = ""
    var myParaghraphs = [""]
    var components = inputText.components(separatedBy: splitterString) //Split The HTML Over </p> paraghraps
    
    
    for (index, _) in components.enumerated() {
        if index < components.count - 1 {
            components[index].append(splitterString)
        }
    }

    for paraghraph in components{
        
        if ((under5KWord.count + paraghraph.count)<4500)
        {
            under5KWord += paraghraph
        } else {//                               paragraph > 4500
            myParaghraphs.append(under5KWord)
            under5KWord = paraghraph
        }
    }
    myParaghraphs.append(under5KWord)

//                print("elements in myParaghraphs: ", myParaghraphs.count)
//                print(myParaghraphs)
    return myParaghraphs
}
