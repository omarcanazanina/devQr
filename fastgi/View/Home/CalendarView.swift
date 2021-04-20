//
//  CalendarView.swift
//  fastgi wallet
//
//  Created by Hegaro on 19/04/2021.
//

import SwiftUI
import UIKit
import FSCalendar

struct CalendarView: View {
    @State var selectedDate: Date = Date()
    //@State var fechaini :Date?
    //@State var fechafin = Date()
    var selectedDateStr: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: selectedDate)
    }
    
   
    
    var body: some View {
        VStack{
            CalendarRepresentable(selectedDate: $selectedDate)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0.0, y: 0.0)
                )
                .frame(height: 350)
                .padding()
            
           // Text(selectedDateStr)
             //   .font(.title)
            Button(action: {
                print("")
            }){
                Text("Aceptar")
            }
        }
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

struct CalendarRepresentable: UIViewRepresentable {
    
    typealias UIViewType = FSCalendar
    @Binding var selectedDate: Date
    var calendar = FSCalendar()
    
    
    func updateUIView(_ uiView: FSCalendar, context: Context) { }
    
    func makeUIView(context: Context) -> FSCalendar {
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        calendar.appearance.headerDateFormat = "yyyy/MM/dd"
        
        calendar.appearance.eventDefaultColor = .orange
        
        calendar.allowsMultipleSelection = true
        
        return calendar
    }
   
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
   
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarRepresentable
        
        
        // first date in the range
         var firstDate: Date?
        // last date in the range
         var lastDate: Date?
        
         var datesRange: [Date]?
        
        init(_ parent: CalendarRepresentable) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            if parent.selectedDate == date{
                return 1
            }else{
                return 0
            }
            
        }
        
        /*func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }*/
        
        //metodo rango
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            // nothing selected:
            if firstDate == nil {
                firstDate = date
                datesRange = [firstDate!]

                print("datesRange contains0: \(datesRange!)")

                return
            }

            // only first date is selected:
            if firstDate != nil && lastDate == nil {
                // handle the case of if the last date is less than the first date:
                if date <= firstDate! {
                    calendar.deselect(firstDate!)
                    firstDate = date
                    datesRange = [firstDate!]

                    print("datesRange contains1: \(datesRange!)")

                    return
                }

                let range = datesRange(from: firstDate!, to: date)

                lastDate = range.last

                for d in range {
                    calendar.select(d)
                }

                datesRange = range

                print("datesRange contains2: \(datesRange!)")
                print("fecha ini \(firstDate!)")
                print("fecha fin \(lastDate!)")
                return
            }

            // both are selected:
            if firstDate != nil && lastDate != nil {
                for d in calendar.selectedDates {
                    calendar.deselect(d)
                }

                lastDate = nil
                firstDate = nil

                datesRange = []

                print("datesRange contains3: \(datesRange!)")
                print("aqui")
            }
        }

        func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
            // both are selected:

            // NOTE: the is a REDUANDENT CODE:
            if firstDate != nil && lastDate != nil {
                for d in calendar.selectedDates {
                    calendar.deselect(d)
                }

                lastDate = nil
                firstDate = nil

                datesRange = []
                print("datesRange contains4: \(datesRange!)")
                //print("fecha ini \(self.firstDate) fechafin \(self.lastDate)")
            }
        }
        
        func datesRange(from: Date, to: Date) -> [Date] {
            // in case of the "from" date is more than "to" date,
            // it should returns an empty array:
            if from > to { return [Date]() }

            var tempDate = from
            var array = [tempDate]

            while tempDate < to {
                tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
                array.append(tempDate)
            }

            return array
        }
        
    }
    
   
    
   
}
