//
//  DatePicker.swift
//  Splus
//
//  Created by Igoryok on 20.02.2023.
//

import SwiftUI

struct DatePicker: View {
    private let dayTimes: [Day: [Time]]

    @Binding private var selectedDate: Date

    init(dayTimes: [Day: [Time]],
         selected date: Binding<Date>)
    {
        self.dayTimes = dayTimes

        _selectedDate = date
    }

    init(dayRange: ClosedRange<Day>,
         timeRange: ClosedRange<Time>,
         selected date: Binding<Date>)
    {
        var dayTimes: [Day: [Time]] = [:]

        for day in dayRange {
            dayTimes[day] = Array(timeRange)
        }

        self.init(dayTimes: dayTimes, selected: date)
    }

    var body: some View {
        VStack {
            if let times = dayTimes[selectedDate.day] {
                HorizontalDateSlider(days: Array(dayTimes.keys.sorted()), selected: $selectedDate.day)
                    .padding(.vertical)
                    .onChange(of: selectedDate.day) { newSelectedDay in
                        if let availableTime = dayTimes[newSelectedDay],
                           !availableTime.contains(selectedDate.time)
                        {
                            selectedDate.time = Time.zero
                        }
                    }

                TimeGridPicker(times: times, selected: Binding<Time?>($selectedDate.time))
            }
        }
    }
}

struct DatePicker_Previews: PreviewProvider {
    static var previews: some View {
        DatePicker(dayTimes: [Day: [Time]].test,
                   selected: .constant(Date()))
    }
}
