//
//  Error + Utilities.swift
//  DriveIt
//
//  Created by Samuel Wong on 3/6/20.
//  Copyright © 2020 xPhase. All rights reserved.
//

import Foundation

extension NSError {
    static func standardErrorWithString(errorString: String) -> NSError {
        return NSError(domain: Bundle.main.bundleIdentifier!, code: 0, userInfo: [NSLocalizedDescriptionKey : errorString])
    }
    
    static func standardNoDataError() -> NSError {
        return NSError.standardErrorWithString(errorString: "No data was returned from the server")
    }
}
