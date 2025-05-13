import SwiftUI
import VisionKit

@MainActor
struct DocumentScannerView: UIViewControllerRepresentable {

    @ObservedObject var viewModel: DocumentScannerViewModel

    init(viewModel: DocumentScannerViewModel) {
        self.viewModel = viewModel
    }

    var scannerViewController: DataScannerViewController = DataScannerViewController(
        recognizedDataTypes: [.barcode()],
        qualityLevel: .accurate,
        recognizesMultipleItems: false,
        isHighFrameRateTrackingEnabled: false,
        isHighlightingEnabled: false
    )

    func makeUIViewController(context: Context) -> DataScannerViewController {
        viewModel.scannerViewController.delegate = context.coordinator

        try? viewModel.scannerViewController.startScanning()

        return viewModel.scannerViewController
    }

    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        // Update any view controller settings here
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: DocumentScannerView
        var roundBoxMappings: [UUID: UIView] = [:]

        init(_ parent: DocumentScannerView) {
            self.parent = parent
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            processAddedItems(items: addedItems)
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            processRemovedItems(items: removedItems)
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
//            processUpdatedItems(items: updatedItems)
        }

        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
//            processItem(item: item)
        }


        func processAddedItems(items: [RecognizedItem]) {
            for item in items {
                switch item {
                case .text:
                    break
                case .barcode(let code):
                    let barcodeItem = BarcodeItem(
                        id: code.id,
                        bounds: convertFromRecItemBounds(item: code.bounds),
                        payloadStringValue: code.payloadStringValue)
                    parent.viewModel.processItem(item: barcodeItem)
                @unknown default:
                    break
                }
            }
        }

        func processRemovedItems(items: [RecognizedItem]) {
            for item in items {
                parent.viewModel.removeRoundBoxFromItem(itemID: item.id)
            }
        }

//        func processUpdatedItems(items: [RecognizedItem]) {
//            for item in items {
//                parent.viewModel.updateRoundBoxToItem(item: item)
//            }
//        }
    }
}
