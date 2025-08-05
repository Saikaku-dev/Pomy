//
//  CalendarView.swift
//  Pomy
//
//  Created by cmStudent on 2025/07/25.
//

import SwiftUI

struct CalendarView: View {
    @State private var date: Date = Date()

    var body: some View {
        VStack {
            DatePicker("日付を選択", selection: $date, displayedComponents: [.date])
                .datePickerStyle(GraphicalDatePickerStyle()) // カレンダー形式

            Text("選択中の日付: \(date.formatted(date: .long, time: .omitted))")
                .padding(.top)
        }
        .padding()
    }
}


#Preview {
    CalendarView()
}
