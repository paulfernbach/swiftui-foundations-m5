//
//  TestView.swift
//  LearningApp
//
//  Created by Paul Fernbach on 3/29/23.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model:ContentModel
    @State var selectedAnswerIndex:Int?
    @State var submitted = false
    @State var numCorrect = 0
    
    var submitButtonText: String {
        if submitted {
            if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                return "Finish"
            }
            return "Next"
        } else {
            return "Submit"
        }
    }
    
    var body: some View {
        if model.currentQuestion != nil {
            
            VStack(alignment: .leading) {
                // Question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                // question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                // answers
                ScrollView {
                    VStack {
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self) {index in
                            
                            Button {
                                selectedAnswerIndex = index
                                
                            } label: {
                                
                                ZStack {
                                    if !submitted {
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height:48)
                                    } else {
                                        if index == selectedAnswerIndex &&
                                            index == model.currentQuestion!.correctIndex {
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        } else if index == selectedAnswerIndex &&
                                                    index != model.currentQuestion!.correctIndex {
                                            RectangleCard(color: .red)
                                                .frame(height: 48)
                                        } else if index == model.currentQuestion?.correctIndex {
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        } else {
                                            RectangleCard(color: .white)
                                                .frame(height:48)
                                        }
                                    }
                                    
                                    Text(model.currentQuestion?.answers[index] ?? "")
                                }
                            }
                            .disabled(submitted)
                            
                        }
                    }
                    .accentColor(.black)
                    .padding()
                }
                // submit button
                Button {
                    if submitted == true {
                        model.nextQuestion()
                        submitted = false
                        selectedAnswerIndex = nil
                        
                        
                    } else {
                        // submit the question
                        // remember submitted
                        submitted = true
                        
                        // check if correct
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                    }
                } label: {
                    ZStack {
                        RectangleCard(color: .green)
                            .frame(height:48)
                        Text(submitButtonText)
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                }
                .disabled(submitted == nil)
            }
            .navigationBarTitle("Learn \(model.currentModule?.category ?? "") Test")
        } else {
            // test hasn't loaded yet
            ProgressView()
        }
            
    }
}

