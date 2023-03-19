//
//  CircleTimerView.swift
//  ExerciseRecordApp
//
//  Created by 염성필 on 2023/03/19.
//

import SwiftUI
import AVKit

struct Clock: View {
    let counter: Int
    let countTo: Int
    
    var body: some View {
        VStack {
            Text("쉬는 시간")
                .font(.title3)
                .fontWeight(.black)
            Text(counterToMinutes())
                .font(.title3)
                .fontWeight(.black)
        }
    }
    
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)
        
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
    
}

struct ProgressTrack: View {
    var body: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: UIScreen.main.bounds.width * 0.5, height:  UIScreen.main.bounds.width * 0.45)
            .overlay(
                Circle().stroke(Color.gray, lineWidth: 10)
            )
    }
}

struct ProgressBar: View {
    var counter: Int
    var countTo: Int
    
    var body: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: UIScreen.main.bounds.width * 0.5, height:  UIScreen.main.bounds.width * 0.45)
            .overlay(
                Circle().trim(from:0, to: progress())
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 10,
                            lineCap: .round,
                            lineJoin:.round
                        )
                    )
                    .foregroundColor(
                        (completed() ? Color.green : Color.orange)
                    )
            )
    }
    
    func completed() -> Bool {
        
        return progress() == 1
        
    }
    
    func progress() -> CGFloat {
        if (CGFloat(counter) / CGFloat(countTo)) == 1 {
            let systemsoundId: SystemSoundID = 1012
            AudioServicesPlaySystemSound(systemsoundId)
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
        
        return (CGFloat(counter) / CGFloat(countTo))
    }
}


struct CircleTimerView: View {
    @State var counter: Int = 0
    @State var countTo: Int = 0
    
    @State private var seconds1: Int = 30
    @State private var seconds2: Int = 40
    @State private var seconds3: Int = 60
    @State private var selectedButton: Int? = nil
    
    private var buttonArray: [String] = ["30초", "40초", "60초"]
    
    
    private var timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var body: some View {
        HStack(spacing: 40){
            ZStack{
                ProgressTrack()
                ProgressBar(counter: counter, countTo: countTo)
                Clock(counter: counter, countTo: countTo)
            }
            
            VStack(spacing: 13) {
                ForEach(Array(zip(buttonArray.indices, buttonArray)), id:\.0) { index, button in
                    Button {
                        countTo = [seconds1, seconds2, seconds3][index]
                        if selectedButton == index {
                            selectedButton = nil
                        } else {
                            selectedButton = index
                        }
                    } label: {
                        Text(buttonArray[index])
                    }
                    .modifier(ButtonStyle(isSelected: selectedButton == index))
                }
                Button {
                    countTo = 0
                    counter = 0
                    selectedButton = nil 
                } label: {
                    Text("중지")
                }
                .modifier(ButtonStyle(isSelected: false))
            }
            
        }
        .padding()
        .onReceive(timer) { time in
            if (self.counter < self.countTo) {
                self.counter += 1
            } else if counter == countTo {
                selectedButton = nil
                counter = 0
                countTo = 0
                
               
            }
        }
    }
}

struct ButtonStyle: ViewModifier {
    var isSelected: Bool
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
            .background(isSelected ? .orange : .blue)
            .cornerRadius(12)
    }
}

struct CircleTimerView_Previews: PreviewProvider {
    static var previews: some View {
        CircleTimerView()
    }
}
