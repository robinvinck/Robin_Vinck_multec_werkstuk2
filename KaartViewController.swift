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
    var managedContext:NSManagedObjectContext?
    var opgehaaldeStations:[Station] = []
    let preferredLanguage = NSLocale.preferredLanguages[0]
    
    @IBOutlet weak var refreshdate: UILabel!
    
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        DispatchQueue.global(qos: .background).async {
            
            
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                try managedContext.execute(request)
                try managedContext.save()
            } catch {
                print("code catched testview")
            }
            
            
            DispatchQueue.main.async {
                let allAnnotations = self.myMapView.annotations
                self.myMapView.removeAnnotations(allAnnotations)
               
                self.loadData()
             
                
            }
            
        }
    }
    
    func giveDate() -> String {
        //geeft datum terug
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy' - 'HH:mm:ss"
        return formatter.string(from: date)
    }
    
    
    var locationManager = CLLocationManager()
    @IBOutlet weak var myMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        self.myMapView.delegate = self
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            loadMap()
            print("not first launch")
            
        } else {
            print("first launch")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            loadData()
        }
        
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
       
        

    }
    
    func loadMap(){
        //laad specifiek map met annotations
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let stationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        self.refreshdate.text = self.giveDate()
        do{
            opgehaaldeStations = try managedContext.fetch(stationFetch) as! [Station]
            for villoElement in opgehaaldeStations {
                let location = CLLocationCoordinate2D(latitude: villoElement.lattitude, longitude: villoElement.longtitude)
                
                let fileArray = makeSnippet(elementName: villoElement.name!, separator: "/")
                let adresArray = makeSnippet(elementName: villoElement.address!, separator: "/")
                //geen eenduidige taal, steeds verschillen in opmaak van adressen.
                if preferredLanguage.contains("en") {
                    
                    let fileArray2 = makeSnippet(elementName: fileArray.first!, separator: "-")
                   
                    let pin = MyAnnotation(coordinate: location, title: fileArray2.last, subtitle: villoElement.address, number: villoElement.number)
                    myMapView.addAnnotation(pin)
                    
                } else if preferredLanguage.contains("nl") {
                    //nederlands wordt wel goed gefilterd
                    let naamArray2 = makeSnippet(elementName: fileArray.last!, separator: "-")
                    let pin = MyAnnotation(coordinate: location, title: naamArray2.last, subtitle: adresArray.last, number: villoElement.number)
                    myMapView.addAnnotation(pin)
                }
            }
            
            
        } catch {
            fatalError("Failedtofetchemployees: \(error)")
            
        }
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
        annotationView.image = UIImage(named: "location")
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
                self.performSegue(withIdentifier: "naarDetailPagina", sender: annotation.number)
            }
        }
    }
    
    
    //pass param https://stackoverflow.com/questions/35398309/how-to-pass-parameters-when-performing-a-segue-using-performseguewithidentifier?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "naarDetailPagina"{
            let vc = segue.destination as! DetailViewController
            vc.temp = sender as! Int64
            //Data has to be a variable name in your RandomViewController
        }
    }
    
    func loadData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        managedContext = appDelegate.persistentContainer.viewContext
        
        // Do any additional setup after loading the view, typically from a nib.
        let url = URL(string: "https://api.jcdecaux.com/vls/v1/stations?apiKey=6d5071ed0d0b3b68462ad73df43fd9e5479b03d6&contract=Bruxelles-Capitale")
        let urlRequest = URLRequest(url: url!)
        let session = URLSession(configuration:
            URLSessionConfiguration.default)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for errors
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            
            do {
                
                guard let villoData = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [AnyObject] else {
                    print("failed JSONSerialization")
                    return
                }
                
                
                
                
                for villoElement in villoData! {
                    
                    let villoStation = NSEntityDescription.insertNewObject(forEntityName: "Station", into: self.managedContext!) as! Station
                    
                    var element = villoElement as! [String: AnyObject]
                    
                    villoStation.number = element["number"]! as! Int64

                    
                    villoStation.name = (element["name"]! as! String)

                    villoStation.address = (element["address"] as! String)
   
                    villoStation.status = (element["status"] as! String)

                    let positie = element["position"] as? [String: AnyObject]
                    let lat = positie!["lat"]!

                    let lng = positie!["lng"]!
         
                    
                    villoStation.longtitude = lng as! Double
                    
                    villoStation.lattitude = lat as! Double
                    
                    villoStation.bike_stands = element["bike_stands"]! as! Int64

                    villoStation.available_bike_stands = element["available_bike_stands"]! as! Int64
          
                    villoStation.available_bikes = element["available_bikes"] as! Int64
                    
                }
                
                DispatchQueue.main.async {
                    self.loadMap()
                }
                try self.managedContext?.save()
            }
                
                
            catch {
                
            }
            
            
        }
        
        task.resume()
        
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


