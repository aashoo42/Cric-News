//
//  ScoreboardVC.swift
//  AllOne
//
//  Created by Absoluit on 08/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import UIKit
import Alamofire

class ScoreboardVC: UIViewController {

    // batsman header view
    @IBOutlet weak var firstInngsLbl: UILabel!
    @IBOutlet weak var firstInngsTotalLbl: UILabel!
    @IBOutlet weak var firstInngsOversLbl: UILabel!
    @IBOutlet weak var batsmanHeaderView: UIView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var venueLbl: UILabel!
    @IBOutlet weak var firstTeamImg: UIImageView!
    @IBOutlet weak var firstTeamName: UILabel!
    @IBOutlet weak var firstTeamTotal: UILabel!
    @IBOutlet weak var firstTeamOvers: UILabel!
    
    @IBOutlet weak var secondTeamImg: UIImageView!
    @IBOutlet weak var secondTeamName: UILabel!
    @IBOutlet weak var secondTeamTotal: UILabel!
    @IBOutlet weak var secondTeamOvers: UILabel!
    
    @IBOutlet weak var resultLbl: UILabel!
    
    @IBOutlet weak var scoreboardTableView: UITableView!
    
    
    var inningsArray = NSArray()
    
    var alreadyMatchData = MatchData(json: NSDictionary())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTopViewData()
        getScoreboard(seriesId: alreadyMatchData.seriesName.seriesId, matchId: alreadyMatchData.id)
        scoreboardTableView.isHidden = true
    }
    
    func setTopViewData(){
        firstTeamImg.layer.masksToBounds = true
        firstTeamImg.layer.borderWidth = 0.5
        firstTeamImg.layer.borderColor = UIColor.lightGray.cgColor
        
        secondTeamImg.layer.masksToBounds = true
        secondTeamImg.layer.borderWidth = 0.5
        secondTeamImg.layer.borderColor = UIColor.lightGray.cgColor
        
        statusLbl.text = alreadyMatchData.currentStatus
        venueLbl.text = "\(alreadyMatchData.matchName) \(alreadyMatchData.venue.name) "
        
        firstTeamImg.af_setImage(withURL: URL.init(string: alreadyMatchData.awayTeam.logoUrl)!)
        firstTeamName.text = alreadyMatchData.awayTeam.shortName
        firstTeamTotal.text = alreadyMatchData.scores.awayScore
        firstTeamOvers.text = "(\(alreadyMatchData.scores.awayOvers))"
        
        secondTeamImg.af_setImage(withURL: URL.init(string: alreadyMatchData.homeTeam.logoUrl)!)
        secondTeamName.text = alreadyMatchData.homeTeam.shortName
        secondTeamTotal.text = alreadyMatchData.scores.homeScore
        secondTeamOvers.text = "(\(alreadyMatchData.scores.homeOvers))"
        
        resultLbl.text = alreadyMatchData.matchSummaryText
    }
    
    func setupAllData(){
        // setup Batsmen headerview
        let firstInngs = self.inningsArray[0] as! NSDictionary
        firstInngsLbl.text = firstInngs["name"] as? String ?? ""
        let runs = firstInngs["run"] as? String ?? ""
        let wicket = firstInngs["wicket"] as? String ?? ""
        firstInngsTotalLbl.text = "\(wicket)-\(runs)"
        firstInngsOversLbl.text = "(\(firstInngs["over"] as? String ?? ""))"
        
    }
    
    func getScoreboard(seriesId: Int, matchId: Int){
        let headers = [
            "x-rapidapi-host": "dev132-cricket-live-scores-v1.p.rapidapi.com",
            "x-rapidapi-key": "c4b7f6c03amshb614de998b9c9dap1a91e3jsncbcc3a6c56b3"
        ]
        
        let params = ["seriesid": seriesId,
                      "matchid": matchId]
        
        let url = "https://dev132-cricket-live-scores-v1.p.rapidapi.com/scorecards.php?"
        
        Alamofire.request(url, method: .get, parameters: params, headers: headers).responseJSON { (data) in
            let jsonData = data.result.value as! NSDictionary
            let fullScorecard = jsonData["fullScorecard"] as! NSDictionary
            self.inningsArray = fullScorecard["innings"] as! NSArray
            self.scoreboardTableView.isHidden = false
            self.scoreboardTableView.reloadData()
            self.setupAllData()
        }
    }
}


extension ScoreboardVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.inningsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            if self.inningsArray.count > 0{
                let wickets = Int((self.inningsArray[0] as! NSDictionary)["wicket"] as! String)
                if wickets == 0{
                    return 4 // extras + Total + 1st + 2nd batsman
                }else{
                    return wickets! + 4
                }
            }else{
                return 0
            }
            
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{ // batsman section
            
            let tempDict = self.inningsArray[0] as! NSDictionary
            var wickets = Int(tempDict["wicket"] as! String)
            
            // all out check
            if wickets == 10{
                wickets = 9
            }//
            
            if indexPath.row < (wickets! + 2){
                let cell = self.scoreboardTableView.dequeueReusableCell(withIdentifier: "BatsmanCell") as! BatsmanCell
                let batsmenArray = tempDict["batsmen"] as! NSArray
                let batsmanDict = batsmenArray[indexPath.row] as! NSDictionary
                
                // set data from batsman dict to cell
                
                cell.nameLbl.text = batsmanDict["name"] as? String ?? ""
                cell.outLbl.text = batsmanDict["howOut"] as? String ?? ""
                cell.runsLbl.text = batsmanDict["runs"] as? String ?? ""
                cell.ballsLbl.text = batsmanDict["balls"] as? String ?? ""
                cell.foursLbl.text = batsmanDict["fours"] as? String ?? ""
                cell.sixsLbl.text = batsmanDict["sixes"] as? String ?? ""
                cell.strikeRateLbl.text = batsmanDict["strikeRate"] as? String ?? ""
                
                return cell
            }else{
                let cell = self.scoreboardTableView.dequeueReusableCell(withIdentifier: "ExtrasCell") as! ExtrasCell
                if indexPath.row == (wickets! + 2){ // 2nd last cell
                    cell.leftLbl.text = "Extras"
                    
                    let total = (tempDict["extra"] as! String)
                    let byes = (tempDict["bye"] as! String)
                    let lbyes = (tempDict["legBye"] as! String)
                    let noBall = (tempDict["noBall"] as! String)
                    let wide = (tempDict["wide"] as! String)
                    cell.rightLbl.text = "\(total)  b \(byes), lb \(lbyes), w \(wide), nb \(noBall)"
                    
                }else{ // last cell
                    cell.leftLbl.text = "Total"
                    
                    let totalRuns = (tempDict["run"] as! String)
                    let overs = (tempDict["over"] as! String)
                    let runRate = (tempDict["runRate"] as! String)
                    let wicket = (tempDict["wicket"] as! String)
                    cell.rightLbl.text = "\(totalRuns)-\(wicket) (\(overs) Overs, RR: \(runRate))"
                }
                return cell
            }
            
        }else{
            let cell = UITableViewCell()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return batsmanHeaderView
        }else{
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 375, height: 60))
            headerView.backgroundColor = UIColor.lightGray
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
