//
//  KaartViewController.swift
//  Robin_Vinck_multec_werkstuk2
//
//  Created by Robin Vinck on 3/05/18.
//  Copyright © 2018 Robin Vinck. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


class KaartViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    var opgehaaldeStations:[Station] = []
    
    var locationManager = CLLocationManager()
    @IBOutlet weak var myMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let stationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        
        do{
            opgehaaldeStations = try managedContext.fetch(stationFetch) as! [Station]
            
            
            for villoElement in opgehaaldeStations {
                let location = CLLocationCoordinate2D(latitude: villoElement.lattitude, longitude: villoElement.longtitude)
               
                
                
                let myAnnotation = MyAnnotation(coordinate: location, title: villoElement.name, message: villoElement.address)
                self.myMapView.addAnnotation(myAnnotation)
            }
            
            
        } catch {
            fatalError("Failedtofetchemployees: \(error)")
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    
   // bron: //https://stackoverflow.com/questions/39206418/how-can-i-detect-which-annotation-was-selected-in-mapview?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Annotation selected")
        
        if let annotation = view.annotation as? MyAnnotation {
            //print(annotation.title!);
            let ac = UIAlertController(title: annotation.title!, message: annotation.message, preferredStyle: .alert)
            //ac.addAction(UIAlertAction(title: "OK", style: .default))
            let gaVerder = UIAlertAction(title: "OK", style: .default, handler: { action in self.performSegue(withIdentifier: "test", sender: self)})
            ac.addAction(gaVerder)
            ac.addAction(UIAlertAction(title: "Ga terug", style: .cancel))
            present(ac, animated: true)
            
        }
    }
    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let capital = view.annotation as! MyAnnotation
//        let placeName = capital.title
//        //let placeInfo = capital.info
//        
//        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .default))
//        present(ac, animated: true)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
