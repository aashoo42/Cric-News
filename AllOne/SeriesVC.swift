//
//  SeriesVC.swift
//  AllOne
//
//  Created by Absoluit on 08/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import UIKit
import Alamofire

class SeriesVC: UIViewController {

    var seriesId = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSeries()
    }
    
    func getSeries(){
        let headers = [
            "x-rapidapi-host": "dev132-cricket-live-scores-v1.p.rapidapi.com",
            "x-rapidapi-key": "c4b7f6c03amshb614de998b9c9dap1a91e3jsncbcc3a6c56b3"
        ]
        
        let params = ["seriesid": seriesId]
        
        let url = "https://dev132-cricket-live-scores-v1.p.rapidapi.com/matchseries.php"
        
        Alamofire.request(url, method: .get, parameters: params, headers: headers).responseJSON { (data) in
            
            let jsonData = data.result.value as! NSDictionary
            print(jsonData)
        }
    }
}
