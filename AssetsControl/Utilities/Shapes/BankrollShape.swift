//
//  BankrollShape.swift
//
//  Created by Igoryok
//

import SwiftUI

struct BankrollShape: Shape {
    func path(in rect: CGRect) -> Path {
        let height = rect.height < rect.width ? rect.height : rect.width
        let width = rect.width
        let cornerCircleRadius = height / 3.0
        let cornerCircleDistanceY = height - (cornerCircleRadius * 2.0)
        let cornerCircleDistanceX = width - (cornerCircleRadius * 2.0)

        let startPoint = CGPoint(x: rect.minX, y: rect.minY)
        var path = Path()

        path.move(to: startPoint)
        path.move(to: CGPoint(x: startPoint.x, y: startPoint.y + cornerCircleRadius))
        path.addArc(center: startPoint, radius: cornerCircleRadius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 0), clockwise: true)
        path.addLine(to: CGPoint(x: path.currentPoint!.x + cornerCircleDistanceX, y: path.currentPoint!.y))
        path.addArc(center: CGPoint(x: rect.maxX, y: rect.minY), radius: cornerCircleRadius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 90), clockwise: true) // why clockwise?
        path.addLine(to: CGPoint(x: path.currentPoint!.x, y: path.currentPoint!.y + cornerCircleDistanceY))
        path.addArc(center: CGPoint(x: rect.maxX, y: rect.maxY), radius: cornerCircleRadius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: -180), clockwise: true) // why clockwise?
        path.addLine(to: CGPoint(x: path.currentPoint!.x - cornerCircleDistanceX, y: path.currentPoint!.y))
        path.addArc(center: CGPoint(x: rect.minX, y: rect.maxY), radius: cornerCircleRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: -90), clockwise: true) // why clockwise?
        path.addLine(to: CGPoint(x: path.currentPoint!.x, y: path.currentPoint!.y - cornerCircleDistanceY))

        return path
    }
}

struct BankrollShape_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(.green)
            
            BankrollShape()
                .fill(.white.opacity(0.5))
                .padding(6)
                
        }
        .frame(CGSize(width: 200, height: 100))
    }
}
