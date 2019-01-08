//
//  LocalStorage.swift
//  Gather
//
//  Created by Yogesh Kumar on 28/11/18.
//  Copyright © 2018 Tilicho Labs. All rights reserved.
//

import Foundation


enum FolderName :String {
    case PlanetPath
    func createFolder(directory : FileManager.SearchPathDirectory) -> URL{
        let folderPath = self.folderPath(directory: directory)
        try? FileManager.default.createDirectory(atPath: folderPath.path, withIntermediateDirectories: true, attributes: nil)
        return folderPath
    }
    
    func folderPath(directory : FileManager.SearchPathDirectory)-> URL {
        let paths = FileManager.default.urls(for: directory, in: .userDomainMask)
        let folderPath = paths[0].appendingPathComponent(self.rawValue)
        return folderPath
    }
    


    func getFilePath(fileName:String , directory : FileManager.SearchPathDirectory) -> URL{
        let folderPath =  self.folderPath(directory: directory)
        return folderPath.appendingPathComponent(fileName)
    }
    
    func clearStorage(directory : FileManager.SearchPathDirectory){
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: self.folderPath(directory: directory).path)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
}




