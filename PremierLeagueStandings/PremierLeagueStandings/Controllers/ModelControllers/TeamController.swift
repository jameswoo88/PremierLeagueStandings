//
//  TeamController.swift
//  PremierLeagueStandings
//
//  Created by James Chun on 5/5/21.
//

import UIKit
import SVGKit

class TeamController {
    
    //MARK: - String Constants
    static let baseURL = URL(string: "https://api.football-data.org/")
    static let versionComponent = "v2"
    static let competitionComponent = "competitions"
    static let standingsPathComponent = "standings"
    static let apiKeyKey = "X-Auth-Token"
    static let apiKeyValue = "7f800cd93a49467197ecfa1fc6776a2f"
        
    static func fetchTeamData(leagueName: String, completion: @escaping (Result<[TeamThirdLevelObject], TeamError>) -> Void) {
        
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let competitionURL = versionURL.appendingPathComponent(competitionComponent)
        let leagueURL = competitionURL.appendingPathComponent(leagueName)
        let standingsURL = leagueURL.appendingPathComponent(standingsPathComponent)
        
        var finalURLRequest = URLRequest(url: standingsURL)
        finalURLRequest.addValue(apiKeyValue, forHTTPHeaderField: apiKeyKey)

        print("Team Data URL: \(finalURLRequest)")

        URLSession.shared.dataTask(with: finalURLRequest) { data, response, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("TEAM DATA STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let decoder = JSONDecoder()
                let topLevelObject = try decoder.decode(TeamTopLevelObject.self, from: data)
                guard let secondLevelObject = topLevelObject.standings.first else { return completion(.failure(.noData)) }
                let thirdLevelObject = secondLevelObject.table
                
                completion(.success(thirdLevelObject))
                
            } catch {
                completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    static func fetchTeamImage(team: Team, completion: @escaping (Result<UIImage, TeamError>) -> Void) {
        guard let baseURL = URL(string: team.imageUrl) else { return completion(.failure(.invalidURL)) }
        print(baseURL)
        
        print("Team Image URL: \(baseURL)")
        
        URLSession.shared.dataTask(with: baseURL) { data, response, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            if let response = response as? HTTPURLResponse {
                print("TEAM IMAGE STATUS CODE: \(response.statusCode)")
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            guard let svgImage = SVGKImage(data: data) else { return completion(.failure(.unableToDecode)) }
            
            guard let image = svgImage.uiImage else { return completion(.failure(.unableToDecode)) }
            
            completion(.success(image))
            
        }.resume()
    }
    
}//End of class
