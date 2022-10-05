//
//  TamerTableViewCell.swift
//  FastTimer
//
//  Created by Вадим Лавор on 5.10.22.
//

import UIKit

class TimerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var timerTask: TimerTask? {
        didSet {
            nameLabel.text = timerTask?.name
            setState()
            updateTime()
        }
    }
    
    func updateState() {
        guard let task = timerTask else {
            return
        }
        task.isCompleted.toggle()
        setState()
        updateTime()
    }
    
    func updateTime() {
        guard let task = timerTask else {
            return
        }
        if task.isCompleted {
            timeLabel.text = "Completed"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            timeLabel.text = dateFormatter.string(from: timerTask!.timerDate)
            timerTask?.reduceTime()
        }
    }
    
    private func setState() {
        guard let task = timerTask else {
            return
        }
        if task.isCompleted {
            nameLabel.attributedText = NSAttributedString(string: task.name,
                                                          attributes: [.strikethroughStyle: 1])
        } else {
            nameLabel.attributedText = NSAttributedString(string: task.name,
                                                          attributes: nil)
        }
    }
    
}
