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

    @IBOutlet weak var seriesTableView: UITableView!
    
    var seriesId = 0
    var seriesArray = NSArray()
    
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
            let matchList = jsonData["matchList"] as! NSDictionary
            let matches = matchList["matches"] as! NSArray
            self.seriesArray = matches
            self.seriesTableView.reloadData()
        }
    }
}

extension SeriesVC: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.seriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = seriesTableView.dequeueReusableCell(withIdentifier: "SeriesCell") as! SeriesCell
        let tempDict = seriesArray[indexPath.row] as! NSDictionary
        
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
        
        let tempDict = seriesArray[indexPath.row] as! NSDictionary
        let matchData = MatchData.init(json: tempDict)
        
        if (matchData.scores.awayOvers != "0") && (matchData.scores.homeOvers != "0") && (matchData.currentStatus != "UPCOMING"){
            let objScoreboardVC = self.storyboard?.instantiateViewController(withIdentifier: "ScoreboardVC") as! ScoreboardVC
            objScoreboardVC.alreadyMatchData = matchData
            self.navigationController?.pushViewController(objScoreboardVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}

