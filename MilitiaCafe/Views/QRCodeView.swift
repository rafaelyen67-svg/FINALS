//
//  QRCodeView.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import SwiftUI
import AVFoundation

struct QRScannerView: View {
    
    @State private var scannedCode = ""
    
    var body: some View {
        
        ZStack {
            
            Color.black
                .ignoresSafeArea()
            
            VStack {
                
                Text("Scan Order QR")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)
                    .padding()
                
                QRScannerCameraView(scannedCode: $scannedCode)
                    .frame(height: 400)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )
                    .padding()
                
                if scannedCode.isEmpty {
                    
                    Text("Point the camera at the customer's QR code.")
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                } else {
                    
                    VStack(spacing: 10) {
                        
                        Text("Order Found!")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.green)
                        
                        Text("Order #\(scannedCode)")
                            .font(.title3)
                            .foregroundStyle(.white)
                        
                        Text("Ready for pickup")
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding()
                }
                
                Spacer()
            }
        }
        .navigationTitle("Scan Order")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QRScannerCameraView: UIViewControllerRepresentable {
    
    @Binding var scannedCode: String
    
    func makeUIViewController(
        context: Context
    ) -> QRScannerViewController {
        
        let controller = QRScannerViewController()
        controller.onCodeScanned = { code in
            scannedCode = code
        }
        
        return controller
    }
    
    func updateUIViewController(
        _ uiViewController: QRScannerViewController,
        context: Context
    ) {
    }
}

class QRScannerViewController: UIViewController,
                               AVCaptureMetadataOutputObjectsDelegate {
    
    var onCodeScanned: ((String) -> Void)?
    
    private let session = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
    }
    
    func setupCamera() {
        
        guard let camera = AVCaptureDevice.default(
            for: .video
        ) else {
            return
        }
        
        guard let input = try? AVCaptureDeviceInput(
            device: camera
        ) else {
            return
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        let output = AVCaptureMetadataOutput()
        
        if session.canAddOutput(output) {
            
            session.addOutput(output)
            
            output.setMetadataObjectsDelegate(
                self,
                queue: DispatchQueue.main
            )
            
            output.metadataObjectTypes = [
                .qr
            ]
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(
            session: session
        )
        
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        
        view.layer.addSublayer(previewLayer)
        
        session.startRunning()
    }
    
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        
        guard let object = metadataObjects.first as?
                AVMetadataMachineReadableCodeObject,
              let value = object.stringValue else {
            return
        }
        
        onCodeScanned?(value)
        
        session.stopRunning()
    }
}

