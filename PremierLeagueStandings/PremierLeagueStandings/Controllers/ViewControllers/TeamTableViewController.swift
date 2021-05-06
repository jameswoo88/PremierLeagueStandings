//
//  TeamTableViewController.swift
//  PremierLeagueStandings
//
//  Created by James Chun on 5/5/21.
//

import UIKit

class TeamTableViewController: UITableViewController {
    
    //MARK: - Properties
    var teams: [Team] = []
    var teamDataArray: [TeamThirdLevelObject] = []
    let leagueName = "PL"
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchTeamData()
    }
    
    //MARK: - Functions
    
    func fetchTeamData() {
        TeamController.fetchTeamData(leagueName: self.leagueName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let teamDataArray):
                    self.teamDataArray = teamDataArray
                    
                    for teamObject in teamDataArray {
                        self.teams.append(teamObject.team)
                    }
                    
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }//end of func
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as? TeamTableViewCell else { return UITableViewCell() }
        
        print("teams count: \(teams.count)")
        print("team data count: \(teamDataArray.count)")

        let team = teams[indexPath.row]
        let teamData = teamDataArray[indexPath.row]
        
        cell.team = team
        cell.teamData = teamData
        
        cell.updateViews(indexPath: indexPath)
                
        return cell
    }

}//End of class
