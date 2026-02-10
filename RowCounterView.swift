//
//  RowCounterView.swift
//  KnittingNote
//
//  Created by 문혜경 on 1/20/26.
//

import SwiftUI

struct RowCounterView: View {
    @Binding var title: String
    @Binding var count: Int

    let canDelete: Bool
    let onChange: () -> Void
    let onDelete: () -> Void

    @FocusState private var isEditingTitle: Bool

    var body: some View {
        VStack(spacing: 10) {
            // 이름 수정 + 삭제
            HStack {
                TextField("단수 이름", text: $title)
                    .font(.subheadline.weight(.medium))
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.plain)
                    .focused($isEditingTitle)
                    .onSubmit {
                        onChange()
                    }
                    .onChange(of: title) { _ in
                        onChange()
                    }

                Button {
                    if canDelete {
                        onDelete()
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(
                            canDelete ? Color(.systemGray3) : Color(.systemGray5)
                        )
                }
                .disabled(!canDelete)
            }

            // 카운트 숫자
            Text("\(count)")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(.accentColor)
                .contentTransition(.numericText())

            // +/- 버튼
            HStack(spacing: 20) {
                Button {
                    if count > 0 {
                        count -= 1
                        onChange()
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.title)
                        .foregroundColor(.red.opacity(0.7))
                }

                Button {
                    count += 1
                    onChange()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.green.opacity(0.8))
                }
            }
        }
        .frame(width: 140)
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.accentColor.opacity(0.15), lineWidth: 1)
        )
        .onLongPressGesture {
            count = 0
            onChange()
        }
    }
}
