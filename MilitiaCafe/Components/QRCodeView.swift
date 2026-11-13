//
//  QRCodeView.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    
    let code: String
    
    var body: some View {
        
        Image(uiImage: generateQRCode())
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .frame(width: 220, height: 220)
    }
    
    private func generateQRCode() -> UIImage {
        
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(code.utf8)
        
        guard let outputImage = filter.outputImage else {
            return UIImage()
        }
        
        let scaledImage = outputImage.transformed(
            by: CGAffineTransform(
                scaleX: 10,
                y: 10
            )
        )
        
        guard let cgImage = context.createCGImage(
            scaledImage,
            from: scaledImage.extent
        ) else {
            return UIImage()
        }
        
        return UIImage(cgImage: cgImage)
    }
}


