//
//  MyAnnotation.swift
//  Robin_Vinck_multec_werkstuk2
//
//  Created by Robin Vinck on 3/05/18.
//  Copyright © 2018 Robin Vinck. All rights reserved.

import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var number: Int64?
    
    init(coordinate: CLLocationCoordinate2D, title:String?, subtitle:String?, number:Int64?){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.number = number
    }
    
}

