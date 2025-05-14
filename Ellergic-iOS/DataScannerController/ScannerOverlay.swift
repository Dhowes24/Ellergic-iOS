//
//  ScannerOverlay.swift
//  Ellergic-iOS

import Foundation
import UIKit
import VisionKit

class RoundedRectLabel: UIView {
    private let cornerLength: CGFloat = 20
    private let lineWidth: CGFloat = 4
    private let lineColor: UIColor = .systemYellow
    private var shapeLayer: CAShapeLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        drawCorners()
    }

    private func drawCorners() {
        shapeLayer?.removeFromSuperlayer()

        let path = UIBezierPath()
        let rect = self.bounds

        // Top-left
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerLength))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX + cornerLength, y: rect.minY))

        // Top-right
        path.move(to: CGPoint(x: rect.maxX - cornerLength, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerLength))

        // Bottom-right
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerLength))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - cornerLength, y: rect.maxY))

        // Bottom-left
        path.move(to: CGPoint(x: rect.minX + cornerLength, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cornerLength))

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round

        self.layer.addSublayer(shapeLayer)
        self.shapeLayer = shapeLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        drawCorners()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

func getRoundBoxFrame(bounds: Bounds) -> CGRect {
    let frame = CGRect(
        x: bounds.topLeft.x,
        y: bounds.topLeft.y,
        width: abs(bounds.topRight.x - bounds.topLeft.x) + 15,
        height: abs(bounds.topLeft.y - bounds.bottomLeft.y) + 15
    )
    return frame
}
