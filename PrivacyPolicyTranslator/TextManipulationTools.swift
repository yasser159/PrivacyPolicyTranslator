//
//  TextManipulationTools.swift
//  PrivacyPolicyTranslator
////this is a workaround google translate's 5000 Character limit
/////  Created by Yasser Hajlaoui on 1/21/22.

import Foundation

func paragraphsSplitter(input: String,characterLimit: Int, splitterString: String)->[String]{

    let inputText = input
    var withinTreshhold = ""
    var myParaghraphs = [""]
    var components = inputText.components(separatedBy: splitterString) //Split The HTML Over </p> paraghraps
    
    
    for (index, _) in components.enumerated() {
        if index < components.count - 1 {
            components[index].append(splitterString)
        }
    }

    for paraghraph in components{
        
        if ((withinTreshhold.count + paraghraph.count) < characterLimit)
        {
            withinTreshhold += paraghraph
        } else {//                               paragraph > characterLimit
            myParaghraphs.append(withinTreshhold)
            withinTreshhold = paraghraph
        }
    }
    myParaghraphs.append(withinTreshhold)
    
    return myParaghraphs
}
