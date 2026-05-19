//
//  AppTheme.swift
//  FotMoc
//
//  Created by abdelrahman karim on 19/05/2026.
//

import UIKit

public struct AppTheme {
    
    public static func apply() {
        configureNavigationBar()
        configureTabBar()
        configureButtons()
    }
    
    private static func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColor.bgPrimary
        
        appearance.titleTextAttributes = [
            .foregroundColor: AppColor.textPrimary,
            .font: AppFont.h2
        ]
        
        appearance.largeTitleTextAttributes = [
            .foregroundColor: AppColor.textPrimary,
            .font: AppFont.h1
        ]
        
        appearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = AppColor.accentPrimary
    }
    
    private static func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColor.bgSurface
        
        appearance.shadowColor = AppColor.border
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        UITabBar.appearance().tintColor = AppColor.accentPrimary
        UITabBar.appearance().unselectedItemTintColor = AppColor.textSecondary
    }
    
    private static func configureButtons() {
        UIButton.appearance().tintColor = AppColor.accentPrimary
    }
}
