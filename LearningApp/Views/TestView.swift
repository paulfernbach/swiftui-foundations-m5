//
//  TestView.swift
//  LearningApp
//
//  Created by Paul Fernbach on 3/29/23.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model:ContentModel
    
    var body: some View {
        if model.currentQuestion != nil {
            
            VStack {
                // Question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                
                // question
                CodeTextView()
                
                // answers
                
                // button
            }
            .navigationBarTitle("Learn \(model.currentModule?.category ?? "") Test")
        } else {
            // test hasn't loaded yet
            ProgressView()
        }
            
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
