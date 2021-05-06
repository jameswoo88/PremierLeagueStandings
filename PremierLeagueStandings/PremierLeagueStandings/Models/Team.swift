//
//  Standings.swift
//  PremierLeagueStandings
//
//  Created by James Chun on 5/5/21.
//

import Foundation

struct TeamTopLevelObject: Codable {
    let standings: [TeamSecondLevelObject]
}

struct TeamSecondLevelObject: Codable {
    //let type: String
    let table: [TeamThirdLevelObject]
}

struct TeamThirdLevelObject: Codable {
    let position: Int
    let team: Team
    let playedGames: Int
    let points: Int
}

struct Team: Codable {
    let name: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageUrl = "crestUrl"
    }
}
