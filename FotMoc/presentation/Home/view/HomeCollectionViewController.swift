//
//  HomeCollectionViewController.swift
//  FotMoc
//
//  Created by Alaa Ayman on 20/05/2026.
//

import UIKit
import Factory
class HomeCollectionViewController: UIViewController  {
  
   
    @IBOutlet weak var collectionView: UICollectionView!
    let sports: [SportCell] = [
        SportCell(title: "football", imageName: "football"),
        SportCell(title: "basketball", imageName: "basketball"),
        SportCell(title: "tennis", imageName: "tennis"),
        SportCell(title: "cricket", imageName: "cricket")
    ]
    @Injected(\.homePresenter) private var presenter: HomePresenter
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = AppColor.bgPrimary
        self.view.backgroundColor = AppColor.bgPrimary
        registerHeaders()
        // Do any additional setup after loading the view.
    }
    deinit {
           
            presenter.detachView()
        }
    func registerHeaders(){
        let globalHeaderNib = UINib(nibName: "LeagueDetailsHeader", bundle: nil)
        collectionView.register(
            globalHeaderNib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "leagueDetailsHeader"
            
        )
    }
   


}
extension HomeCollectionViewController: HomeView {
    
    func navigateToLeagueDetails(with sport: SportType) {
        
        
        guard let leaguesVC = storyboard?.instantiateViewController(withIdentifier: "leaguesScreen") as? LeaguesViewController else {return}
        navigationController?.pushViewController(leaguesVC, animated: true)
        leaguesVC.sport = sport
    }
    

}
extension HomeCollectionViewController :UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sports.count
    }
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            presenter.selectSport(at: indexPath.item, from: sports)
        }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->  UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomHomeCollectionViewCell
        // Configure the cell
        let sport = sports[indexPath.item]
           cell.sportImage.image = UIImage(named: sport.imageName)
        cell.sportTitle.text = sport.title.capitalized
           
        return cell
    }
    private var isLandscape : Bool {
        return view.bounds.width > view.bounds.height
    }
    private var columns : CGFloat {
        return isLandscape ? 4:2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 16;
       }
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 16;
       }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            let padding: CGFloat = 16
            
         
            let totalSpacing = padding * (columns + 1)
            let itemWidth = (collectionView.bounds.width - totalSpacing) / columns
            
            var itemHeight = itemWidth
            if isLandscape {
                let availableHeight = collectionView.bounds.height - padding * 2
                let width = ((collectionView.frame.width) - totalSpacing) / 4
                let size = min(width, availableHeight)
                itemHeight = size + 100
            }
            
        
            let numRows = ceil(CGFloat(sports.count) / columns)
            let totalItemsHeight = (itemHeight * numRows) + (padding * (numRows - 1))
            
          
            let headerHeight: CGFloat = 100
            
           
            let totalContentHeight = headerHeight + totalItemsHeight
            let availableScreenHeight = collectionView.bounds.height
            
      
            if totalContentHeight < availableScreenHeight {
                let emptySpace = availableScreenHeight - totalContentHeight
                let topInset = emptySpace / 2
                
                return UIEdgeInsets(top: topInset, left: padding, bottom: padding, right: padding)
            } else {
                
                return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let padding: CGFloat = 16
        let totalSpacing = padding * (columns + 1)
        let width = (collectionView.bounds.width - totalSpacing) / columns

        if isLandscape {
                let availableHeight = collectionView.bounds.height - padding * 2
            let width = ((collectionView.frame.width) - totalSpacing)/4
                let size = min(width, availableHeight)
            return CGSize(width: width, height: size + 100)
            }
            return CGSize(width: width, height: width )
    }
    
  
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
       let header = collectionView.dequeueReusableSupplementaryView(
           ofKind: kind,withReuseIdentifier: "leagueDetailsHeader",for: indexPath) as! LeagueDetailsHeader
       
        header.configure(title: "Sports", country: "", showBackButton: false)
       
       
       
       return header
   }
}



