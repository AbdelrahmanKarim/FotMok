//
//  HomeHeaderCollectionReusableView.swift
//  FotMoc
//
//  Created by Alaa Ayman on 21/05/2026.
//

import UIKit

class HomeHeaderCollectionReusableView: UICollectionReusableView {
  
        
    @IBOutlet weak var homeTitle: UILabel!
    
    @IBOutlet weak var homeSubtitle: UILabel!
    func configure() {
            homeTitle.font = AppFont.inter(weight: .bold, size: 25)
            homeSubtitle.font = AppFont.inter(weight: .semiBold, size: 18)
        }
    
}
