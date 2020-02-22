//
//  SeriesVC.swift
//  AllOne
//
//  Created by Absoluit on 08/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import GoogleMobileAds

class SeriesVC: UIViewController {

    @IBOutlet weak var liveBtn: UIButton!
    @IBOutlet weak var comingBtn: UIButton!
    
    @IBOutlet weak var seriesTableView: UITableView!
    
    var seriesId = 0
    
    var liveArray = NSMutableArray()
    var comingArray = NSMutableArray()
    
    var isLive = true
    
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
        
        AppUtils.sharedUtils.getRestAPIResponse(urlString: url, headers: headers as NSDictionary, parameters: params as NSDictionary, method: .get) { (data) in
            if (data["status"] != nil) && (data["status"] as! Int == 200){
                let matchList = data["matchList"] as! NSDictionary
                let matches = matchList["matches"] as! NSArray
                self.setupDataForTableView(allMatches: matches)
                print(data["meta"])
            }else{
                print("Error in \(url)")
                print(data)
            }
        }
    }
    
    func setupDataForTableView(allMatches: NSArray){
        for case let match as NSDictionary in allMatches{
            let matchStatus = match["status"] as? String ?? ""
            if matchStatus == "UPCOMING"{
                comingArray.add(match)
            }else{
                liveArray.add(match)
            }
        }
        self.seriesTableView.reloadData()
    }
    
    @IBAction func segmantAction(_ sender: UIButton) {
        if sender.tag == 0{ // show live results
            liveBtn.backgroundColor = AppColors.darkBlue
            comingBtn.backgroundColor = AppColors.lighBlue
            isLive = true
        }else{ // show upcoming results
            liveBtn.backgroundColor = AppColors.lighBlue
            comingBtn.backgroundColor = AppColors.darkBlue
            isLive = false
        }
        self.seriesTableView.reloadData()
    }
    
}

extension SeriesVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLive{
            return self.liveArray.count
        }
        return self.comingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = seriesTableView.dequeueReusableCell(withIdentifier: "SeriesCell") as! SeriesCell
        
        var tempDict = NSDictionary()
        if isLive{
            tempDict = liveArray[indexPath.row] as! NSDictionary
        }else{
            tempDict = comingArray[indexPath.row] as! NSDictionary
        }
        
        let matchData = MatchData.init(json: tempDict)
        
        // current status
        cell.statusLbl.text = matchData.currentStatus
        
        // Start date
        let startDate = tempDict["startDateTime"] as! String // 2020-04-05T05:00:00Z
        let startDateFormatter = DateFormatter()
        startDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFromString = startDateFormatter.date(from: startDate)
        startDateFormatter.dateFormat = "MMM dd-YYYY"
        let dateToShow = startDateFormatter.string(from: dateFromString!)
        
        // venue
        cell.venueLbl.text = "\(matchData.matchName) \(matchData.venue.name) \(dateToShow)"
        
        // First team
        cell.firstTeamImg.af_setImage(withURL: URL.init(string: matchData.awayTeam.logoUrl)!)
        cell.firstTeamName.text = matchData.awayTeam.shortName
        
        // Second team
        cell.secondTeamImg.af_setImage(withURL: URL.init(string: matchData.homeTeam.logoUrl)!)
        cell.secondTeamName.text = matchData.homeTeam.shortName
        
        // Scores
        if matchData.scores.awayScore != ""{
            cell.firstTeamTotal.text = matchData.scores.awayScore
            cell.firstTeamTotal.isHidden = false
        }else{
            cell.firstTeamTotal.isHidden = true
        }
        
        if matchData.scores.awayOvers != ""{
            cell.firstTeamOvers.text = "(\(matchData.scores.awayOvers))"
            cell.firstTeamOvers.isHidden = false
        }else{
            cell.firstTeamOvers.isHidden = true
        }
        
        if matchData.scores.homeScore != ""{
            cell.secondTeamTotal.text = matchData.scores.homeScore
            cell.secondTeamTotal.isHidden = false
        }else{
            cell.secondTeamTotal.isHidden = true
        }
        
        if matchData.scores.homeOvers != ""{
            cell.secondTeamOvers.text = "(\(matchData.scores.homeOvers))"
            cell.secondTeamOvers.isHidden = false
        }else{
            cell.secondTeamOvers.isHidden = true
        }
        
        
        cell.resultLbl.text = matchData.matchSummaryText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var tempDict = NSDictionary()
        if isLive{
            tempDict = liveArray[indexPath.row] as! NSDictionary
        }else{
            tempDict = comingArray[indexPath.row] as! NSDictionary
        }
        
        let matchData = MatchData.init(json: tempDict)
        
        if (matchData.scores.awayOvers != "0") && (matchData.scores.homeOvers != "0") && (matchData.currentStatus != "UPCOMING"){
            let objScoreboardVC = self.storyboard?.instantiateViewController(withIdentifier: "ScoreboardVC") as! ScoreboardVC
            objScoreboardVC.alreadyMatchData = matchData
            self.navigationController?.pushViewController(objScoreboardVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerBannerView = GADBannerView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerBannerView.adUnitID = AdsIds.bannerID
        headerBannerView.rootViewController = self
        headerBannerView.load(GADRequest())
        return headerBannerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isLive{
            return 140
        }
        return 110
    }
}

