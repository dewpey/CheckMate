//
//  DNAScreenViewController.swift
//  Bitdate
//
//  Created by Drew Patel on 5/13/18.
//  Copyright © 2018 Drew Patel. All rights reserved.
//

import UIKit
import stellarsdk
class DNAScreenViewController: UIViewController {

    @IBOutlet weak var dnaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var DNA = UserDefaults.standard.string(forKey: "DNA")
        //dnaLabel.text = DNA
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


