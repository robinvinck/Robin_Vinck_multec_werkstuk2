//
//  DetailViewController.swift
//  Robin_Vinck_multec_werkstuk2
//
//  Created by Robin Vinck on 4/05/18.
//  Copyright © 2018 Robin Vinck. All rights reserved.
//

import UIKit
import CoreData



class DetailViewController: UIViewController {
    var opgehaaldeStations:[Station] = []
    
    @IBOutlet weak var NaamLbl: UILabel!
    var temp:Int64 = 0
    @IBOutlet weak var adresLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let stationFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
        
        do{
            opgehaaldeStations = try managedContext.fetch(stationFetch) as! [Station]
            
            
            for villoElement in opgehaaldeStations {
                
                if(villoElement.number == temp){
                    self.NaamLbl.text = villoElement.name
                    self.adresLbl.text = villoElement.address
                    
                    let snippet = villoElement.name
                    let fileName = snippet
                    let fileArray = fileName?.components(separatedBy: "/")
                    let test = fileArray!.last
                    let test2 = fileArray!.first
                    print(test)
                    print("test2")
                    print(test2)
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
