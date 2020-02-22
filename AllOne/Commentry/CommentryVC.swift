//
//  CommentryVC.swift
//  AllOne
//
//  Created by Absoluit on 15/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import UIKit
import GoogleMobileAds

class CommentryVC: UIViewController {
    
    @IBOutlet var overHeaderView: UIView!
    @IBOutlet weak var overNumberLbl: UILabel!
    
    @IBOutlet weak var commentaryCollectionView: UICollectionView!
    @IBOutlet weak var commentaryTableView: UITableView!
    
    @IBOutlet weak var detailNameLbl: UILabel!
    var seriesId = 0
    var matchId = 0
    
    var selectedIndex = 0
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
                self.commentaryCollectionView.reloadData()
                self.commentaryTableView.reloadData()
            }else{
                print("Error in \(url)")
                print(data)
            }
        }
    }
}

extension CommentryVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.inngsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.commentaryCollectionView.dequeueReusableCell(withReuseIdentifier: "ComInngCell", for: indexPath) as! ComInngCell

        let tempDict = inngsArray[indexPath.row] as! NSDictionary
        cell.nameLbl.text = tempDict["shortName"] as? String ?? ""
        cell.nameLbl.textColor = UIColor.white
        
        if indexPath.row == selectedIndex{
            cell.backgroundColor = AppColors.darkBlue
            let longName = tempDict["name"] as! String
            detailNameLbl.text = longName
        }else{
            cell.backgroundColor = AppColors.lighBlue
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let longName = (inngsArray[indexPath.row] as! NSDictionary)["name"] as! String
        detailNameLbl.text = longName
        
        selectedIndex = indexPath.row
        collectionView.reloadData()
        commentaryTableView.reloadData()
        (UIApplication.shared.delegate as! AppDelegate).showInterstitialAd(controller: self)
    }
}

extension CommentryVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if inngsArray.count > 0{
            let overs = (inngsArray[selectedIndex] as! NSDictionary)["overs"] as! NSArray
            return overs.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if inngsArray.count > 0{
            let headerView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: tableView.frame.width, height: 35))
            headerView.backgroundColor = UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
            
            let overLabel = UILabel.init(frame: CGRect.init(x: 5.0, y: 0.0, width: tableView.frame.width, height: 35))
            let tempDict = ((inngsArray[selectedIndex] as! NSDictionary)["overs"] as! NSArray)[section] as! NSDictionary
            let overNumber = tempDict["number"] as! Int
            overLabel.text = "\(overNumber) Over"
            overLabel.font = UIFont.boldSystemFont(ofSize: 15)
            headerView.addSubview(overLabel)
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inngsArray.count > 0{
            let tempArray = (inngsArray[selectedIndex] as! NSDictionary)["overs"] as! NSArray
            let overDict = tempArray[section] as! NSDictionary
            let balls = overDict["balls"] as! NSArray
            return balls.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommOverCell") as! CommOverCell
        
        let tempArray = (inngsArray[selectedIndex] as! NSDictionary)["overs"] as! NSArray
        let overDict = tempArray[indexPath.section] as! NSDictionary

        let balls = overDict["balls"] as! NSArray
        let comments = (balls[indexPath.row] as! NSDictionary)["comments"] as! NSArray
        var tempComment = NSDictionary()
        if comments.count >= 2{
            tempComment = (comments[1] as! NSDictionary)
        }else{
            tempComment = (comments[0] as! NSDictionary)
        }
        let commentText = tempComment["text"] as! String
        cell.detailsLbl.text = commentText
        
        if (tempComment["isFallOfWicket"] as? Bool ?? false){
            cell.runsLbl.text = "W"
            cell.runsLbl.backgroundColor = UIColor.red
            cell.runsLbl.textColor = UIColor.white
            cell.runsLbl.isHidden = false
        }else{
            cell.runsLbl.text = (tempComment["runs"] as! String)
            cell.runsLbl.backgroundColor = AppColors.lighBlue
            cell.runsLbl.textColor = UIColor.white
            cell.runsLbl.isHidden = false
            if cell.runsLbl.text == ""{
                cell.runsLbl.isHidden = true
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerBannerView = GADBannerView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerBannerView.adUnitID = AdsIds.bannerID
        headerBannerView.rootViewController = self
        headerBannerView.load(GADRequest())
        return headerBannerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section%2)==0{
            return 40
        }
        return 0
        
    }
}
