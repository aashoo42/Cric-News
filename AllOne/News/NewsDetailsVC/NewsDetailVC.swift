//
//  NewsDetailVC.swift
//  AllOne
//
//  Created by Absoluit on 16/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import UIKit

class NewsDetailVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var titleDetailsLbl: UILabel!
    @IBOutlet weak var detailsTxtView: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    
    var detailsDict = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        print(detailsDict)
    }
    
    func setupData(){
        self.title = "Author: \(detailsDict["aut"] as? String ?? "")"
        
        titleLbl.text = detailsDict["cap"] as? String ?? ""
        titleDetailsLbl.text = detailsDict["tit"] as? String ?? ""
        
        let imgUrl = detailsDict["img"] as! String
        imgView.af_setImage(withURL: URL.init(string: imgUrl)!)
        
        let htmlText = detailsDict["con"] as? String ?? ""
        detailsTxtView.attributedText = htmlText.htmlToAttributedString
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
