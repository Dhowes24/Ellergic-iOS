//
//  Untitled.swift
//  Ellergic-iOS

import Foundation
import VisionKit
import SwiftUI
import Combine

@MainActor
class DocumentScannerViewModel: ObservableObject {
    let spoonacularProvider = SpoonacularManager(networkingService: MockNetworkingService())

    @Published var returnedResults: ProductByUpcResults?
    @Published var roundBoxMappings: [UUID: UIView] = [:]
    @Published var showModal: Bool = false

    private var cancellables = Set<AnyCancellable>()

    var scannerViewController: DataScannerViewController = DataScannerViewController(
        recognizedDataTypes: [.barcode()],
        qualityLevel: .accurate,
        recognizesMultipleItems: false,
        isHighFrameRateTrackingEnabled: false,
        isHighlightingEnabled: false
    )

    init() {
        observeModalState()
    }

    func callAPI() async throws {
        self.returnedResults = try await spoonacularProvider.findProductIngredients()
    }

    private func observeModalState() {
        $showModal
            .sink { newValue in
                if !newValue {
                    try? self.scannerViewController.startScanning()
                } else {
                    self.scannerViewController.stopScanning()
                }
            }
            .store(in: &cancellables)
    }

    func processItem(item: RecognizedItem) {
        switch item {
        case .text:
            print("Should not happen")
        case .barcode(let code):
            print(code.payloadStringValue ?? "Could not determine")
            let frame = getRoundBoxFrame(item: item)
            addRoundBoxToItem(frame: frame, text: code.payloadStringValue ?? "Cannot determine", item: item)
            DispatchQueue.main.async {
                self.showModal = true
            }
        @unknown default:
            print("Should not happen")
        }
    }

    func addRoundBoxToItem(frame: CGRect, text: String, item: RecognizedItem) {
        let roundedRectView = RoundedRectLabel(frame: frame)
        roundedRectView.setText(text: text)
        scannerViewController.overlayContainerView.addSubview(roundedRectView)
        roundBoxMappings[item.id] = roundedRectView
    }

    func removeRoundBoxFromItem(item: RecognizedItem) {
        if let roundBoxView = roundBoxMappings[item.id] {
            if roundBoxView.superview != nil {
                roundBoxView.removeFromSuperview()
                roundBoxMappings.removeValue(forKey: item.id)
            }
        }
    }

    func updateRoundBoxToItem(item: RecognizedItem) {
        if let roundBoxView = roundBoxMappings[item.id] {
            if roundBoxView.superview != nil {
                let frame = getRoundBoxFrame(item: item)
                roundBoxView.frame = frame
            }
        }
    }

    func getRoundBoxFrame(item: RecognizedItem) -> CGRect {
        let frame = CGRect(
            x: item.bounds.topLeft.x,
            y: item.bounds.topLeft.y,
            width: abs(item.bounds.topRight.x - item.bounds.topLeft.x) + 15,
            height: abs(item.bounds.topLeft.y - item.bounds.bottomLeft.y) + 15
        )
        return frame
    }
}
