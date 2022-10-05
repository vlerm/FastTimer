//
//  ViewController.swift
//  FastTimer
//
//  Created by Вадим Лавор on 5.10.22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timerNameTextField: UITextField!
    @IBOutlet weak var timerTimePickerView: UIPickerView!
    @IBOutlet weak var timerTableView: UITableView!
    @IBOutlet weak var addTimerButton: UIButton!
    
    var hours = [String]()
    var minutes = [String]()
    var seconds = [String]()
    var dateComponents = DateComponents()
    var tasks: [TimerTask] = []
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerTimePickerView.dataSource = self
        timerTimePickerView.delegate = self
        timerTableView.delegate = self
        timerTableView.dataSource = self
        timerTableView.layer.masksToBounds = true
        timerTableView.layer.cornerRadius = 10
        addTimerButton.layer.masksToBounds = true
        addTimerButton.layer.cornerRadius = 10
        fillTimeArrays()
        self.setGradientBackground(view: self.view, colorTop: UIColor(red: 154/255, green: 120/255, blue: 100/255, alpha: 1).cgColor, colorBottom: UIColor(red: 53/255, green: 10/255, blue: 180/255, alpha: 1).cgColor)
    }
    
    @IBAction func addTimerButton(_ sender: UIButton) {
        createTimer()
        DispatchQueue.main.async {
            let currentCalendar = Calendar.current
            let date = currentCalendar.date(from: self.dateComponents)!
            let timerTask = TimerTask(name: self.timerNameTextField.text!, date: date)
            self.tasks.append(timerTask)
            let indexPath = IndexPath(row: self.tasks.count - 1, section: 0)
            self.timerTableView.beginUpdates()
            self.timerTableView.insertRows(at: [indexPath], with: .top)
            self.timerTableView.endUpdates()
        }
    }
    
}

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 1:
            return minutes.count
        case 2:
            return seconds.count
        default:
            return 0
        }
    }
    
}

extension ViewController: UIPickerViewAccessibilityDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return hours[row]
        case 1:
            return minutes[row]
        case 2:
            return seconds[row]
        default: break
        }
        return String()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            dateComponents.hour = Int(hours[row])!
        case 1:
            dateComponents.minute = Int(minutes[row])!
        case 2:
            dateComponents.second = Int(seconds[row])!
        default:
            break
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? TimerTableViewCell else {
            return
        }
        cell.updateState()
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timerCell", for: indexPath)
        if let cell = cell as? TimerTableViewCell {
            cell.timerTask = tasks[indexPath.row]
        }
        return cell
    }
    
}

extension ViewController {
    
    @objc func updateTimer() {
        guard let visibleRowsIndexPaths = timerTableView.indexPathsForVisibleRows else {
            return
        }
        for indexPath in visibleRowsIndexPaths {
            if let cell = timerTableView.cellForRow(at: indexPath) as? TimerTableViewCell {
                cell.updateTime()
            }
        }
    }
    
    func createTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(updateTimer),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    func setGradientBackground(view: UIView, colorTop: CGColor = UIColor(red: 29.0/255.0, green: 34.0/255.0, blue:234.0/255.0, alpha: 1.0).cgColor, colorBottom: CGColor = UIColor(red: 38.0/255.0, green: 0.0/255.0, blue: 6.0/255.0, alpha: 1.0).cgColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func fillTimeArrays(){
        for index in 0...60 {
            minutes.append(String(index))
            seconds.append(String(index))
            if index <= 24 {
                hours.append(String(index))
            }
        }
    }
    
}
