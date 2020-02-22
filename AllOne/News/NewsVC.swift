//
//  NewsVC.swift
//  AllOne
//
//  Created by Absoluit on 16/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import UIKit
import GoogleMobileAds

class NewsVC: UIViewController {

    @IBOutlet weak var newsTableView: UITableView!
   
    private var newsArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.init(red: 0.0/255.0, green: 157.0/255.0, blue: 215.0/255.0, alpha: 0.5)
        navigationController?.navigationBar.tintColor = UIColor.white
        
        getCricketNews()
        (UIApplication.shared.delegate as! AppDelegate).showInterstitialAd(controller: self)
    }
    
    
    
    func getCricketNews(){
        let headers = [
            "x-rapidapi-host": "livescore6.p.rapidapi.com",
            "x-rapidapi-key": "c4b7f6c03amshb614de998b9c9dap1a91e3jsncbcc3a6c56b3"
        ]
        
        let url = "https://livescore6.p.rapidapi.com/news/list?category=cricket"
        
        AppUtils.sharedUtils.getRestAPIResponse(urlString: url, headers: headers as NSDictionary, parameters: NSDictionary(), method: .get) { (data) in
            if (data["arts"] != nil){
                self.newsArray = data["arts"] as! NSArray
                self.newsTableView.reloadData()
            }else{
                print("Error in \(url)")
                print(data)
            }
        }
    }
    
    @objc func seeAllDetailsAction(sender: UIButton){
        let objNewsDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "NewsDetailVC") as! NewsDetailVC
        let tempDict = self.newsArray[sender.tag] as! NSDictionary
        objNewsDetailVC.detailsDict = tempDict
        self.navigationController?.pushViewController(objNewsDetailVC, animated: true)
        (UIApplication.shared.delegate as! AppDelegate).showInterstitialAd(controller: self)
    }
}

extension NewsVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        let tempDict = self.newsArray[indexPath.row] as! NSDictionary
        
        cell.detailsLbl.text = tempDict["tit"] as? String ?? ""
        cell.titleLbl.text = tempDict["cap"] as? String ?? ""
        
        let imgUrl = tempDict["img"] as! String
        cell.imgView.af_setImage(withURL: URL.init(string: imgUrl)!)
        
        cell.seeAllBtn.tag = indexPath.row
        cell.seeAllBtn.addTarget(self, action: #selector(seeAllDetailsAction(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let headerBannerView = GADBannerView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        headerBannerView.adUnitID = AdsIds.bannerID
        headerBannerView.rootViewController = self
        headerBannerView.load(GADRequest())
        return headerBannerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}
