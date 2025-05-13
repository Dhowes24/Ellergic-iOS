//
//  DocumentScannerTests.swift
//  Ellergic-iOSTests

import XCTest
import VisionKit
@testable import Ellergic_iOS


@MainActor
final class DocumentScannerTests: XCTestCase {
    var mockDocumentScanner: DocumentScannerViewModel!

    override func setUpWithError() throws {
        mockDocumentScanner = DocumentScannerViewModel(networkingService: MockNetworkingService())
    }

    override func tearDownWithError() throws {
        mockDocumentScanner = nil
    }

    func testProcessItem() {
        let mockBounds = BoundsItem(
            topLeft: CGPoint(x: 89.29, y: 537.40),
            topRight: CGPoint(x: 212.94, y: 537.40),
            bottomRight: CGPoint(x: 87.00, y: 600.11),
            bottomLeft: CGPoint(x: 210.94, y: 600.11)
        )

        let mockBarcodeItem = BarcodeItem(
            id: UUID(),
            bounds: mockBounds,
            payloadStringValue: "01010101010"
        )

        XCTAssertFalse(mockDocumentScanner.showModal)
        XCTAssertNil(mockDocumentScanner.returnedResults)

        let expectation = XCTestExpectation(description: "API call completes")

        mockDocumentScanner.processItem(item: mockBarcodeItem) {
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2.0)

        // Then assert expected changes
        XCTAssertTrue(mockDocumentScanner.showModal)
        XCTAssertNotNil(mockDocumentScanner.returnedResults)
    }
}
