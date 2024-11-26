//
//  PermissionRow.swift
//  MobilePaymentsSwiftUIExample
//
//  Created by Tamer Bader on 11/8/24.
//

import Foundation
import SwiftUI

struct PermissionsRow: View {
    
    enum PermissionsIcon: String {
        case deselected = "square"
        case selected = "checkmark.square"
    }
    
    let title: String
    let description: String
    var isPermissionGranted: Bool
    let tapAction: (() -> Void)?
    
    var body: some View {
        HStack {
            VStack(
                alignment: .leading,
                spacing: 5,
                content: {
                    Text(title)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.Permissions.titleColor)
                    
                    Text(description)
                        .font(.system(size: 14, weight: .regular))
                        .lineSpacing(5)
                        .foregroundStyle(Color.Permissions.descriptionColor)
                }
            )
            .padding(.top, 16)
            
            Spacer()
            
            Image(systemName: isPermissionGranted ? PermissionsIcon.selected.rawValue : PermissionsIcon.deselected.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(Color.Permissions.iconColor)
                .padding(.leading, 16)
                .onTapGesture {
                    tapAction?()
                }
        }
        .padding(.bottom, 15)
    }
}
