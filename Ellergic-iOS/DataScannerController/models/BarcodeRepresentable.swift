//
//  BarcodeRepresentable.swift
//  Ellergic-iOS

import Foundation
import VisionKit

protocol BarcodeRepresentable {
    var id: UUID { get }
    var bounds: Bounds { get }
    var payloadStringValue: String? { get }
}

struct BarcodeItem: BarcodeRepresentable {
    var id: UUID
    var bounds: Bounds
    var payloadStringValue: String?
    
    init(id: UUID, bounds: Bounds, payloadStringValue: String? = nil) {
        self.id = id
        self.bounds = bounds
        self.payloadStringValue = payloadStringValue
    }
}

protocol Bounds {
    var topLeft: CGPoint { get }
    var topRight: CGPoint { get }
    var bottomRight: CGPoint { get }
    var bottomLeft: CGPoint { get }
}

struct BoundsItem: Bounds {
    var topLeft: CGPoint
    var topRight: CGPoint
    var bottomRight: CGPoint
    var bottomLeft: CGPoint
}

func convertFromRecItemBounds(item: RecognizedItem.Bounds) -> Bounds {
    BoundsItem(
        topLeft: item.topLeft,
        topRight: item.topRight,
        bottomRight: item.bottomRight,
        bottomLeft: item.bottomLeft
    )
}

