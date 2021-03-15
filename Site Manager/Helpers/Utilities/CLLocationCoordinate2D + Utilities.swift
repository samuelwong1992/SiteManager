//
//  CLLocationCoordinate2D + Utilities.swift
//  DriveIt
//
//  Created by Samuel Wong on 11/6/20.
//  Copyright © 2020 xPhase. All rights reserved.
//

import MapKit

extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}
