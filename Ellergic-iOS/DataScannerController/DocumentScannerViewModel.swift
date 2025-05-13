//
//  DocumentScannerViewModel.swift
//  Ellergic-iOS

import Foundation
import VisionKit
import SwiftUI
import Combine

@MainActor
class DocumentScannerViewModel: ObservableObject {
    @Published var returnedResults: ProductByUpcResults?
    @Published var roundBoxMappings: [UUID: UIView] = [:]
    @Published var showModal: Bool = false

    private var cancellables = Set<AnyCancellable>()

    let spoonacularProvider: SpoonacularManager
    var scannerViewController: DataScannerViewController = DataScannerViewController(
        recognizedDataTypes: [.barcode()],
        qualityLevel: .accurate,
        recognizesMultipleItems: false,
        isHighFrameRateTrackingEnabled: false,
        isHighlightingEnabled: false
    )

    init(networkingService: NetworkingService = SpoonacularNetworkService()) {
        self.spoonacularProvider = SpoonacularManager(networkingService: networkingService)
        observeModalState()
    }

    func callAPI(for UPC: String?) async throws {
        if let UPC {
            self.returnedResults = try await spoonacularProvider.findProductIngredients(for: UPC)
        } else {
            //TODO: Eventual Error handling
            // Test UPC for Cadbury Eggs
            self.returnedResults = try await spoonacularProvider.findProductIngredients(for: "0074890001959")
        }
    }

    private func observeModalState() {
        $showModal
            .sink { showingModal in
                if showingModal {
                    self.scannerViewController.stopScanning()
                } else {
                    try? self.scannerViewController.startScanning()
                }
            }
            .store(in: &cancellables)
    }

    func processItem(item: BarcodeRepresentable, completion: (() -> Void)? = nil) {
        let frame = getRoundBoxFrame(bounds: item.bounds)
        addRoundBoxToItem(frame: frame, text: item.payloadStringValue ?? "Cannot determine", id: item.id)

            Task{
                self.showModal = true
                try? await callAPI(for: item.payloadStringValue)
                completion?()
            }
    }

    func addRoundBoxToItem(frame: CGRect, text: String, id: UUID) {
        let roundedRectView = RoundedRectLabel(frame: frame)
        roundedRectView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            roundedRectView.alpha = 1
        }
        scannerViewController.overlayContainerView.addSubview(roundedRectView)
        roundBoxMappings[id] = roundedRectView
    }

    func removeRoundBoxFromItem(itemID: UUID) {
        if let roundBoxView = roundBoxMappings[itemID] {
            if roundBoxView.superview != nil {
                roundBoxView.removeFromSuperview()
                roundBoxMappings.removeValue(forKey: itemID)
            }
        }
    }

//    func updateRoundBoxToItem(item: RecognizedItem) {
//        if let roundBoxView = roundBoxMappings[item.id] {
//            if roundBoxView.superview != nil {
//                let frame = getRoundBoxFrame(item: item)
//                roundBoxView.frame = frame
//            }
//        }
//    }
}
