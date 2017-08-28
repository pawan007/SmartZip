//
//  LogManager.swift
//
//  Created by Pawan Kumar on 02/06/16.
//  Copyright © 2016 Modi. All rights reserved.
//

import Foundation
import XCGLogger

class LogManager: NSObject {
    
    let log: XCGLogger = {
        // Setup XCGLogger
        let log = XCGLogger.defaultInstance()
        log.xcodeColorsEnabled = true // Or set the XcodeColors environment variable in your scheme to YES
        log.xcodeColors = [
            .Verbose: .lightGrey,
            .Debug: .darkGrey,
            .Info: .darkGreen,
            .Warning: .orange,
            .Error: XCGLogger.XcodeColor(fg: UIColor.redColor(), bg: UIColor.whiteColor()), // Optionally use a UIColor
            .Severe: XCGLogger.XcodeColor(fg: (255, 255, 255), bg: (255, 0, 0)) // Optionally use RGB values directly
        ]
        
        return log
    }()
    
    // MARK: - Singleton Instance
    fileprivate static let _sharedManager = LogManager()
    
    class func sharedManager() -> LogManager {
        return _sharedManager
    }
    
    fileprivate override init() {
        super.init()
    }
    
    // MARK: - Setup methods
    class func setup(_ logLevel: XCGLogger.LogLevel = .Debug, showLogLevel: Bool = true, showFunctionName: Bool = true, showThreadName: Bool = false, showFileName: Bool = true, showLineNumber: Bool = true, writeToFile: Bool = false) {
        
        LogManager.sharedManager().setup(logLevel, showLogLevel: showLogLevel, showFunctionName: showFunctionName, showThreadName: showThreadName, showFileName: showFileName, showLineNumber: showLineNumber, writeToFile: writeToFile)
    }
    
    func setup(_ logLevel: XCGLogger.LogLevel = .Debug, showLogLevel: Bool = true, showFunctionName: Bool = true, showThreadName: Bool = false, showFileName: Bool = true, showLineNumber: Bool = true, writeToFile: Bool = false) {
        
        #if USE_NSLOG // Set via Build Settings, under Other Swift Flags
            
            self.log.removeLogDestination(XCGLogger.Constants.baseConsoleLogDestinationIdentifier)
            self.log.addLogDestination(XCGNSLogDestination(owner: self.log, identifier: XCGLogger.Constants.nslogDestinationIdentifier))
            self.log.logAppDetails()
            
        #else
            
            var logPath: URL? = nil
            
            if writeToFile {
                // create a log file name using current date
                let fileName: String = "Log-\(Date().formattedString()).txt"
                logPath = cacheDirectoryURL.appendingPathComponent(fileName)
            }
            
            self.log.setup(logLevel, showThreadName: showThreadName, showFunctionName: showFunctionName, showLogLevel: showLogLevel, showFileNames: showFileName, showLineNumbers: showLineNumber, writeToFile: logPath)

        #endif
    }
    
    
    // MARK: - Write log
    fileprivate func writeLog(_ logLevel: XCGLogger.LogLevel, closure: @autoclosure () -> String?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        // self.log.logln(logLevel, functionName: functionName, fileName: fileName, lineNumber: lineNumber, closure: closure)
    }
}

// MARK: - Helpers for Logging
extension LogManager {
    
    class func logDebug(_ closure: @autoclosure () -> String?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(.Debug, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func logInfo(_ closure: @autoclosure () -> String?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(.Info, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func logWarning(_ closure: @autoclosure () -> String?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(.Warning, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func logError(_ closure: @autoclosure () -> String?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(.Error, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func logSevere(_ closure: @autoclosure () -> String?, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(.Severe, closure: closure, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func logEntry(_ functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(.Debug, closure: "ENTRY", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
    
    class func logExit(_ functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        LogManager.sharedManager().writeLog(.Debug, closure: "EXIT", functionName: functionName, fileName: fileName, lineNumber: lineNumber)
    }
}
