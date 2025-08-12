import SwiftUI
import FSCalendar

struct CalendarView: UIViewRepresentable {
    
    @Binding var selectedDates: [Date]
    
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.allowsMultipleSelection = true
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        calendar.appearance.todayColor = .clear // tira a bolinha do dia atual
        calendar.appearance.titleTodayColor = .systemBlue // deixa o texto azul
        calendar.appearance.selectionColor = .red // cor da bolinha de seleção
        calendar.appearance.headerTitleColor = .gray
        calendar.appearance.weekdayTextColor = .gray
        calendar.appearance.titleDefaultColor = .white
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarView
        
        init(_ parent: CalendarView) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDates.append(date)
        }
        
        func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDates.removeAll { Calendar.current.isDate($0, inSameDayAs: date) }
        }
    }
}
