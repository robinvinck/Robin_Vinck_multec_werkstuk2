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
        let preferredLanguage = NSLocale.preferredLanguages[0]
        print(preferredLanguage)
        
        self.myMapView.delegate = self
        
        
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
                
                let fileArray = makeSnippet(elementName: villoElement.name!, separator: "/")
                
               
                
                if preferredLanguage == "en-US" {
                    print("this is English")
                   let fileArray2 = makeSnippet(elementName: fileArray.first!, separator: "-")
                    let pin = MyAnnotation(coordinate: location, title: fileArray2.last, subtitle: villoElement.address, number: villoElement.number)
                    myMapView.addAnnotation(pin)
                   
                } else if preferredLanguage == "nl-US" {
                  let pin = MyAnnotation(coordinate: location, title: fileArray.last, subtitle: villoElement.address, number: villoElement.number)
                    myMapView.addAnnotation(pin)
                }
                
               
                
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
    
    func makeSnippet(elementName:String, separator:String) -> [String]{
        let snippet = elementName
        let fileName = snippet
        let fileArray = fileName.components(separatedBy: separator)
        return fileArray
    }
    
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    // https://www.youtube.com/watch?v=Tt-cIKKuCGA
    // https://stackoverflow.com/questions/40478120/mkannotationview-swift-adding-info-button?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        annotationView.image = UIImage(named: "position")
        annotationView.canShowCallout = true
        let callOutButton = UIButton(type: .detailDisclosure)
        annotationView.rightCalloutAccessoryView = callOutButton
        annotationView.sizeToFit()
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            print("button tapped")
            if let annotation = view.annotation as? MyAnnotation {
                self.performSegue(withIdentifier: "test", sender: annotation.number)
            }
            
            
            
        }
    }
    
    
    //pass param https://stackoverflow.com/questions/35398309/how-to-pass-parameters-when-performing-a-segue-using-performseguewithidentifier?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "test"{
            let vc = segue.destination as! DetailViewController
            vc.temp = sender as! Int64
            //Data has to be a variable name in your RandomViewController
        }
    }
    
    
    // bron: //https://stackoverflow.com/questions/39206418/how-can-i-detect-which-annotation-was-selected-in-mapview?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    
    //    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    //        print("Annotation selected")
    //
    //        if let annotation = view.annotation as? MyAnnotation {
    //            //print(annotation.title!);
    //            let ac = UIAlertController(title: annotation.title!, message: annotation.subtitle, preferredStyle: .alert)
    //            //ac.addAction(UIAlertAction(title: "OK", style: .default))
    //            let gaVerder = UIAlertAction(title: "OK", style: .default, handler: { action in self.performSegue(withIdentifier: "test", sender: self)})
    //            ac.addAction(gaVerder)
    //            ac.addAction(UIAlertAction(title: "Ga terug", style: .cancel))
    //            present(ac, animated: true)
    //
    //        }
    //    }
    
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
