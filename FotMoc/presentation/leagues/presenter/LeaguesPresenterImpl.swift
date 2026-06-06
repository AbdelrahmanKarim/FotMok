import Foundation
import Network
import Factory

class LeaguesPresenterImpl: LeaguesPresenter {
    private weak var view: LeaguesView?
    @Injected(\.getLeaguesUseCase) private var getLeaguesUseCase: GetLeaguesUseCase
    private let sportProvider: CurrentSportProvider!
    
    private var allLeagues: [League] = []
    private var filteredLeagues: [League] = []
    
    private let monitor = NWPathMonitor()
    private var isOnline = true
    private var isDataLoaded = false
    
    init(sportProvider: CurrentSportProvider) {
        self.sportProvider = sportProvider
        setupNetworkMonitor()
    }
    
    private func setupNetworkMonitor() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isOnline = (path.status == .satisfied)
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    
    func viewDidLoad() {
        let sportName = sportProvider.selectedSport.rawValue.capitalized
        view?.setGameHeader(sportName: sportName)
        fetchLeagues()
    }
    
    func attachView(_ view: LeaguesView) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    private func fetchLeagues() {
        guard isOnline else {
            DispatchQueue.main.async { [weak self] in
                self?.view?.showNoInternet(isHidden: false)
                self?.view?.showNoResults(isHidden: true)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.view?.showNoInternet(isHidden: true)
            self.view?.showNoResults(isHidden: true)
            self.view?.showLoading()
        }
        
        Task {
            do {
                let leagues = try await getLeaguesUseCase.execute(sport: sportProvider.selectedSport)
                DispatchQueue.main.async { [weak self] in
                    self?.isDataLoaded = true
                    self?.view?.hideLoading()
                    self?.allLeagues = leagues
                    self?.filteredLeagues = leagues
                    
                    if leagues.isEmpty {
                        self?.view?.showNoResults(isHidden: false)
                    } else {
                        self?.view?.showNoResults(isHidden: true)
                        self?.view?.reloadData()
                    }
                }
            } catch let error as AppException {
                DispatchQueue.main.async { [weak self] in
                    self?.isDataLoaded = true
                    self?.view?.hideLoading()
                    
                    switch error {
                    case .noInternetConnection:
                        self?.view?.showNoInternet(isHidden: false)
                    case .noData, .notFound:
                        self?.view?.showNoResults(isHidden: false)
                    default:
                        self?.view?.showError(error.localizedDescription)
                    }
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.isDataLoaded = true
                    self?.view?.hideLoading()
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func search(query: String) {
        let cleanQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleanQuery.isEmpty {
            filteredLeagues = allLeagues
        } else {
            filteredLeagues = allLeagues.filter { $0.name.lowercased().contains(cleanQuery.lowercased()) }
        }
        
        if isDataLoaded {
            view?.showNoResults(isHidden: !filteredLeagues.isEmpty)
        }
        view?.reloadData()
    }
    
    func getLeaguesCount() -> Int {
        return filteredLeagues.count
    }
    
    func getLeague(at index: Int) -> League {
        return filteredLeagues[index]
    }
    
    func didSelectLeague(at index: Int) {
        let selectedLeague = filteredLeagues[index]
        view?.navigateToLeagueDetails(with: selectedLeague)
    }
}
