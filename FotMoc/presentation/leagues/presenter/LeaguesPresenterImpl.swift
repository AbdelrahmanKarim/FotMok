import Foundation
import Network
import Factory

class LeaguesPresenterImpl: LeaguesPresenter {
    
    private weak var view: LeaguesView?
    @Injected(\.getLeaguesUseCase) private var getLeaguesUseCase: GetLeaguesUseCase
    private let sportProvider: CurrentSportProvider!
    
    private var allLeagues: [League] = []
    private var filteredLeagues: [League] = []
    
    private var isDataLoaded = false
    
    // Core monitoring variables
    private var monitor: NWPathMonitor?
    private var isConnected: Bool = true
    private var isMonitoringStarted = false

    init(sportProvider: CurrentSportProvider) {
        self.sportProvider = sportProvider
    }

    func attachView(_ view: LeaguesView) {
        self.view = view
        startMonitoring()
    }

    func detachView() {
        self.view = nil
        monitor?.cancel()
        monitor = nil
        isMonitoringStarted = false
    }
    
    func retryLoading() {
        retryAll()
    }
    
    private func startMonitoring() {
        guard !isMonitoringStarted else { return }
        isMonitoringStarted = true
        
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let wasConnected = self.isConnected
            self.isConnected = path.status == .satisfied

            DispatchQueue.main.async {
                if self.isConnected && !wasConnected {
                    // Device reconnected — auto retry data pull
                    self.view?.hideNoInternet()
                    self.retryAll()
                } else if !self.isConnected {
                    self.view?.hideLoading()
                    self.view?.showNoInternet()
                }
            }
        }
        monitor?.start(queue: DispatchQueue(label: "LeaguesNetworkMonitor"))
    }

    private func retryAll() {
        fetchLeagues()
    }

    // Modern baseline pre-flight validation
    private func guardConnectivity() -> Bool {
        if !isConnected {
            view?.hideLoading()
            view?.showNoInternet()
            return false
        }
        return true
    }
    
    func viewDidLoad() {
        let sportName = sportProvider.selectedSport.rawValue.capitalized
        view?.setGameHeader(sportName: sportName)
        fetchLeagues()
    }
    
    private func fetchLeagues() {
        // 1. Pre-flight check replacing old 'isOnline' guard
        guard guardConnectivity() else { return }
        
        DispatchQueue.main.async {
            self.view?.hideNoInternet()
            self.view?.showNoResults(isHidden: true)
            self.view?.showLoading()
        }
        
        Task {
            do {
                let leagues = try await getLeaguesUseCase.execute(sport: sportProvider.selectedSport)
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.isDataLoaded = true
                    self.view?.hideLoading()
                    self.allLeagues = leagues
                    self.filteredLeagues = leagues
                    
                    if leagues.isEmpty {
                        self.view?.showNoResults(isHidden: false)
                    } else {
                        self.view?.showNoResults(isHidden: true)
                        self.view?.reloadData()
                    }
                }
            } catch let error as AppException {
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.isDataLoaded = true
                    self.view?.hideLoading()
                    
                    switch error {
                    case .noInternetConnection:
                        self.view?.showNoInternet()
                    case .noData, .notFound:
                        self.view?.showNoResults(isHidden: false)
                    default:
                        self.view?.showError(error.localizedDescription)
                    }
                }
            } catch {
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.isDataLoaded = true
                    self.view?.hideLoading()
                    self.view?.showError(error.localizedDescription)
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
