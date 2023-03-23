//
//  PlayView.swift
//  ExerciseRecordApp
//
//  Created by 염성필 on 2023/03/19.
//

import SwiftUI

struct PlayView: View {
    
    var data: Entity
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State private var showingAlert: Bool = false
    
    let fontSize: CGFloat = 30
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(data.title ?? "")
                    .font(.title)
                    .padding(-3)
                Spacer()
                Menu {
                    Button {
                        showingAlert.toggle()
                    } label: {
                        Text("삭제하기")
                            .font(.title3)
                    }
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title)
                }
            }
            .padding(.bottom, 4)
            .alert("삭제하시겠습니까?", isPresented: $showingAlert) {
                Button("확인", role: .destructive) {
                    dismiss()
                    removeData(target: data)
                }
            }
            
            Text(data.content ?? "")
                .font(.title2)
                .padding(7)
                .minimumScaleFactor(0.3)
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.3, alignment: .topLeading)
                .background(Color(red: 237/255, green: 237/255, blue: 237/255))
                .cornerRadius(8)
                .padding(.bottom, 15)
            
            CircleTimerView()
                .padding(.bottom, 20)
            
            HStack {
                Spacer()
                
                
                Button {
                    updateIsToggle(target: data)
                    dismiss()
                    
                } label: {
                    Text(data.isSuccess ? "운동재시작" : "운동완료")
                        .font(.title)
                    
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 18))
                
                Spacer()
            }
            Spacer()
            
        }
        .padding()
    }
    
    func removeData(target: Entity) {
        withAnimation {
            viewContext.delete(target)
            try? viewContext.save()
        }
    }
    
    func updateIsToggle(target: Entity) {
        withAnimation {
            target.isSuccess.toggle()
            target.exerciseClicked.toggle()
            try? viewContext.save()
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(data: Entity())
        
    }
}
