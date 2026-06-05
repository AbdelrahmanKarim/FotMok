//
//  LatestEventsViewController.swift
//  FotMoc
//
//  Created by Alaa Ayman on 23/05/2026.
//

import UIKit
import Factory
import SkeletonView

class LatestEventsViewController: UIViewController , LatestView{
    
    private var matches: [Match] = []
    
    @Injected(\.latestEventsPresenter) private var presenter: LatestPresenter
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        collectionView.backgroundColor = AppColor.bgPrimary
        collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: true)
        registerCells()
        registerHeaders()
        collectionView.isSkeletonable = true
         collectionView.delegate = self
         collectionView.dataSource = self
        presenter.attachView(self)
        presenter.loadLatestMatches()
   
     
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        

        // Do any additional setup after loading the view.
    }

    func registerCells(){
        let latestEventNib = UINib(nibName: "LatestEventCollectionViewCell", bundle: nil)
            collectionView.register(
                latestEventNib,
                forCellWithReuseIdentifier: "latestEventCell" )
        
      
    }
    func registerHeaders(){
        let globalHeaderNib = UINib(nibName: "LeagueDetailsHeader", bundle: nil)
        collectionView.register(
            globalHeaderNib,
            forSupplementaryViewOfKind: "GlobalHeaderKind",
            withReuseIdentifier: "leagueDetailsHeader"
            
        )
    }
    deinit {
            presenter.detachView()
        }

        
        
        func showLoading() {
            
            collectionView.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        }
        
        func hideLoading() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.collectionView.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.5))
            }
        }
        
        func displayMatches(_ matches: [Match]) {
            self.matches = matches
            
           
   
            DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
            
        }
        
        func displayEmptyState() {
            self.matches = []
            
          
            if let emptyView = Bundle.main.loadNibNamed("EmptyStateCollectionViewCell", owner: self, options: nil)?.first as? UIView {
            
                emptyView.frame = self.collectionView.bounds
                self.collectionView.backgroundView = emptyView
            }
            
            self.collectionView.reloadData()
        }
        
        func displayError(message: String) {
            print("Error fetching latest events: \(message)")
            displayEmptyState()
        }
        
        func navigateBack() {
            self.navigationController?.popViewController(animated: true)
        }
        
      
        
      
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

   
 
}

extension LatestEventsViewController : UICollectionViewDelegate , UICollectionViewDataSource{
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
         return matches.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "latestEventCell", for: indexPath) as! LatestEventCollectionViewCell
                 let match = matches[indexPath.item]
                 cell.configure(with: match)
                 return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       let header = collectionView.dequeueReusableSupplementaryView(
           ofKind: kind,
           withReuseIdentifier: "leagueDetailsHeader",
           for: indexPath
       ) as! LeagueDetailsHeader
        header.delegate = self
       header.configure(title: "Latest Matches", country: "Global")


       return header
   }
    private func globalHeaderConfiguration() -> UICollectionViewCompositionalLayoutConfiguration {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(100))
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,elementKind: "GlobalHeaderKind",alignment: .top)
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.boundarySupplementaryItems = [globalHeader]
        return config
    }
    
    func setUpCollectionViewLayout() -> UICollectionViewLayout {
            let layout = UICollectionViewCompositionalLayout { index, environment in
         
                return self.getSectionFor(index: index)
            }

          
            layout.configuration = globalHeaderConfiguration()
            return layout
        }
    
    func getSectionFor(index: Int) -> NSCollectionLayoutSection {
        return self.setupLatestEventSection()
      
    }
    
    
    
    private func setupLatestEventSection() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 10
        section.contentInsets =  NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        
        return section
    }
    
    
}
extension LatestEventsViewController: LeagueDetailsHeaderDelegate{
    func didTapBackButton() {
        presenter.didTapBack()
    }
    
    func didSelectTab(index: Int) {
      
    }
    
}

extension LatestEventsViewController: SkeletonCollectionViewDataSource {
    
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
         return "latestEventCell"
        
        
    }
    
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
                return 3
            
      	
    }
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
         return 1
     }
}
