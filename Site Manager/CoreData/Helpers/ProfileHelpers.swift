//
//  ProfileHelpers.swift
//  Site Manager
//
//  Created by Samuel Wong on 11/2/2022.
//

import Foundation
import UIKit

class ProfileHelpers {
    static var profile: Profile? {
        get {
            do {
                return try CoreDataHelper.container.viewContext.fetch(Profile.fetchRequest()).first
            } catch {
                print(error)
                return nil
            }
        }
    }
    
    static func create(companyName: String, address1: String, suburb: String, state: String, postcode: String, phone: String, abn: String, logo: UIImage?) -> (profile: Profile?, error: Error?) {
        let profile = Profile(context: CoreDataHelper.context)
        
        profile.companyName = companyName
        profile.address1 = address1
        profile.suburb = suburb
        profile.state = state
        profile.postcode = postcode
        profile.phone = phone
        profile.abn = abn
        
        if let logo = logo {
            if let path = logo.saveImageToFileManager() {
                profile.logoPath = path
            }
        }
        
        do {
            try CoreDataHelper.context.save()
            return (profile, nil)
        } catch {
            print(error)
            return (nil, error)
        }
    }
}

extension Profile {
    func update() -> Error? {
        do {
            try CoreDataHelper.context.save()
            return nil
        } catch {
            print(error)
            return error
        }
    }
    
    var logo: UIImage? {
        get {
            if let logoPath = self.logoPath {
                return UIImage.loadImageFromDiskWith(fileName: logoPath)
            }
            
            return nil
        }
    }
}
