//
//  PrimaryButton.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import SwiftUI

struct PrimaryButton: View {
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.brown)
                .foregroundStyle(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 18)
                )
        }
    }
}


