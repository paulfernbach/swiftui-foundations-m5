//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Paul Fernbach on 3/21/23.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        // only show video if there is a valid url
        if url != nil {
            VideoPlayer(player: AVPlayer(url: url!))
                .cornerRadius(10)
            
            VStack {
                // TODO Description
                
                // Next Lesson button if there is a next lesson
                if model.hasNextLesson() {
                    Button(action: {
                        // advance the lesson
                        model.nextLesson()
                    }, label: {
                        ZStack {
                            Rectangle()
                                .frame(height:48)
                                .foregroundColor(Color.green)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                                .foregroundColor(.white)
                                .bold()
                        }
                    })
                }
            }
            .padding()
        }
    }
}
