//
//  AppColor.swift
//  FotMoc
//
//  Created by abdelrahman karim on 19/05/2026.
//


import UIKit

public enum AppColor {

    
    public static let accentPrimary = UIColor(hex: "#049C63")
    public static let accentGlow    = UIColor(hex: "#FBFBFC").withAlphaComponent(0.12)
    public static let accentBorder  = UIColor(hex: "#FBFBFC").withAlphaComponent(0.30)

   
    public static let accentLight = UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#1E1E22")
            : UIColor(hex: "#FFFFFF")
    }


    public static let accentDark = UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#252529")
            : UIColor(hex: "#E8E9EA")
    }

   
    public static let bgPrimary = UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#0D0D0F")
            : UIColor(hex: "#F8F9FA")
    }

    public static let bgSurface = UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#161618")
            : UIColor(hex: "#FFFFFF")
    }

    public static let bgSurface2 = UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#1E1E22")
            : UIColor(hex: "#F1F2F4")
    }

    public static let bgSurface3 = UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#252529")
            : UIColor(hex: "#E8E9EC")
    }

   
    public static let textPrimary = UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#F5F5F5")
            : UIColor(hex: "#0D0D0F")
    }

    public static let textSecondary = UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#9A9A9A")
            : UIColor(hex: "#5E5E62")
    }

    public static let textTertiary = UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(hex: "#5E5E62")
            : UIColor(hex: "#9A9A9A")
    }

 
    public static let border = UIColor { trait in
        trait.userInterfaceStyle == .dark
            ? UIColor(white: 1.0, alpha: 0.07)
            : UIColor(white: 0.0, alpha: 0.08)
    }

   
    public static let success = UIColor(hex: "#22C55E")
    public static let error   = UIColor(hex: "#EF4444")
    public static let warning = UIColor(hex: "#F59E0B")
    public static let info    = UIColor(hex: "#3B82F6")
}


private extension UIColor {
    convenience init(hex: String) {
        var clean = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
      
        clean = clean.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: clean).scanHexInt64(&rgb)
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >>  8) / 255.0,
            blue:  CGFloat( rgb & 0x0000FF       ) / 255.0,
            alpha: 1.0
        )
    }
}
