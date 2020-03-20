//
//  ViewController.swift
//  EKCalendarChooser.Example
//
//  Created by Filip Němeček on 20/03/2020.
//  Copyright © 2020 Filip Němeček. All rights reserved.
//

import UIKit
import EventKitUI

class ViewController: UIViewController {
    
    let eventStore = EKEventStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func chooseCalendarTapped(_ sender: UIButton) {
        let authStatus = EKEventStore.authorizationStatus(for: .event)
        
        switch authStatus {
        case .authorized:
            showCalendarChooser()
        case .notDetermined:
            requestAccess()
        case .denied:
            // Explain to the user that they did not give permission
            break
        case .restricted:
            break
        @unknown default:
            preconditionFailure("Who knows what the future holds 🤔")
        }
    }
    
    func requestAccess() {
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                // may not be called on the main thread..
                DispatchQueue.main.async {
                    self.showCalendarChooser()
                }
            }
        }
    }
    
    func showCalendarChooser() {
        let vc = EKCalendarChooser(selectionStyle: .single, displayStyle: .allCalendars, entityType: .event, eventStore: eventStore)
        
        // customization
        vc.showsDoneButton = true
        vc.showsCancelButton = true
        
        // dont forget the delegate
        vc.delegate = self
        
        let nvc = UINavigationController(rootViewController: vc)
        
        self.present(nvc, animated: true, completion: nil)
    }
    
    
    @IBAction func githubButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://github.com/nemecek-filip")!, options: [:], completionHandler: nil)
    }
    
}

extension ViewController: EKCalendarChooserDelegate {
    func calendarChooserDidFinish(_ calendarChooser: EKCalendarChooser) {
        print(calendarChooser.selectedCalendars)
        dismiss(animated: true, completion: nil)
    }
    
    func calendarChooserSelectionDidChange(_ calendarChooser: EKCalendarChooser) {
        print("Changed selection")
    }
    
    func calendarChooserDidCancel(_ calendarChooser: EKCalendarChooser) {
        print("Cancel tapped")
        dismiss(animated: true, completion: nil)
    }
}

