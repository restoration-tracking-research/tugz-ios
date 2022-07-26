//
//  TimePicker.swift
//  Tugz-iOS-app
//
//  Created by Charlie Williams on 26/12/2021.
//

import SwiftUI

struct TimeDurationPicker: UIViewRepresentable {
    typealias UIViewType = UIDatePicker
    
    @Binding var duration: TimeInterval
    
    func makeUIView(context: Context) -> UIDatePicker {
        let timeDurationPicker = UIDatePicker()
        timeDurationPicker.datePickerMode = .countDownTimer
        timeDurationPicker.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)
        return timeDurationPicker
    }
    
    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.countDownDuration = duration
    }
    
    func makeCoordinator() -> TimeDurationPicker.Coordinator {
        Coordinator(duration: $duration)
    }
    
    class Coordinator: NSObject {
        private var duration: Binding<TimeInterval>
        
        init(duration: Binding<TimeInterval>) {
            self.duration = duration
        }
        
        @objc func changed(_ sender: UIDatePicker) {
            self.duration.wrappedValue = sender.countDownDuration
        }
    }
}

struct TimeDurationPicker_Previews: PreviewProvider {
    static var previews: some View {
        TimeDurationPicker(duration: .constant(60.0 * 30.0))
    }
}
