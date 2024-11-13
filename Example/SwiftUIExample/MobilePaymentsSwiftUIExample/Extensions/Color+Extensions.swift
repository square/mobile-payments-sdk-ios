//
//  Color+Extensions.swift
//  MobilePaymentsSwiftUIExample
//
//  Created by Tamer Bader on 11/7/24.
//  Copyright © 2024 Square, Inc. All rights reserved.
//

import SwiftUI

extension Color {
    
    init(hex: String, opacity: Double = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b, a: Double
        switch hex.count {
        case 3: // RGB (12-bit)
            r = Double((int >> 8) * 17) / 255.0
            g = Double((int >> 4 & 0xF) * 17) / 255.0
            b = Double((int & 0xF) * 17) / 255.0
            a = 1.0
        case 6: // RGB (24-bit)
            r = Double((int >> 16) & 0xFF) / 255.0
            g = Double((int >> 8) & 0xFF) / 255.0
            b = Double(int & 0xFF) / 255.0
            a = 1.0
        case 8: // ARGB (32-bit)
            a = Double((int >> 24) & 0xFF) / 255.0
            r = Double((int >> 16) & 0xFF) / 255.0
            g = Double((int >> 8) & 0xFF) / 255.0
            b = Double(int & 0xFF) / 255.0
        default:
            r = 1.0
            g = 1.0
            b = 1.0
            a = 1.0
        }
        
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a * opacity)
    }
    
    enum Text {
        static var warning: Color = Color(hex: "945C25")
        static var error: Color = Color(hex: "BF0020")
        static var success: Color = Color(hex: "007D2A")
        static var normal: Color = Color(hex: "000000", opacity: 0.55)
    }
    
    enum Button {
        enum Header {
            static var foreground: Color = Color(hex: "005AD9")
            static var background: Color = .black.opacity(0.05)
        }
        
        enum Buy {
            static var enabledForeground: Color = Color(hex: "000000", opacity: 0.9)
            static var enabledBackground: Color = Color(hex: "E5ACD4")
            static var disabledForeground: Color = Color(hex: "000000", opacity: 0.30)
            static var disabledBackground: Color = Color(hex: "000000", opacity: 0.05)
        }
        
        enum Authorization {
            static var authorizedForeground: Color = .black
            static var authorizedBackground: Color = Color(hex: "000000", opacity: 0.05)
            static var notAuthorizedForeground: Color = Color(hex: "000000", opacity: 0.9)
            static var notAuthorizedBackground: Color = Color(hex: "E5ACD4")
        }
        
        enum Dismiss {
            static var foreground: Color = .black
            static var background: Color = Color(hex: "000000", opacity: 0.05)
        }
    }
    
    enum Permissions {
        static var titleColor: Color = .black
        static var descriptionColor: Color = Color(hex: "000000", opacity: 0.55)
        static var iconColor: Color = Color(hex: "000000", opacity: 0.42)
    }
}
