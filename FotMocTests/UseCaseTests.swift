import XCTest
@testable import FotMoc

final class UseCaseTests: XCTestCase {
    
    func testGetPlayerDetailsUseCase_ReturnsPlayer() async throws {
        let mockRepo = MockPlayerRepository()
        let expectedPlayer = Player(id: "1", name: "Messi", imageUrl: nil, nationality: nil, age: 36, sportDetails: .teamSport(teamId: "t1", position: "FW"))
        mockRepo.playerToReturn = expectedPlayer
        let useCase = GetPlayerDetailsUseCase(repository: mockRepo)
        
        let result = try await useCase.execute(playerId: "1")
        
        XCTAssertEqual(result.name, "Messi")
        XCTAssertEqual(result.id, "1")
    }
    
    func testGetTeamDetailsUseCase_ReturnsTeam() async throws {
        let mockRepo = MockTeamRepository()
        let expectedTeam = Team(id: "t1", name: "Liverpool", logoUrl: nil, sport: .football, countryName: "England", foundedYear: nil, description: nil)
        mockRepo.teamToReturn = expectedTeam
        let useCase = GetTeamDetailsUseCase(repository: mockRepo)
        
        let result = try await useCase.execute(teamId: "t1")
        
        XCTAssertEqual(result.name, "Liverpool")
    }
    
    func testSaveFavouriteLeagueUseCase_CallsRepository() async throws {
        let mockRepo = MockLeagueRepository()
        let useCase = SaveFavouriteLeagueUseCase(repository: mockRepo)
        let league = League(
            id: "L1",
            name: "La Liga",
            logoUrl: nil,
            sport: .football,
            country: nil,
            season: "2025/26",
            sportContext: .teamSport
        )
        
        try await useCase.execute(league: league)
        
        XCTAssertEqual(mockRepo.savedLeague?.id, "L1")
    }
    
    func testGetLiveMatchesUseCase_ReturnsMatches() async throws {
        let mockRepo = MockMatchRepository()
        mockRepo.matchesToReturn = [] // Setup expected data
        let useCase = GetLiveMatchesUseCase(repository: mockRepo)
        
        let result = try await useCase.execute(sport: .football)
        
        XCTAssertEqual(result.count, mockRepo.matchesToReturn.count)
    }
}
