//
//  TeamTableViewCell.swift
//  PremierLeagueStandings
//
//  Created by James Chun on 5/5/21.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var teamPositionLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamPointsLabel: UILabel!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    
    //MARK: - Properties
    var team: Team?
    var teamData: TeamThirdLevelObject?
    
    //MARK: - Functions
    func updateViews(indexPath: IndexPath) {
        guard let team = team,
              let teamData = teamData else { return }
        
        teamPositionLabel.text = String(indexPath.row + 1)
        teamNameLabel.text = team.name
        teamPointsLabel.text = String(teamData.points)
        gamesPlayedLabel.text = String(teamData.playedGames)
        
        TeamController.fetchTeamImage(team: team) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.teamImageView.image = image
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    override func prepareForReuse() {
        teamImageView.image = nil
    }

}//End of class
