import SwiftUI
import FSCalendar

struct CalendarView: UIViewRepresentable {
    
    var materia: Materia? = nil
    @Binding var selectedDates: [Date]
    var onDateTap: ((Date) -> Void)?
    
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
        calendar.appearance.subtitleDefaultColor = .lightGray
        calendar.appearance.subtitleSelectionColor = .white
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        // Limpa seleções atuais
        uiView.selectedDates.forEach { uiView.deselect($0) }
        
        // Seleciona novamente todas as datas do array
        for date in selectedDates {
            uiView.select(date)
        }
        uiView.reloadData()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        var parent: CalendarView
        
        init(_ parent: CalendarView) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
            let count = parent.selectedDates.filter { Calendar.current.isDate($0, inSameDayAs: date) }.count
            if count == 1 {
                return "1 falta"
            } else if count > 1 {
                return "\(count) faltas"
            }
            return nil
        }
        
        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            parent.onDateTap?(date)
            return false
        }
        
        func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            parent.onDateTap?(date)
            return false
        }
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            guard let materia = parent.materia else { return .white }
            
            let diaDaSemana = Calendar.current.component(.weekday, from: date)
            let temAula: Bool
            switch diaDaSemana {
            case 2: temAula = materia.faltasSegunda > 0
            case 3: temAula = materia.faltasTerca > 0
            case 4: temAula = materia.faltasQuarta > 0
            case 5: temAula = materia.faltasQuinta > 0
            case 6: temAula = materia.faltasSexta > 0
            case 7: temAula = materia.faltasSabado > 0
            default: temAula = false
            }
            
            return temAula ? .white : UIColor.white.withAlphaComponent(0.25)
        }
    }
}
