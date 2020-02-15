//
//  CommentryVC.swift
//  AllOne
//
//  Created by Absoluit on 15/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import UIKit

class CommentryVC: UIViewController {

    var seriesId = 0
    var matchId = 0
    
    var inngsArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getCommentryData()
    }
    
    func getCommentryData(){
        let headers = [
            "x-rapidapi-host": "dev132-cricket-live-scores-v1.p.rapidapi.com",
            "x-rapidapi-key": "c4b7f6c03amshb614de998b9c9dap1a91e3jsncbcc3a6c56b3"
        ]
        
        let url = "https://dev132-cricket-live-scores-v1.p.rapidapi.com/comments.php?"
        let params = ["seriesid": seriesId,
                      "matchid": matchId]
        
        
        AppUtils.sharedUtils.getRestAPIResponse(urlString: url, headers: headers as NSDictionary, parameters: params as NSDictionary, method: .get) { (data) in
            if (data["status"] != nil) && (data["status"] as! Int == 200){
                let commentry = data["commentary"] as! NSDictionary
                self.inngsArray = commentry["innings"] as! NSArray
            }else{
                print("Error in \(url)")
                print(data)
            }
        }
    }
}

extension CommentryVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension CommentryVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
