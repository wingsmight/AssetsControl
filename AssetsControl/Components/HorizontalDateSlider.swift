//
//  HorizontalDateSlider.swift
//  Splus
//
//  Created by Igoryok on 12.02.2023.
//

import SwiftUI

struct HorizontalDateSlider: View {
    private let spacing: CGFloat = 20.0

    @State private var days: [Day]
    @State private var selectedIndex: Int = 0

    @Binding private var selectedDay: Day

    init(dayRange: ClosedRange<Day>,
         selected selectedDay: Binding<Day>)
    {
        let days = Array(stride(from: dayRange.lowerBound,
                                to: dayRange.upperBound,
                                by: 1))

        self.init(days: days,
                  selected: selectedDay)
    }

    init(days: [Day],
         selected selectedDay: Binding<Day>)
    {
        self.days = days

        _selectedDay = selectedDay
    }

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(days) { day in
                DayView(day: day, selected: day == days[selectedIndex])
            }
        }
        .modifier(ScrollingHStackModifier(itemCount: days.count,
                                          itemWidth: DayView.size.width,
                                          itemSpacing: spacing,
                                          selectedIndex: $selectedIndex))
        .frame(width: UIScreen.screenWidth)
        .onChange(of: selectedIndex) { newSelectedIndex in
            selectedDay = days[newSelectedIndex]
        }
    }

    struct DayView: View {
        public static let size = CGSize(width: 55, height: 70)

        let day: Day

        var selected: Bool

        var body: some View {
            VStack {
                Text(DateFormatterContainer.dayOfMonth.string(from: day.date))
                    .font(.title3)
                    .foregroundColor(foregroundColor)
                    .bold()

                Text(day.date.dayOfWeek(.short) ?? "???")
                    .foregroundColor(foregroundColor)
            }
            .frame(DayView.size)
            .background(backgroundColor)
            .cornerRadius(5)
            .shadow(color: shadowColor, radius: 5, x: 0, y: 5)
            .offset(offset)
            .animation(.easeIn, value: selected)
        }

        var foregroundColor: Color {
            if selected {
                return Color("DateSelectedForeground")
            } else {
                return Color("DateUnselectedForeground")
            }
        }

        var backgroundColor: Color {
            if selected {
                return Color("DateSelectedBackground")
            } else {
                return Color("DateUnselectedBackground")
            }
        }

        var shadowColor: Color {
            if selected {
                return .secondary
            } else {
                return .clear
            }
        }

        var offset: CGSize {
            if selected {
                return CGSize(width: 0, height: -5)
            } else {
                return CGSize(width: 0, height: 0)
            }
        }
    }
}

struct HorizontalDateSlider_Previews: PreviewProvider {
    static var previews: some View {
        let startDay = Day()
        let finishDay = Day(Calendar.current.date(byAdding: .day, value: 30, to: Date())!)

        HorizontalDateSlider(dayRange: startDay...finishDay, selected: .constant(Day()))
    }
}
