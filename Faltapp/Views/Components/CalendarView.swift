import SwiftUI

struct CalendarView: View {
    var materia: Materia? = nil
    @Binding var selectedDates: [Date]
    var onDateTap: ((Date) -> Void)? = nil
    
    @State private var scrollProxy: ScrollViewProxy? = nil
    
    private let calendar: Calendar = {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "pt_BR")
        cal.firstWeekday = 1 // Domingo
        return cal
    }()
    
    private let weekdaySymbols = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    /// Gera 12 meses para trás e 6 meses para frente a partir do mês atual.
    private var months: [Date] {
        let now = Date()
        guard let currentMonthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) else {
            return [now]
        }
        return (-12...6).compactMap { offset in
            calendar.date(byAdding: .month, value: offset, to: currentMonthStart)
        }
    }
    
    private var currentMonthID: String {
        monthID(for: Date())
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Barra superior: botão rápido para voltar ao dia de hoje + dias da semana fixos
            HStack {
                Text("Selecione os dias")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        scrollProxy?.scrollTo(currentMonthID, anchor: .top)
                    }
                } label: {
                    Text("Hoje")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.15))
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 10)
            .padding(.bottom, 8)
            
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption2.weight(.semibold))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
            }
            .padding(.horizontal, 8)
            
            Divider()
                .opacity(0.5)
            
            // Scroll vertical contínuo pelos meses
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 20) {
                        ForEach(months, id: \.self) { monthStart in
                            MonthSectionView(
                                monthStart: monthStart,
                                calendar: calendar,
                                columns: columns,
                                materia: materia,
                                selectedDates: selectedDates,
                                onDateTap: handleTap
                            )
                            .id(monthID(for: monthStart))
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
                }
                .onAppear {
                    scrollProxy = proxy
                    DispatchQueue.main.async {
                        proxy.scrollTo(currentMonthID, anchor: .top)
                    }
                }
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
    
    private func handleTap(_ date: Date) {
        if let onDateTap {
            onDateTap(date)
        } else if selectedDates.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
            selectedDates.removeAll { calendar.isDate($0, inSameDayAs: date) }
        } else {
            selectedDates.append(date)
        }
    }
    
    private func monthID(for date: Date) -> String {
        let comps = calendar.dateComponents([.year, .month], from: date)
        return "\(comps.year ?? 0)-\(comps.month ?? 0)"
    }
}

private struct MonthSectionView: View {
    let monthStart: Date
    let calendar: Calendar
    let columns: [GridItem]
    let materia: Materia?
    let selectedDates: [Date]
    let onDateTap: (Date) -> Void
    
    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        let currentYear = calendar.component(.year, from: Date())
        let monthYear = calendar.component(.year, from: monthStart)
        formatter.dateFormat = monthYear == currentYear ? "LLLL" : "LLLL yyyy"
        let raw = formatter.string(from: monthStart)
        return raw.prefix(1).uppercased() + raw.dropFirst()
    }
    
    private var leadingEmptyDays: Int {
        let weekday = calendar.component(.weekday, from: monthStart) // 1 = Dom ... 7 = Sáb
        return (weekday - calendar.firstWeekday + 7) % 7
    }
    
    private var daysInMonth: [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: monthStart) else { return [] }
        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: monthStart)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(monthTitle)
                .font(.title3.bold())
                .foregroundColor(calendar.isDate(monthStart, equalTo: Date(), toGranularity: .month) ? .blue : .primary)
                .padding(.horizontal, 8)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(0..<leadingEmptyDays, id: \.self) { _ in
                    Color.clear
                        .frame(height: 44)
                }
                
                ForEach(daysInMonth, id: \.self) { date in
                    DayCellView(
                        date: date,
                        dayNumber: calendar.component(.day, from: date),
                        isToday: calendar.isDateInToday(date),
                        hasClass: hasClass(on: date),
                        absenceCount: absenceCount(on: date),
                        onTap: { onDateTap(date) }
                    )
                }
            }
        }
    }
    
    private func absenceCount(on date: Date) -> Int {
        selectedDates.filter { calendar.isDate($0, inSameDayAs: date) }.count
    }
    
    private func hasClass(on date: Date) -> Bool {
        guard let materia else { return true }
        let weekday = calendar.component(.weekday, from: date)
        switch weekday {
        case 2: return materia.faltasSegunda > 0
        case 3: return materia.faltasTerca > 0
        case 4: return materia.faltasQuarta > 0
        case 5: return materia.faltasQuinta > 0
        case 6: return materia.faltasSexta > 0
        case 7: return materia.faltasSabado > 0
        default: return false
        }
    }
}

private struct DayCellView: View {
    let date: Date
    let dayNumber: Int
    let isToday: Bool
    let hasClass: Bool
    let absenceCount: Int
    let onTap: () -> Void
    
    private var textColor: Color {
        if absenceCount > 0 {
            return .white
        }
        if isToday {
            return .blue
        }
        return hasClass ? .primary : .primary.opacity(0.28)
    }
    
    private var fillColor: Color {
        switch absenceCount {
        case 0:
            return .clear
        case 1:
            return .red.opacity(0.75)
        default:
            return .red
        }
    }
    
    private var isInteractive: Bool {
        hasClass || absenceCount > 0
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 3) {
                ZStack {
                    if absenceCount > 0 {
                        Circle()
                            .fill(fillColor)
                    }
                    
                    if isToday {
                        Circle()
                            .stroke(Color.blue, lineWidth: absenceCount > 0 ? 2 : 1.5)
                    }
                    
                    Text("\(dayNumber)")
                        .font(.system(size: 15, weight: (isToday || absenceCount > 0) ? .bold : .regular))
                        .foregroundColor(textColor)
                }
                .frame(width: 34, height: 34)
                
                // Bolinhas indicadoras de faltas (1 ou 2+)
                HStack(spacing: 3) {
                    if absenceCount > 0 {
                        ForEach(0..<min(absenceCount, 2), id: \.self) { _ in
                            Circle()
                                .fill(Color.red)
                                .frame(width: 5, height: 5)
                        }
                    } else {
                        Color.clear
                            .frame(width: 5, height: 5)
                    }
                }
                .frame(height: 5)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!isInteractive)
    }
}

#Preview {
    CalendarView(selectedDates: .constant([Date()]))
        .padding()
        .preferredColorScheme(.dark)
}
