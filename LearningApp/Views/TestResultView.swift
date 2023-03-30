//
//  TestResultView.swift
//  LearningApp
//
//  Created by Paul Fernbach on 3/29/23.
//

import SwiftUI


struct TestResultView: View {

    @EnvironmentObject var model:ContentModel
    var numCorrect:Int
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text (resultHeading)
                .font(.title)
            
            Spacer()
            
            Text ("You got \(numCorrect) out of \(model.currentModule?.test.questions.count ?? 0) correct")
                .font(.headline)
            
            Spacer()
            
            Button {
                // go back
                model.currentTestSelected = nil
                
            } label: {
                ZStack {
                    RectangleCard(color: .green)
                        .frame(height: 48)
                    
                    Text ("Complete")
                        .bold()
                }
            }
            .padding()
            
            Spacer()
        }
    }
    
    var resultHeading: String {
        
        guard model.currentModule != nil else {
            return ""
        }
        
        let pct = Double(numCorrect) / Double(model.currentModule!.test.questions.count)
        
        if pct > 0.50 {
            return "Awesome!"
        } else if pct > 0.25 {
            return "Not bad!"
        } else {
            return "Need some more studying"
        }
    }
}

