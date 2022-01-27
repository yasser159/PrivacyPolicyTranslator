//
//  TextFile_IO.swift
//  File IO
//
//  Created by Yasser Hajlaoui on 1/24/22.
//

import Foundation

func getPath(fileName_: String)->String{
  let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
  var filePath = ""
    
  if dirs.count > 0 {
      let dir = dirs[0] //documents directory
      filePath = dir.appending("/" + fileName_)
  } else {
      print("Could not find local directory to store file")
  }
    return filePath
}

func saveTextFile(fileName_: String, text_:String){
    let filePath = getPath(fileName_: fileName_)
    
    do {
        try text_.write(toFile: filePath, atomically: false, encoding: String.Encoding.utf8)
    }
    catch let error as NSError {
        print("An error while saving occured: \(error)")
    }
}

func loadTextFile(fileName_: String)->String{
    let filePath = getPath(fileName_: fileName_)
    var text = ""
    
    do {
        let contentFromFile = try NSString(contentsOfFile: filePath, encoding: String.Encoding.utf8.rawValue)
        text = String(contentFromFile)
    }
    catch let error as NSError {
        print("An error while loading textFile occured: \(error)")
    }
    return text
}

