//
//  TextLog.swift
//  Contacts
//
//  Created by Saransh Mittal on 13/12/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation


struct TextLog: TextOutputStream {
    mutating func write(_ string: String) {
        print(string)
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)
//        let documentDirectoryPath = paths.first!
//        let log = documentDirectoryPath.appendingPathComponent("logs.txt")
//        do {
//            let handle = try FileHandle(forWritingTo: log)
//            handle.seekToEndOfFile()
//            handle.write(string.data(using: .utf8)!)
//            handle.closeFile()
//        } catch {
//            print(error.localizedDescription)
//            do {
//                try string.data(using: .utf8)?.write(to: log)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
    }
}
