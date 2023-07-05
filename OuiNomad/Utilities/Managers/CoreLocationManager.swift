//
//  CoreLocationManager.swift
//  OuiNomad
//
//  Created by Nicolas Lucchetta on 02/07/2023.
//

import MapKit

class CoreLocationManager {
    func geocodeAddress(address: String, zipCode: String, country: String, completion: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
        let geocoder = CLGeocoder()
        let addressString = "\(address), \(zipCode), \(country)"
        
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let placemark = placemarks?.first,
               let location = placemark.location {
                completion(location.coordinate, nil)
            } else {
                completion(nil, nil)
            }
        }
    }
}








