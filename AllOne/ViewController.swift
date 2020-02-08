//
//  ViewController.swift
//  AllOne
//
//  Created by Absoluit on 05/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ViewController: UIViewController {

    @IBOutlet weak var cricketTableView: UITableView!
    private var cricketArray = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCricketData()
    }


    func getCricketData(){
        let headers = [
            "x-rapidapi-host": "dev132-cricket-live-scores-v1.p.rapidapi.com",
            "x-rapidapi-key": "c4b7f6c03amshb614de998b9c9dap1a91e3jsncbcc3a6c56b3"
        ]
        
        let url = "https://dev132-cricket-live-scores-v1.p.rapidapi.com/matches.php?"
        
        let params = ["completedlimit": "5",
                      "inprogresslimit": "5",
                      "upcomingLimit": "5"]
        
        Alamofire.request(url, method: .get, parameters: params, headers: headers).responseJSON { (data) in
            
            let jsonData = data.result.value as! NSDictionary
            let matchList = jsonData["matchList"] as! NSDictionary
            let matches = matchList["matches"] as! NSArray
            self.cricketArray = matches
            self.cricketTableView.reloadData()
        }
    }
    
    func getSpecificMatchData(seriesId: Int, matchId: Int){
        let headers = [
            "x-rapidapi-host": "dev132-cricket-live-scores-v1.p.rapidapi.com",
            "x-rapidapi-key": "c4b7f6c03amshb614de998b9c9dap1a91e3jsncbcc3a6c56b3"
        ]
        
        let url = "https://dev132-cricket-live-scores-v1.p.rapidapi.com/match.php?"
        
        let params = ["seriesid": seriesId,
                      "matchid": matchId]
        
        Alamofire.request(url, method: .get, parameters: params, headers: headers).responseJSON { (data) in
            
            let jsonData = data.result.value as! NSDictionary
            print(jsonData)
        }
    }
    
    func getScoreCard(seriesId: Int, matchId: Int){
        let headers = [
            "x-rapidapi-host": "dev132-cricket-live-scores-v1.p.rapidapi.com",
            "x-rapidapi-key": "c4b7f6c03amshb614de998b9c9dap1a91e3jsncbcc3a6c56b3"
        ]
        
        let params = ["seriesid": seriesId,
                      "matchid": matchId]
        
        let url = "https://dev132-cricket-live-scores-v1.p.rapidapi.com/scorecards.php?"
        
        Alamofire.request(url, method: .get, parameters: params, headers: headers).responseJSON { (data) in
            
            let jsonData = data.result.value as! NSDictionary
            print(jsonData)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cricketArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cricketTableView.dequeueReusableCell(withIdentifier: "CricketCell") as! CricketCell
        let tempDict = cricketArray[indexPath.row] as! NSDictionary

        // series title
        let seriesName = (tempDict["series"] as! NSDictionary)["shortName"] as! String
        cell.seriesTitleLbl.text = seriesName
        
        // current status
        let currentStatus = (tempDict["currentMatchState"] as! String)
        cell.statusLbl.text = currentStatus
        
        // venue
        let matchName = tempDict["name"] as! String
        let matchVenue = (tempDict["venue"] as! NSDictionary)["name"] as! String
        cell.venueLbl.text = "\(matchName) \(matchVenue)"
        
        // First team
        let awayTeam = (tempDict["awayTeam"] as! NSDictionary)
        let firstImageURL = awayTeam["logoUrl"] as! String
        cell.firstTeamImg.af_setImage(withURL: URL.init(string: firstImageURL)!)
        
        let firstTeamName = awayTeam["shortName"] as! String
        cell.firstTeamName.text = firstTeamName
        
        // Second team
        let homeTeam = tempDict["homeTeam"] as! NSDictionary
        let sedondImageURL = homeTeam["logoUrl"] as! String
        cell.secondTeamImg.af_setImage(withURL: URL.init(string: sedondImageURL)!)

        let secondTeamName = homeTeam["shortName"] as! String
        cell.secondTeamName.text = secondTeamName
        
        if tempDict["scores"] != nil{
            let scores = tempDict["scores"] as! NSDictionary
            let firstTeamTotal = scores["awayScore"] as! String
            cell.firstTeamTotal.text = firstTeamTotal
            
            let firstTeamOvers = scores["awayOvers"] as! String
            cell.firstTeamOvers.text = firstTeamOvers
            
            let secondTeamTotal = scores["homeScore"] as! String
            cell.secondTeamTotal.text = secondTeamTotal
            
            let secondTeamOvers = scores["homeOvers"] as! String
            cell.secondTeamOvers.text = secondTeamOvers
        }else{
            cell.firstTeamTotal.isHidden = true
            cell.firstTeamOvers.isHidden = true
            cell.secondTeamTotal.isHidden = true
            cell.secondTeamOvers.isHidden = true
        }
        
        
        cell.resultLbl.text = tempDict["matchSummaryText"] as! String
        
        cell.seeAllBtn.tag = indexPath.row
        cell.seeAllBtn.addTarget(self, action: #selector(showSeries(sender:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tempDict = cricketArray[indexPath.row] as! NSDictionary
        let seriesId = (tempDict["series"] as! NSDictionary)["id"] as! Int
        let matchId = tempDict["id"] as! Int
//        self.getSpecificMatchData(seriesId: seriesId, matchId: matchId)
        self.getScoreCard(seriesId: seriesId, matchId: matchId)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    @objc func showSeries(sender: UIButton){
        let objSeriesVC = self.storyboard?.instantiateViewController(withIdentifier: "SeriesVC") as! SeriesVC
        let tempDict = cricketArray[sender.tag] as! NSDictionary
        let seriesId =  (tempDict["series"] as! NSDictionary)["id"] as! Int
        objSeriesVC.seriesId = seriesId
        self.navigationController?.pushViewController(objSeriesVC, animated: true)
    }
}
