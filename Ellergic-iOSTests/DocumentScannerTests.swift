//
//  DocumentScannerTests.swift
//  Ellergic-iOSTests

import XCTest
import VisionKit
@testable import Ellergic_iOS


@MainActor
final class DocumentScannerTests: XCTestCase {
    var mockDocumentScanner: DocumentScannerViewModel!
    var mockBounds: BoundsItem!
    var mockBarcodeItem: BarcodeItem!

    override func setUpWithError() throws {
        mockDocumentScanner = DocumentScannerViewModel(networkingService: MockNetworkingService())

        mockBounds = BoundsItem(
            topLeft: CGPoint(x: 89.29, y: 537.40),
            topRight: CGPoint(x: 212.94, y: 537.40),
            bottomRight: CGPoint(x: 87.00, y: 600.11),
            bottomLeft: CGPoint(x: 210.94, y: 600.11)
        )

        mockBarcodeItem = BarcodeItem(
            id: UUID(),
            bounds: mockBounds,
            payloadStringValue: "01010101010"
        )
    }

    override func tearDownWithError() throws {
        mockDocumentScanner = nil
    }

    func testProcessItemSuccess() {
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

    func testProcessItemFailure() {
        let emptyBarcodeItem = BarcodeItem(
            id: UUID(),
            bounds: mockBounds,
            payloadStringValue: nil)

        XCTAssertFalse(mockDocumentScanner.showModal)
        XCTAssertNil(mockDocumentScanner.returnedResults)

        let expectation = XCTestExpectation(description: "API call completes")

        mockDocumentScanner.processItem(item: emptyBarcodeItem) {
            expectation.fulfill()
        }

        XCTAssertFalse(mockDocumentScanner.showModal)
        XCTAssertNil(mockDocumentScanner.returnedResults)
    }
}
