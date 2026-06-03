//
//  LiveMatchesViewController.swift
//  FotMoc
//
//  Created by Alaa Ayman on 24/05/2026.
//

import UIKit



class LiveMatchesViewController: UIViewController , LiveMatchesView {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = AppColor.bgPrimary
        collectionView.setCollectionViewLayout(setUpCollectionViewLayout(), animated: true)
        registerCells()
        registerHeaders()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
       

        // Do any additional setup after loading the view.
    }
    func registerCells(){
        let liveMatchNib = UINib(nibName: "LiveMatchesCollectionViewCell", bundle: nil)
            collectionView.register(liveMatchNib,forCellWithReuseIdentifier: "liveMatchCell" )
    }
    func registerHeaders(){
        let globalHeaderNib = UINib(nibName: "LeagueDetailsHeader", bundle: nil)
        collectionView.register(globalHeaderNib,forSupplementaryViewOfKind: "GlobalHeaderKind",withReuseIdentifier: "leagueDetailsHeader")
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

extension LiveMatchesViewController : UICollectionViewDelegate , UICollectionViewDataSource{
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "liveMatchCell",
            for: indexPath) as! LiveMatchesCollectionViewCell
        cell.configure(firstTeam: "Al Ahly SC",secondTeam: "Zamalek SC",score: "2 - 1",minute: "67'")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       let header = collectionView.dequeueReusableSupplementaryView(
           ofKind: kind,withReuseIdentifier: "leagueDetailsHeader",for: indexPath) as! LeagueDetailsHeader
       
       header.configure(title: "Live Matches", country: "Global")
       
       
       
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
        return self.setupLiveMatchesSection()
      
    }
    
    
    
    private func setupLiveMatchesSection() -> NSCollectionLayoutSection {

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
      

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 10
        section.contentInsets =  NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        
        return section
    }
    
}
