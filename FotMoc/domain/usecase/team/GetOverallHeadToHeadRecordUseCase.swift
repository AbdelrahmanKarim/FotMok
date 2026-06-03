//
//  getOverallHeadToHeadRecordUseCase.swift
//  FotMoc
//
//  Created by abdelrahman karim on 02/06/2026.
//

class GetOverallHeadToHeadRecordUseCase {
    private let repository: TeamRepository
    
    init(repository: TeamRepository) {
        self.repository = repository
    }
    
    func execute(teamId1: String, teamId2: String) async throws -> HeadToHeadRecord {
        return try await repository.getOverallHeadToHeadRecord(teamId1: teamId1, teamId2: teamId2)
    }
}
