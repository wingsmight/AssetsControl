//
//  Symbol.swift
//  AssetsControl
//
//  Created by Igoryok on 28.03.2023.
//

import SwiftUI

enum Symbol: String, CaseIterable, Identifiable, Codable, Hashable {
    // Generic
    case banknote
    case bitcoin = "bitcoinsign.circle"
    case creditCard = "creditcard"
    case bag
    case gift
    case bank = "building.columns"
    case stocks = "chart.line.uptrend.xyaxis" // TODO: Future: Hide this option when adding native stocks support in app

    // Living
    case house
    case building
    case car
    case fuelPump = "fuelpump"
    case bus
    case tram
    case airplane
    case sailboat
    case bed = "bed.double"

    // Household
    case wifi
    case flame
    case snowflake
    case drop
    case bolt
    case hammer
    case wrench
    case lightbulb
    case chair = "chair.lounge"
    case basket

    // Other
    case wineglass
    case pills
    case stethoscope
    case pawPrint = "pawprint"
    case teddybear
    case leaf
    case graduationCap = "graduationcap"
    case doc = "doc.text"
    case ticket
    case takeoutBag = "takeoutbag.and.cup.and.straw"
    case tShirt = "tshirt"
    case shippingBox = "shippingbox"
    case iPhone = "iphone"

    // Digital
    case iCloud = "icloud"
    case music = "music.note"
    case tv
    case gameController = "gamecontroller"
    case newspaper
    case figure = "figure.arms.open"
    case figureRun = "figure.run"
    case family = "figure.2.and.child.holdinghands"
    case app = "app.badge"

    // Shapes
    case star

    static let defaultSymbol = Symbol.banknote

    var id: Self { self }

    var suggestedTitle: String {
        switch self {
        case .banknote:
            return "Cash"
        case .bitcoin:
            return "Bitcoin"
        case .creditCard:
            return "Credit Card"
        case .bag:
            return "Shopping"
        case .gift:
            return "Gifts"
        case .bank:
            return "Bank Account"
        case .stocks:
            return "Stocks"
        case .house:
            return "House"
        case .building:
            return "Work"
        case .car:
            return "Car Insurance"
        case .fuelPump:
            return "Fuel"
        case .bus:
            return "Bus Pass"
        case .tram:
            return "Train Pass"
        case .airplane:
            return "Travel"
        case .sailboat:
            return "Boat"
        case .bed:
            return "Hotels"
        case .wifi:
            return "Internet"
        case .flame:
            return "Heating"
        case .snowflake:
            return "Air Conditioning"
        case .drop:
            return "Water"
        case .bolt:
            return "Electricity"
        case .hammer:
            return "Renovations"
        case .wrench:
            return "Repairs"
        case .lightbulb:
            return "Utilities"
        case .chair:
            return "Furnature"
        case .basket:
            return "Basket"
        case .wineglass:
            return "Alcohol"
        case .stethoscope:
            return "Doctor"
        case .pills:
            return "Medicine"
        case .pawPrint:
            return "Pet Supplies"
        case .teddybear:
            return "Children"
        case .leaf:
            return "Garden"
        case .graduationCap:
            return "School"
        case .doc:
            return "Taxes"
        case .ticket:
            return "Entertainment"
        case .takeoutBag:
            return "Take Out"
        case .tShirt:
            return "Clothing"
        case .shippingBox:
            return "Online Shopping"
        case .iPhone:
            return "Phone"
        case .iCloud:
            return "Cloud Storage"
        case .music:
            return "Music"
        case .tv:
            return "TV"
        case .gameController:
            return "Games"
        case .newspaper:
            return "News"
        case .figure:
            return "Personal"
        case .figureRun:
            return "Fitness"
        case .family:
            return "Family"
        case .app:
            return "App Subscriptions"
        case .star:
            return ""
        }
    }

    var color: Color {
        switch self {
        case .banknote:
            return .green
        case .bitcoin:
            return .orange
        case .creditCard:
            return .mint
        case .bag:
            return .mint
        case .gift:
            return .red
        case .bank:
            return .green
        case .stocks:
            return .blue
        case .house:
            return .brown
        case .building:
            return .cyan
        case .car:
            return .blue
        case .fuelPump:
            return .blue
        case .bus:
            return .blue
        case .tram:
            return .blue
        case .airplane:
            return .blue
        case .sailboat:
            return .blue
        case .bed:
            return .brown
        case .wifi:
            return .blue
        case .flame:
            return .orange
        case .snowflake:
            return .cyan
        case .drop:
            return .blue
        case .bolt:
            return .yellow
        case .hammer:
            return .orange
        case .wrench:
            return .gray
        case .lightbulb:
            return .yellow
        case .chair:
            return .brown
        case .basket:
            return .yellow
        case .wineglass:
            return .purple
        case .stethoscope:
            return .pink
        case .pills:
            return .pink
        case .pawPrint:
            return .brown
        case .teddybear:
            return .brown
        case .leaf:
            return .green
        case .graduationCap:
            return .indigo
        case .doc:
            return .gray
        case .ticket:
            return .purple
        case .takeoutBag:
            return .orange
        case .tShirt:
            return .purple
        case .shippingBox:
            return .brown
        case .iPhone:
            return .blue
        case .iCloud:
            return .cyan
        case .music:
            return .pink
        case .tv:
            return .indigo
        case .gameController:
            return .red
        case .newspaper:
            return .pink
        case .figure:
            return .blue
        case .figureRun:
            return .green
        case .family:
            return .blue
        case .app:
            return .blue
        case .star:
            return .gray
        }
    }
}
