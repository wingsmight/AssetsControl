//
//  TimeGridPicker.swift
//  Splus
//
//  Created by Igoryok on 19.02.2023.
//

import SwiftUI

struct TimeGridPicker: View {
    private let elementSpacing: CGFloat = 20.0
    private let columnCount = 3
    private let columns: [GridItem]
    private let times: [Time]

    @Binding private var selectedTime: Time?

    init(times: [Time],
         selected selectedTime: Binding<Time?>)
    {
        columns = Array(repeating: GridItem(.flexible(), spacing: elementSpacing),
                        count: columnCount)

        self.times = times

        _selectedTime = selectedTime
    }

    init(timeRange: ClosedRange<Time>,
         partition: Int = 30,
         selected selectedTime: Binding<Time?>)
    {
        let times = Array(stride(from: timeRange.lowerBound,
                                 through: timeRange.upperBound,
                                 by: partition))

        self.init(times: times,
                  selected: selectedTime)
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: elementSpacing) {
            ForEach(times) { time in
                TimeView(time: time, selected: Binding<Bool> {
                    selectedTime == time
                } set: { isSelected in
                    self.selectedTime = isSelected ? time : nil
                })
            }
        }
        .padding()
    }

    struct TimeView: View {
        let time: Time

        @Binding var selected: Bool

        var body: some View {
            Button {
                selected.toggle()

                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            } label: {
                Text(time.description)
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .frame(minWidth: 70, maxWidth: .infinity, minHeight: 50, maxHeight: .infinity)
                    .roundedBorder(frameColor, cornerRadius: 5, lineWidth: 3)
            }
        }

        var frameColor: Color {
            if selected {
                return Color("DateSelectedBackground")
            } else {
                return Color("DateUnselectedBackground")
            }
        }
    }
}

struct TimeGridPicker_Previews: PreviewProvider {
    static var previews: some View {
        let startTime = Time(10, 0)
        let finishTime = Time(14, 0)

        TimeGridPicker(timeRange: startTime...finishTime, selected: .constant(nil))
    }
}
