import SwiftUI
import AVFoundation

struct QRScannerView: View {
    @EnvironmentObject private var orderController: OrderController
    @StateObject private var qrController = QRController()
    @State private var manualCode = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                VStack(spacing: 7) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.system(size: 35))
                        .foregroundStyle(AppTheme.gold)
                    Text("Pickup check-in")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundStyle(AppTheme.espresso)
                    Text("Scan the customer's order QR to find their pickup.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                QRScannerCameraView { code in
                    qrController.scan(code: code, orderController: orderController)
                }
                .frame(height: 310)
                .clipShape(RoundedRectangle(cornerRadius: 23, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 23)
                        .stroke(AppTheme.gold.opacity(0.45), lineWidth: 2)
                        .padding(18)
                        .allowsHitTesting(false)
                }

                if let order = qrController.scannedOrder {
                    foundOrder(order)
                } else if !qrController.scannedCode.isEmpty {
                    Label("No order found for code: \(qrController.scannedCode)", systemImage: "xmark.circle.fill")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.red)
                } else {
                    Text("Camera access is needed to scan. You can also enter the order code below.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                HStack(spacing: 10) {
                    TextField("Enter order code (e.g. MIL1234)", text: $manualCode)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .padding(13)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                    Button("Find") {
                        qrController.scan(code: manualCode.trimmingCharacters(in: .whitespacesAndNewlines), orderController: orderController)
                    }
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 13)
                    .background(AppTheme.brown)
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                }

                if !qrController.scannedCode.isEmpty {
                    Button {
                        qrController.clearScan()
                        manualCode = ""
                    } label: {
                        Label("Scan another order", systemImage: "arrow.clockwise")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppTheme.brown)
                    }
                    .padding(.top, 2)
                }
            }
            .padding(20)
            .frame(maxWidth: 560)
            .frame(maxWidth: .infinity)
        }
        .background(AppTheme.paper.ignoresSafeArea())
        .navigationTitle("QR pickup")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func foundOrder(_ order: Order) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Order found", systemImage: "checkmark.seal.fill")
                    .font(.headline)
                    .foregroundStyle(AppTheme.sage)
                Spacer()
                Text(order.status.uppercased())
                    .font(.caption2.weight(.heavy))
                    .tracking(0.7)
                    .foregroundStyle(AppTheme.brown)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(AppTheme.cream)
                    .clipShape(Capsule())
            }
            Text("#\(order.orderNumber)")
                .font(.system(size: 24, weight: .bold, design: .serif))
                .foregroundStyle(AppTheme.espresso)
            Text(order.customerName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            NavigationLink {
                OrderDetailView(order: order)
            } label: {
                HStack {
                    Text("View pickup details")
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
                .padding(14)
                .background(AppTheme.brown)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(17)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct QRScannerCameraView: UIViewControllerRepresentable {
    let onCodeScanned: (String) -> Void

    func makeUIViewController(context: Context) -> ScannerViewController {
        let controller = ScannerViewController()
        controller.onCodeScanned = onCodeScanned
        return controller
    }

    func updateUIViewController(_ controller: ScannerViewController, context: Context) {
        controller.resizePreview()
    }

    static func dismantleUIViewController(_ controller: ScannerViewController, coordinator: ()) {
        controller.stopCamera()
    }
}

final class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var onCodeScanned: ((String) -> Void)?
    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var hasScanned = false
    private var isConfigured = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(AppTheme.espresso)
        checkCameraPermission()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreview()
    }

    func resizePreview() {
        previewLayer?.frame = view.bounds
    }

    func stopCamera() {
        if session.isRunning {
            DispatchQueue.global(qos: .userInitiated).async { [session] in
                session.stopRunning()
            }
        }
    }

    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureAndStart()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async { self?.configureAndStart() }
            }
        default:
            break
        }
    }

    private func configureAndStart() {
        guard !isConfigured,
              let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera) else { return }

        session.beginConfiguration()
        defer { session.commitConfiguration() }
        guard session.canAddInput(input) else { return }
        session.addInput(input)

        let output = AVCaptureMetadataOutput()
        guard session.canAddOutput(output) else { return }
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: .main)
        guard output.availableMetadataObjectTypes.contains(.qr) else { return }
        output.metadataObjectTypes = [.qr]

        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(layer, at: 0)
        previewLayer = layer
        resizePreview()
        isConfigured = true
        DispatchQueue.global(qos: .userInitiated).async { [session] in
            if !session.isRunning { session.startRunning() }
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard !hasScanned,
              let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let code = object.stringValue else { return }
        hasScanned = true
        onCodeScanned?(code)
        stopCamera()
    }
}
