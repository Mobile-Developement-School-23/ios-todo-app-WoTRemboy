//
//  File.swift
//  School_ToDoList
//
//  Created by Roman Tverdokhleb on 30.06.2023.
//

import UIKit
import CocoaLumberjackSwift

class MyLogFormatter: NSObject, DDLogFormatter {
    
    func format(message logMessage: DDLogMessage) -> String? {
        let logLevel = logMessage.level
        var logLevelString = "Error to init level"
        
        switch logLevel {
        case .error:
            logLevelString = "Error"
        case .warning:
            logLevelString = "Warning"
        case .info:
            logLevelString = "Info"
        case .debug:
            logLevelString = "Debug"
        case .verbose:
            logLevelString = "Verbose"
        case .off:
            logLevelString = "Off"
        case .all:
            logLevelString = "All"
        @unknown default:
            logLevelString = "Error to init level"
        }
            
        let logText = logMessage.message
        return "<\(logLevelString)> - \(logText)"
    }
}
