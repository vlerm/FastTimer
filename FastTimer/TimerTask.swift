//
//  TimerTask.swift
//  FastTimer
//
//  Created by Вадим Лавор on 5.10.22.
//

import Foundation

class TimerTask {
    
    let name: String
    var timerDate = Date()
    var isCompleted = false
    
    init(name: String, date: Date) {
        self.name = name
        self.timerDate = date
    }
    
    func reduceTime() {
        let timeNull = DateComponents(second: 0)
        let currentCalendar = Calendar.current
        let date = currentCalendar.date(from: timeNull)!
        if timerDate == date {
            isCompleted = true
        } else {
            timerDate.addTimeInterval(-1)
        }
    }
    
}
