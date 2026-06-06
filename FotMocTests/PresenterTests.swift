import XCTest
import Factory
@testable import FotMoc

final class PresenterTests: XCTestCase {
    
    // Safety check: Isolate the Factory container before each test
    override func setUp() {
        super.setUp()
        Container.shared.manager.push()
    }
    
    // Clear out the overrides after each test
    override func tearDown() {
        Container.shared.manager.pop()
        super.tearDown()
    }
    
    func testLiveMatchesPresenter_LoadMatches_WhenEmpty_ShowsEmptyState() {
        let mockView = MockLiveMatchesView()
        let mockSportProvider = MockCurrentSportProvider()
        let mockUseCase = MockGetLiveMatchesUseCase(repository: MockMatchRepository())
        mockUseCase.matchesToReturn = []
        
        Container.shared.getLiveMatchesUseCase.register { mockUseCase }
        
        let presenter = LiveMatchesPresenterImpl(sportProvider: mockSportProvider)
        presenter.attachView(mockView)
        
        let expectation = XCTestExpectation(description: "Wait for async load")
        presenter.loadLiveMatches()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.hideLoadingCalled)
            XCTAssertTrue(mockView.displayEmptyStateCalled)
            XCTAssertFalse(mockView.displayMatchesCalled)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testPlayerProfilePresenter_LoadData_Success() {
        let mockView = MockPlayerProfileView()
        let mockDetailsUseCase = MockGetPlayerDetailsUseCase(repository: MockPlayerRepository())
        let testPlayer = Player(id: "p1", name: "Salah", imageUrl: nil, nationality: "Egypt", age: 32, sportDetails: .teamSport(teamId: "t1", position: "RW"))
        mockDetailsUseCase.playerToReturn = testPlayer
        
        // Registering BOTH use cases to prevent network hangs
        Container.shared.getPlayerDetailsUseCase.register { mockDetailsUseCase }
        Container.shared.getPlayerProfileStatsUseCase.register { MockGetPlayerProfileStatsUseCase(repository: MockPlayerRepository()) }
        
        let presenter = PlayerProfilePresenterImpl()
        presenter.attachView(mockView)
        
        let expectation = XCTestExpectation(description: "Wait for async load")
        presenter.loadPlayerData(playerId: "p1")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(mockView.displayProfileCalled)
            XCTAssertEqual(mockView.displayedPlayer?.name, "Salah")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    
}

// MARK: - Test-Specific Subclass Overrides
class MockTeamDetailsUseCase: GetTeamDetailsUseCase {
    var teamToReturn: Team!
    override func execute(teamId: String) async throws -> Team { return teamToReturn }
}
