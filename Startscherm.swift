//
//  ViewController.swift
//  Robin_Vinck_multec_werkstuk2
//
//  Created by Robin Vinck on 30/04/18.
//  Copyright © 2018 Robin Vinck. All rights reserved.
//

import UIKit
import CoreData


class Startscherm: UIViewController {
     var managedContext:NSManagedObjectContext?
  
   
    override func viewDidLoad() {
        super.viewDidLoad()
     
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
            
           // print(responseData);
            
          
          let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
          privateMOC.parent = self.managedContext
          
          privateMOC.perform {
            do {
                
                guard let villoData = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [AnyObject] else {
                    print("failed JSONSerialization")
                    return
                }

               //var villoDataLengte:int = villoData?.count
               
              
               for villoElement in villoData! {
                    
                    let villoStation = NSEntityDescription.insertNewObject(forEntityName: "Station", into: self.managedContext!) as! Station
                    
                    print(villoStation)
                    var element = villoElement as? [String: AnyObject]
                    
                    villoStation.number = element!["number"]! as! Int16
                    print(element!["number"]!)
                    
                    villoStation.name = element!["name"]! as? String
                    print(element!["name"]!)
                    villoStation.address = element!["address"]! as? String
                    print(element!["address"]!)
                    
                    //enter position
                    let positie = element!["position"] as? [String: AnyObject]
                    let lat = positie!["lat"]!
                    print(positie!["lat"]!)
                    let lng = positie!["lng"]!
                    print(positie!["lng"]!)
                    
                    villoStation.longtitude = lng as! Double
                    
                    villoStation.lattitude = lat as! Double
                    
                    villoStation.bike_stands = element!["bike_stands"]! as! Int16
                    print(element!["bike_stands"]!)
                    villoStation.available_bike_stands = element!["available_bike_stands"]! as! Int16
                    print(element!["available_bike_stands"]!)
                    villoStation.available_bikes = element!["available_bikes"]! as! Int16
                     print(element!["available_bikes"]!)
               
                    
                    do {
                         try self.managedContext?.save()
                    }
                    catch{fatalError("Failure tosave context: \(error)")}
                    
                    
//               for(index, villoElement) in (villoData?.enumerated())!{
//                    //print("\(index): \(villoElement)")
//                    let eersteElementArray = villoElement as? [String: AnyObject]
//                    let positie = eersteElementArray!["position"] as? [String: AnyObject]
//                    let lat = positie!["lat"]
//                    print(positie)
//                    print(lat)
//               }
               }
                
                DispatchQueue.main.async {
                    
                    
                         
//                         let elementFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
//
//                         do{
//                              element = try managedContext.fetch(elementFetch) as! [Station]
//                              print(element![0].name!)
//
//                         } catch {
//                              fatalError("Failedtofetchemployees: \(error)")
//
//                         }
                         
                    }
                }
                
            
            catch {
                
            }
          }
        
        }
    
          task.resume()
     
     
    

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

