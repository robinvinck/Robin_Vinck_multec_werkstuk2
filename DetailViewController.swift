//
//  DetailViewController.swift
//  Robin_Vinck_multec_werkstuk2
//
//  Created by Robin Vinck on 4/05/18.
//  Copyright © 2018 Robin Vinck. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation



class DetailViewController: UIViewController  {
    var opgehaaldeStations:[Station] = []
    
    @IBOutlet weak var NaamLbl: UILabel!
    var temp:Int64 = 0
    @IBOutlet weak var adresLbl: UILabel!
    @IBOutlet weak var isOpenLbl: UILabel!
    @IBOutlet weak var bikeStandsLbl: UILabel!
    @IBOutlet weak var beschikbaarLbl: UILabel!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preferredLanguage = NSLocale.preferredLanguages[0]
        print(preferredLanguage)
        // Do any additional setup after loading the view.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let stationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        
        do{
            opgehaaldeStations = try managedContext.fetch(stationFetch) as! [Station]
            
            
            for villoElement in opgehaaldeStations {
                
                if(villoElement.number == temp){
                    
                    
                    let naamArray = makeSnippet(elementName: villoElement.name!, separator: "/")
                    let adresArray = makeSnippet(elementName: villoElement.address!, separator: "/")
                    
                    //if preferredLanguage.contains("en") bron: Jany Ertveldt
                    if preferredLanguage.contains("en") {
                        let naamArray2 = makeSnippet(elementName: naamArray.first!, separator: "-")
                        self.NaamLbl.text = naamArray2.last
                        self.adresLbl.text = adresArray.first
                        self.isOpenLbl.text = villoElement.status
                        self.bikeStandsLbl.text = String(villoElement.bike_stands)
                        self.beschikbaarLbl.text =
                            String(villoElement.available_bikes)
                    } else if preferredLanguage.contains("nl") {
                        
                        let naamArray2 = makeSnippet(elementName: naamArray.last!, separator: "-")
                        self.NaamLbl.text = naamArray2.last
                        self.adresLbl.text = adresArray.last
                        self.isOpenLbl.text = villoElement.status
                        //print(villoElement.status)
                        self.isOpenLbl.text = villoElement.status
                        self.bikeStandsLbl.text = String(villoElement.bike_stands)
                        self.beschikbaarLbl.text =
                            String(villoElement.available_bikes)
                    }
                    
                }
                
            }
            
            
        } catch {
            fatalError("Failedtofetchemployees: \(error)")
            
        }
        
        
    }
    
    func makeSnippet(elementName:String, separator:String) -> [String]{
        let snippet = elementName
        let fileName = snippet
        let fileArray = fileName.components(separatedBy: separator)
        return fileArray
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
        
        
    

    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
