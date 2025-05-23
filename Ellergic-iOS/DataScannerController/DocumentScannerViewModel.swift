//
//  DocumentScannerViewModel.swift
//  Ellergic-iOS

import Foundation
import VisionKit
import SwiftUI
import Combine

@MainActor
class DocumentScannerViewModel: ObservableObject {
    @Published var returnedResults: FoodResponse?
    @Published var roundBoxMappings: [UUID: UIView] = [:]
    @Published var showModal: Bool = false

    private var cancellables = Set<AnyCancellable>()

    let ingredientApiManager: IngredientApiManager
    var scannerViewController: DataScannerViewController = DataScannerViewController(
        recognizedDataTypes: [.barcode()],
        qualityLevel: .accurate,
        recognizesMultipleItems: false,
        isHighFrameRateTrackingEnabled: false,
        isHighlightingEnabled: false
    )

    init(networkingService: NetworkingService = IngredientApiNetworkService()) {
        self.ingredientApiManager = IngredientApiManager(networkingService: networkingService)
        observeModalState()
    }

    func callAPI(for UPC: String?) async throws {
        if let UPC {
            self.returnedResults = try await ingredientApiManager.findProductIngredients(for: UPC)
        } else {
            throw IngredientManagerError.invalidUPC
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
                do {
                    try await callAPI(for: item.payloadStringValue)
                    self.showModal = true
                    completion?()
                } catch {
                    print("Error calling API: \(error.localizedDescription)")
                    throw IngredientManagerError.failedToFetchIngredients
                }
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
