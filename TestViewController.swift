//
//  TestViewController.swift
//  Robin_Vinck_multec_werkstuk2
//
//  Created by Robin Vinck on 5/05/18.
//  Copyright © 2018 Robin Vinck. All rights reserved.
//

import UIKit
import CoreData
class TestViewController: UIViewController {
var managedContext:NSManagedObjectContext?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        self.managedContext = appDelegate.persistentContainer.viewContext
        DispatchQueue.global(qos: .background).async {
           
            
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Station")
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                try self.managedContext?.execute(request)
                try self.managedContext?.save()
            } catch {
                print("code catched testview")
            }
            
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
            }
            
        }
      
        
       
        // Do any additional setup after loading the view.
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
