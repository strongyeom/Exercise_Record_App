//
//  MainView.swift
//  ExerciseRecordApp
//
//  Created by 염성필 on 2023/03/19.
//
import SwiftUI


struct MainView: View {
    
    private var mainCategoies: [Color] = [.red, .yellow, .mint, .gray, .green]
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Entity.date, ascending: false)]) private var datas: FetchedResults<Entity>
    
    var body: some View {
        
        
        NavigationView {
            ScrollView(showsIndicators: false) {
                
                if datas.isEmpty {
                   Spacer()
                        Text("+ 버튼을 눌러 운동 일지를 추가해주세요")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                }
                
                LazyVStack(spacing: 15) {
                    ForEach(datas) { data in
                        
                        NavigationLink {
                            PlayView(data: data)
                        } label: {
                            RoundedRectangle(cornerRadius: 12)
                                
                                .stroke(mainCategoies[Int(data.colorIndex)], lineWidth: 1)
                                .frame(height: 80)
                                .overlay {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 10) {
                                            
                                            HStack {
                                                if let data = data.date {
                                                    
                                                    let dateFromCoreData: Date = data
                                                    let kDate = dateFromCoreData.toKSTString()
                                                    
                                                    
                                                    Text("\(kDate)")
                                                        .font(.footnote)
                                                        .foregroundColor(.gray)
                                                        .padding(.trailing, 20)
                                                }
                                                
                                                Text(data.category ?? "")
                                                    .background {
                                                        RoundedRectangle(cornerRadius: 12)
                                                            .fill(mainCategoies[Int(data.colorIndex)])
                                                            .frame(width: 45, height: 25, alignment: .center)
                                                    }
                                                    .tint(.white)
                                                
                                            }
                                            
                                            Text(data.title ?? "")
                                                .font(.title3)
                                                .foregroundColor(.black)
                                            
                                        }
                                        Spacer()
                                            
                                        Button {
                                            updateIsSuccess(target: data)
                                        } label: {
                                            Image(systemName : data.isSuccess ? "checkmark.square.fill" : "checkmark.square")
                                        }

                                        
                                        HStack {
                                            Rectangle()
                                                .cornerRadius(12, corners: [.bottomRight, .topRight])
                                                .foregroundColor(mainCategoies[Int(data.colorIndex)])
                                        }
                                        .frame(width: UIScreen.main.bounds.width * 0.05)
                                    }
                                    .padding(.leading, 10)
                                }
                                .opacity(data.isSuccess ? 0.3 : 1.0)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("운동일지")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        AddView()
                    } label: {
                        Image(systemName: "plus")
                            .tint(.black)
                    }
                    
                }
            }
        }
    }
    
    func updateIsSuccess(target: Entity) {
        withAnimation {
            target.isSuccess.toggle()
            try? viewContext.save()
        }
    }
}




struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


