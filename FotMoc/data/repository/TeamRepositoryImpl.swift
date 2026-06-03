//
//  TeamRepositoryImpl.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class TeamRepositoryImpl: TeamRepository {
    private let remoteDataSource: TeamRemoteDataSource
        
        init(remoteDataSource: TeamRemoteDataSource) {
            self.remoteDataSource = remoteDataSource
        }
    
    func getLeagueTeams(leagueId: String) async throws -> [Team] {
        fatalError()
    }
    
    func getOverallHeadToHeadRecord(teamId1: String, teamId2: String) async throws -> HeadToHeadRecord {
        fatalError()
    }
    
    func getTeamDetails(teamId: String) async throws -> Team {
        fatalError()
    }
    
    func getTeamRecentForm(teamId: String) async throws -> TeamRecentForm {
        fatalError()
    }
    
    func getTeamSeasonStats(teamId: String) async throws -> TeamSeasonStats {
        fatalError()
    }
}
