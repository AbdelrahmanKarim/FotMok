//
//  AppFont.swift
//  FotMoc
//
//  Created by abdelrahman karim on 19/05/2026.
//

import UIKit

public enum AppFont {
    
    public enum Weight: String {
        case regular = "Inter-Regular"
        case medium = "Inter-Medium"
        case semiBold = "Inter-SemiBold"
        case bold = "Inter-Bold"
    }
    
    public static func inter(weight: Weight, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: weight.rawValue, size: size) else {
            // Fallback to system font if Inter isn't loaded properly in Info.plist
            return UIFont.systemFont(ofSize: size, weight: systemWeight(for: weight))
        }
        return font
    }
    public static let bigCaption = inter(weight: .bold, size: 32)
    public static let h1 = inter(weight: .bold, size: 24)
    public static let h2 = inter(weight: .semiBold, size: 20)
    public static let h3 = inter(weight: .medium, size: 18)
    public static let body = inter(weight: .regular, size: 16)
    public static let bodyMedium = inter(weight: .medium, size: 16)
    
    public static let caption = inter(weight: .regular, size: 14)
    public static let small = inter(weight: .regular, size: 12)
    
    private static func systemWeight(for weight: Weight) -> UIFont.Weight {
        switch weight {
        case .regular: return .regular
        case .medium: return .medium
        case .semiBold: return .semibold
        case .bold: return .bold
        }
    }
}
