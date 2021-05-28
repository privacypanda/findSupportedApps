//
//  ApplicationDirectory.swift
//  findSupportedApps
//
//  Created by Daniel Bates on 27/05/2021.
//

import Foundation

class ApplicationDirectory {
    
    private var directoryString: String
    
    private var applications: [String] = []
    
    init?(withPathString string: String) {
        self.directoryString = string
        var contents: [String]?
        do {
            contents = try FileManager.default.contentsOfDirectory(atPath: self.directoryString)
        } catch let err {
            print("Error getting contents of directory!: \(err)")
            return nil
        }
        
        guard let directoryContents = contents,
              !directoryContents.isEmpty else {
            print("Directory is empty!")
            return nil
        }
        
        self.applications = directoryContents.filter{
            $0.contains(".app")
        }.map {
            return self.directoryString.appending("/\($0)")
        }
    }
    
    
    func getApplicationsForFileType(fileType type: String) -> [String] {
        
        var supportedApplications: [String] = []
        
        self.applications.forEach { bundle in
            let bundle = Bundle(path: bundle)
            guard let plist = bundle?.infoDictionary,
                  let metadata = ApplicationMetadata(dictionary: plist) else {
                return
            }
            
            let result = metadata.supportedDocumentTypes.flatMap {
                $0.lsItemContentTypes
            }.filter {
                $0 == type
            }
            
            if !result.isEmpty {
                supportedApplications.append(metadata.displayName)
            }
        }
        return supportedApplications
    }
}
