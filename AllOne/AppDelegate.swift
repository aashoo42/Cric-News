//
//  AppDelegate.swift
//  AllOne
//
//  Created by Absoluit on 05/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

let deviceRatio = (UIScreen.main.bounds.width) / (375) // 1 for iPhone 6
var addCounter = 0

import UIKit
import Reachability
import SVProgressHUD
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var interstitial: GADInterstitial!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.checkInternetConnection()
        self.setupInterstitialAd()
        
        SVProgressHUD.setBackgroundColor(UIColor.init(red: 0.0/255.0, green: 157.0/255.0, blue: 215.0/255.0, alpha: 0.5))
        SVProgressHUD.setForegroundColor(UIColor.white)
        
        return true
    }
    
    // MARK:- GADInterstitial
    func setupInterstitialAd(){
        if addCounter == 2{
            interstitial = GADInterstitial(adUnitID: AdsIds.interstitialID)
            let request = GADRequest()
            interstitial.load(request)
        }
    }
    
    func showInterstitialAd(controller: UIViewController){
        addCounter = addCounter + 1
        if addCounter == 5{
            addCounter = 0
        }
        
        self.setupInterstitialAd()
        if addCounter == 3{
            if interstitial.isReady{
                interstitial.present(fromRootViewController: controller)
            }
        }
    }

    // MARK:- Reachability
    private let reachability = Reachability()!
    private func checkInternetConnection(){
        
        reachability.whenReachable = { data in
            // hide any popup if already showing
            if self.window?.rootViewController is UIAlertController{
                let alertController = self.window?.rootViewController as! UIAlertController
                alertController.dismiss(animated: true, completion: nil)
            }
        }
        
        reachability.whenUnreachable = { data in
            self.showInternetAlert()
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func showInternetAlert(){
        let alert = UIAlertController.init(title: "Internet?", message: "Please check your internet connection.", preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}

