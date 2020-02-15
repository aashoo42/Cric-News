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
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var cricketTableView: UITableView!
    private var cricketArray = NSArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.0/255.0, green: 157.0/255.0, blue: 215.0/255.0, alpha: 0.5)
        navigationController?.navigationBar.tintColor = UIColor.white

        
        getCricketData()
    }


    func getCricketData(){
        let headers = [
            "x-rapidapi-host": "dev132-cricket-live-scores-v1.p.rapidapi.com",
            "x-rapidapi-key": "c4b7f6c03amshb614de998b9c9dap1a91e3jsncbcc3a6c56b3"
        ]
        
        let url = "https://dev132-cricket-live-scores-v1.p.rapidapi.com/matches.php?"
        
        let params = ["completedlimit": "",
                      "inprogresslimit": "",
                      "upcomingLimit": "0"]
        
        SVProgressHUD.show()
        AppUtils.sharedUtils.getRestAPIResponse(urlString: url, headers: headers as NSDictionary, parameters: params as NSDictionary, method: .get) { (data) in
            SVProgressHUD.dismiss()
            if (data["status"] != nil) && (data["status"] as! Int == 200){
                let matchList = data["matchList"] as! NSDictionary
                let matches = matchList["matches"] as! NSArray
                self.cricketArray = matches
                self.cricketTableView.reloadData()
                print(data["meta"])
            }else{
                print("Error in \(url)")
                print(data)
            }
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

        let matchData = MatchData.init(json: tempDict)
        
        // series title
        cell.seriesTitleLbl.text = matchData.seriesName.shortName
        
        // current status
        cell.statusLbl.text = matchData.currentStatus
        
        // venue
        cell.venueLbl.text = "\(matchData.matchName) \(matchData.venue.name)"
        
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
        
        cell.seeAllBtn.tag = indexPath.row
        cell.seeAllBtn.addTarget(self, action: #selector(showSeries(sender:)), for: .touchUpInside)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let tempDict = cricketArray[indexPath.row] as! NSDictionary
        let matchData = MatchData.init(json: tempDict)
        
        if ((matchData.scores.awayOvers != "0") || (matchData.scores.homeOvers != "0")) && (matchData.currentStatus != "UPCOMING"){
            let objScoreboardVC = self.storyboard?.instantiateViewController(withIdentifier: "ScoreboardVC") as! ScoreboardVC
            objScoreboardVC.alreadyMatchData = matchData
            self.navigationController?.pushViewController(objScoreboardVC, animated: true)
        }
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
