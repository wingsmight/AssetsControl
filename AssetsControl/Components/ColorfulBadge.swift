//
//  ColorfulBadge.swift
//
//  Created by Igoryok
//

import SwiftUI

struct ColorfulBadgeList: View {
    var tabBadges: [TabBadge]
    var geometry: GeometryProxy

    internal init(tabBadges: [TabBadge], geometry: GeometryProxy) {
        self.tabBadges = tabBadges
        self.geometry = geometry
    }

    var body: some View {
        ForEach(0..<tabBadges.count, id: \.self) { tabIndex in
            ColorfulBadge(tabIndex: tabIndex, tabCount: tabBadges.count, tabBadge: tabBadges[tabIndex], geometry: geometry)
                .hidden(!tabBadges[tabIndex].isShowing)
        }
    }
}

struct ColorfulCountBadgeList: View {
    var tabBadges: [CountTabBadge]
    var geometry: GeometryProxy

    internal init(tabBadges: [CountTabBadge], geometry: GeometryProxy) {
        self.tabBadges = tabBadges
        self.geometry = geometry
    }

    var body: some View {
        ForEach(0..<tabBadges.count, id: \.self) { tabIndex in
            ColorfulCountBadge(tabIndex: tabIndex, tabCount: tabBadges.count, tabBadge: tabBadges[tabIndex], geometry: geometry)
                .hidden(!tabBadges[tabIndex].isShowing)
        }
    }
}

struct ColorfulBadge: View {
    let badgeSize: CGFloat = 10
    let badgeSpaceWidth: CGFloat = 40
    let badgeSpaceHeight: CGFloat = 20
    let yOffset: CGFloat = -26

    var tabIndex: Int
    var tabCount: Int
    var tabBadge: TabBadge
    var geometry: GeometryProxy

    var body: some View {
        HStack {
            Circle()
                .fill(tabBadge.backgroundColor)
                .frame(width: badgeSize, height: badgeSize)

            Spacer()
        }
        .frame(width: badgeSpaceWidth, height: badgeSize)
        .frame(minWidth: badgeSpaceWidth / 2, maxWidth: badgeSpaceWidth, minHeight: badgeSpaceHeight, maxHeight: badgeSpaceHeight)
        .offset(x: calculateOffset(tabIndex, geometry.size.width, tabCount), y: yOffset)
        .allowsHitTesting(false)
    }

    func calculateOffset(_ badgeIndex: Int, _ viewWidth: CGFloat, _ tabCount: Int) -> CGFloat {
        4.0 + ((2.0 * CGFloat(badgeIndex)) + 1.0) * (viewWidth / (2.0 * CGFloat(tabCount)))
    }
}

struct ColorfulCountBadge: View {
    let badgeWidth: CGFloat = 40
    let badgeHeight: CGFloat = 20
    let badgeSpaceWidth: CGFloat = 40
    let badgeSpaceHeight: CGFloat = 20
    let yOffset: CGFloat = -26

    var tabIndex: Int
    var tabCount: Int
    var tabBadge: CountTabBadge
    var geometry: GeometryProxy

    var body: some View {
        HStack {
            Text("\(tabBadge.count)")
                .foregroundColor(.black)
                .font(Font.system(size: 12))
                .multilineTextAlignment(.leading)
                .background(
                    Capsule()
                        .foregroundColor(tabBadge.backgroundColor)
                        .padding(.horizontal, -6)
                        .padding(.vertical, -1)
                )

            Spacer()
        }
        .frame(width: badgeWidth, height: badgeHeight)
        .frame(minWidth: badgeSpaceWidth / 2, maxWidth: badgeSpaceWidth, minHeight: badgeSpaceHeight, maxHeight: badgeSpaceHeight)
        .offset(x: calculateOffset(tabIndex, geometry.size.width, tabCount), y: yOffset)
        .opacity(tabBadge.count <= 0 ? 0 : 1)
        .allowsHitTesting(false)
    }

    func calculateOffset(_ badgeIndex: Int, _ viewWidth: CGFloat, _ tabCount: Int) -> CGFloat {
        4.0 + ((2.0 * CGFloat(badgeIndex)) + 1.0) * (viewWidth / (2.0 * CGFloat(tabCount)))
    }
}

struct TabBadge: Equatable {
    var backgroundColor: Color
    var isShowing: Bool = true
}

struct CountTabBadge {
    var count: Int
    var backgroundColor: Color
    var isShowing: Bool = true
}

struct ColorfulBadge_Previews: PreviewProvider {
    private static let tabBadges: [TabBadge] = [
        TabBadge(backgroundColor: .red, isShowing: true),
        TabBadge(backgroundColor: .green, isShowing: true),
        TabBadge(backgroundColor: .blue, isShowing: false),
    ]

    static var previews: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                TabView {
                    EmptyView()
                        .tabItem {
                            Label("Left", systemImage: "heart")
                        }

                    EmptyView()
                        .tabItem {
                            Label("Middle", systemImage: "heart")
                        }

                    EmptyView()
                        .tabItem {
                            Label("Right", systemImage: "heart")
                        }
                }

                ColorfulBadgeList(tabBadges: tabBadges, geometry: geometry)
            }
        }
    }
}

struct ColorfulCountBadge_Previews: PreviewProvider {
    private static let tabBadges: [CountTabBadge] = [
        CountTabBadge(count: 1, backgroundColor: .red, isShowing: true),
        CountTabBadge(count: 10, backgroundColor: .green, isShowing: true),
        CountTabBadge(count: 20, backgroundColor: .blue, isShowing: false),
    ]

    static var previews: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                TabView {
                    EmptyView()
                        .tabItem {
                            Label("Left", systemImage: "heart")
                        }

                    EmptyView()
                        .tabItem {
                            Label("Middle", systemImage: "heart")
                        }

                    EmptyView()
                        .tabItem {
                            Label("Right", systemImage: "heart")
                        }
                }

                ColorfulCountBadgeList(tabBadges: tabBadges, geometry: geometry)
            }
        }
    }
}
