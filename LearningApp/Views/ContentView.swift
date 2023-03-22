//
//  ContentView.swift
//  LearningApp
//
//  Created by Paul Fernbach on 3/21/23.
//

import SwiftUI

struct ContentView: View {
    
    var module: Module
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                if (model.currentModule != nil) {
                    ForEach(0..<model.currentModule!.content.lessons.count) {index in
                        NavigationLink(
                            destination:
                                ContentDetailView()
                                    .onAppear(perform: {
                                        model.beginLesson(index)
                                    }),
                            label: {
                                ContentViewRow(index:index)
                            })
                    }
                }
            }
            .accentColor(.black)
            .padding()
            .navigationTitle("Learn \(model.currentModule?.category ?? "")")
        }
    }
}

