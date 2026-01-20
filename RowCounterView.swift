//
//  RowCounterView.swift
//  KnittingNote
//
//  Created by 문혜경 on 1/20/26.
//

import SwiftUI

import SwiftUI

struct RowCounterView: View {
    @Binding var title: String
    @Binding var count: Int
    
    let canDelete: Bool
    let onChange: () -> Void
    let onDelete: () -> Void
    
    
    @FocusState private var isEditingTitle: Bool

    var body: some View {
        VStack(spacing: 8) {

            //이름 수정
            HStack{
                TextField("단수 이름", text: $title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .focused($isEditingTitle)
                    .onSubmit {
                        onChange()
                    }
                    .onChange(of: title) { _ in
                        onChange()
                    }
                
                Spacer()
                
                Button {
                    if canDelete {
                        onDelete()
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(
                            canDelete ? .gray : .gray.opacity(0.3)
                        )
                }
                .disabled(!canDelete)
            }
            
            Text("\(count)")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.accentColor)

            HStack(spacing: 12) {
                Button {
                    if count > 0 {
                        count -= 1
                        onChange()
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.red.opacity(0.8))
                }

                Button {
                    count += 1
                    onChange()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green.opacity(0.8))
                }
            }
        }
        .frame(width: 120)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)

          .overlay(
              RoundedRectangle(cornerRadius: 16)
                  .stroke(Color.accentColor, lineWidth: 2)
          )
          .onLongPressGesture {
              count = 0
              onChange()
          }
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}
