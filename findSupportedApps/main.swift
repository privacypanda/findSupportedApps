//
//  main.swift
//  findSupportedApps
//
//  Created by Daniel Bates on 27/05/2021.
//

import Foundation
import UniformTypeIdentifiers

typealias FilterParams = (directory: String, type: String)

//Parse command line arguments and ensure we have what we need to continue

func runApplication(withArgs: [String]) -> Int32 {
    
    //First argument is path to executable so dump it
    args.removeFirst()

    if args.count != 4 {
        print("Incorrect arguments supplied")
        print("USAGE: findSupportedApps -d /path/to/folder -t example.txt")
        return EXIT_FAILURE
    }
    
    guard let params = validateParams(args: args) else {
        return EXIT_FAILURE
    }
    
    print(params)
    
    
    guard let searchDirectory = ApplicationDirectory(withPathString: params.directory) else {
        return EXIT_FAILURE
    }
    
    let applications = searchDirectory.getApplicationsForFileType(fileType: params.type)
    
    if applications.isEmpty {
        print("No applications in the \(params.directory) will open the requested file type")
    } else {
        applications.forEach {
            print($0)
        }
    }
    
    return EXIT_SUCCESS
}


func validateParams(args: [String]) -> FilterParams? {
    
    //Now check we have the required args
    var targetDirectory: String?

    var fileType: String?

    for (index, element) in args.enumerated() {
        //If we are on the penultimate index then break
        if index + 1 == args.count {
            break
        }
        switch element {
        case "-d":
            print("-d found, directory path is: \(args[index + 1])")
            targetDirectory = args[index + 1]
            break
        case "-t":
            print("-t found, file type is \(args[index + 1])")
            fileType = args[index + 1]
            break
        default:
            break
        }
    }
    
    guard targetDirectory != nil, fileType != nil else {
        return nil
    }
    
    if fileType!.hasPrefix(".") {
        fileType!.remove(at: fileType!.startIndex)
    }
    var fileExtension =  UTType.types(tag: fileType!, tagClass: .filenameExtension, conformingTo: nil).first?.identifier
    
    if fileExtension == nil {
        fileExtension = UTType(fileType!)?.identifier ?? fileType
    }
    
    return FilterParams(targetDirectory!, fileExtension!)
    
}

var args: [String] = CommandLine.arguments

exit(runApplication(withArgs: args))















