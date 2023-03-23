//
//  AddView.swift
//  ExerciseRecordApp
//
//  Created by 염성필 on 2023/03/19.
//

import SwiftUI


struct AddView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var category: String = ""
    @State private var categoryString: String = ""
    @State private var colorIndex: Int = 0
    @FocusState private var focusField: Field?
    
    enum Field {
        case title
        case content
    }
    
    private var categorys = ["하체", "가슴", "등", "어깨", "팔"]
    private var colors: [Color] = [.red, .yellow, .mint, .gray, .green]
    
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        
        
        
        VStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("제목")
                        .font(.title3)
                    TextField("제목", text: $title)
                        .padding(8)
                        .overlay(content: {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray, lineWidth: 1)
                        })
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .focused($focusField, equals: .title)
                        .onSubmit {
                            print("user enter return")
                            if !title.isEmpty {
                                focusField = .content
                            }
                        }
                }
                
                
                HStack(spacing: 15) {
                    ForEach(Array(zip(categorys.indices, categorys)), id:\.0) { index, category in
                        Button {
                            categoryString = category
                            colorIndex = index
                        } label: {
                            
                            
                            Text("\(category)")
                                .fontWeight(.bold)
                                .frame(width: 50, height: 25)
                                .foregroundColor(categoryString == category ? Color.white : Color.gray)
                                .background(content: {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(categoryString == category ? colors[index] : Color.white)
                                })
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(categoryString == category ? colors[index] : Color.gray)
                                }
                            
                        }
                    }
                }
                .padding(.vertical, 12)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("내용")
                        .font(.title3)
                    ZStack {
                        let placeHolder: String = "내용을 적어주세요."
                        TextEditor(text: $content)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .padding()
                            .frame(height: 200)
                            .focused($focusField, equals: .content)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.gray, lineWidth: 1)
                            }
                            .submitLabel(SubmitLabel.next)
                        
                        if content.isEmpty {
                            Text(placeHolder)
                                .font(.callout)
                                .foregroundColor(.primary.opacity(0.25))
                                .lineSpacing(10)
                                .offset(x: -UIScreen.main.bounds.maxX * 0.27, y: -UIScreen.main.bounds.maxY * 0.075)
                        }
                    }
                    
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        addData()
                        dismiss()
                    } label: {
                        Text("저장하기")
                    }
                    
                }
            }
            Spacer()
        }
        .onAppear{
            UIApplication.shared.hideKeyboard()
            focusField = .title
        }
    }
    
    private func addData() {
        withAnimation {
            let data = Entity(context: viewContext)
            data.title = title
            data.content = content
            data.category = categoryString
            data.colorIndex = Int32(colorIndex)
            data.date = Date.now
            data.isSuccess = false
            data.exerciseClicked = false
            try? viewContext.save()
        }
    }
}



struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddView()
        }
    }
}
