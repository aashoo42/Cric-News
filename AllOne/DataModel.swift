//
//  DataModel.swift
//  AllOne
//
//  Created by Absoluit on 08/02/2020.
//  Copyright © 2020 Absoluit. All rights reserved.
//

import Foundation

struct SeriesName {
    let shortName: String
    let seriesId: Int
    init(json: NSDictionary) {
        shortName = json["shortName"] as? String ?? ""
        seriesId = json["id"] as? Int ?? 0
    }
}

struct AwayTeam {
    let logoUrl: String
    let shortName: String
    
    init(json: NSDictionary) {
        logoUrl = json["logoUrl"] as? String ?? ""
        shortName = json["shortName"] as? String ?? ""
    }
}

struct HomeTeam {
    let logoUrl: String
    let shortName: String
    
    init(json: NSDictionary) {
        logoUrl = json["logoUrl"] as? String ?? ""
        shortName = json["shortName"] as? String ?? ""
    }
}

struct Scores {
    let awayScore: String
    let awayOvers: String
    let homeScore: String
    let homeOvers: String
    
    init(json: NSDictionary) {
        awayScore = json["awayScore"] as? String ?? ""
        awayOvers = json["awayOvers"] as? String ?? ""
        homeScore = json["homeScore"] as? String ?? ""
        homeOvers = json["homeOvers"] as? String ?? ""
    }
}

struct Venue {
    let name: String
    init(json: NSDictionary) {
        name = json["name"] as? String ?? ""
    }
}

struct MatchData {
    let currentStatus: String
    let matchName: String
    let matchSummaryText: String
    let id: Int
    
    let seriesName: SeriesName
    let awayTeam: AwayTeam
    let homeTeam: HomeTeam
    let scores: Scores
    let venue: Venue
    
    init(json: NSDictionary) {
        currentStatus = json["currentMatchState"] as? String ?? ""
        matchName = json["name"] as? String ?? ""
        id = json["id"] as? Int ?? 0
        matchSummaryText = json["matchSummaryText"] as? String ?? ""

        seriesName = SeriesName.init(json: json["series"] as? NSDictionary ?? NSDictionary())
        awayTeam = AwayTeam.init(json: json["awayTeam"] as? NSDictionary ?? NSDictionary())
        homeTeam = HomeTeam.init(json: json["homeTeam"] as? NSDictionary ?? NSDictionary())
        scores = Scores.init(json: json["scores"] as? NSDictionary ?? NSDictionary())
        venue = Venue.init(json: json["venue"] as? NSDictionary ?? NSDictionary())
    }
}



class Scoreboard: NSObject {
    
    init(json: NSDictionary) {
        
    }
}
