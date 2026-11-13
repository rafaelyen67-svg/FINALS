//
//  QRScannerView.swift
//  MilitiaCafe
//
//  Created by Mac-LAB on 9/17/26.
//

import SwiftUI
import AVFoundation

struct QRScannerView: View {
    
    @EnvironmentObject var orderController: OrderController
    
    @StateObject private var qrController =
        QRController()
    
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
                
                QRScannerCameraView { code in
                    
                    qrController.scan(
                        code: code,
                        orderController: orderController
                    )
                }
                .frame(height: 400)
                .clipShape(
                    RoundedRectangle(cornerRadius: 20)
                )
                .padding()
                
                if let order = qrController.scannedOrder {
                    
                    VStack(spacing: 10) {
                        
                        Text("Order Found!")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.green)
                        
                        Text("Order #\(order.orderNumber)")
                            .font(.title3)
                            .foregroundStyle(.white)
                        
                        Text(order.customerName)
                            .foregroundStyle(.white)
                        
                        Text("Ready for pickup")
                            .foregroundStyle(.white.opacity(0.8))
                        
                        NavigationLink("View Order") {
                            OrderDetailView(
                                order: order
                            )
                        }
                        .padding()
                        .background(.white)
                        .foregroundStyle(AppTheme.brown)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 15)
                        )
                    }
                    .padding()
                    
                } else {
                    
                    Text(
                        "Point the camera at the customer's QR code."
                    )
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
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
    
    let onCodeScanned: (String) -> Void
    
    func makeUIViewController(
        context: Context
    ) -> ScannerViewController {
        
        let controller = ScannerViewController()
        
        controller.onCodeScanned = onCodeScanned
        
        return controller
    }
    
    func updateUIViewController(
        _ uiViewController: ScannerViewController,
        context: Context
    ) {
    }
}

class ScannerViewController: UIViewController,
                            AVCaptureMetadataOutputObjectsDelegate {
    
    var onCodeScanned: ((String) -> Void)?
    
    private let session = AVCaptureSession()
    private var hasScanned = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkCameraPermission()
    }
    
    private func checkCameraPermission() {
        
        switch AVCaptureDevice.authorizationStatus(
            for: .video
        ) {
            
        case .authorized:
            setupCamera()
            
        case .notDetermined:
            
            AVCaptureDevice.requestAccess(
                for: .video
            ) { granted in
                
                DispatchQueue.main.async {
                    
                    if granted {
                        self.setupCamera()
                    }
                }
            }
            
        default:
            break
        }
    }
    
    private func setupCamera() {
        
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
        
        let previewLayer =
            AVCaptureVideoPreviewLayer(
                session: session
            )
        
        previewLayer.videoGravity =
            .resizeAspectFill
        
        previewLayer.frame =
            view.layer.bounds
        
        view.layer.addSublayer(previewLayer)
        
        session.startRunning()
    }
    
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        
        guard !hasScanned else {
            return
        }
        
        guard let object = metadataObjects.first as?
                AVMetadataMachineReadableCodeObject,
              let value = object.stringValue else {
            return
        }
        
        hasScanned = true
        
        onCodeScanned?(value)
        
        session.stopRunning()
    }
}


