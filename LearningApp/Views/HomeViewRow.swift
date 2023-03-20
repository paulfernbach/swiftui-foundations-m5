//
//  HomeViewRow.swift
//  LearningApp
//
//  Created by Paul Fernbach on 3/20/23.
//

import SwiftUI

struct HomeViewRow: View {
    
    
    var imageName:String
    var title:String
    var description:String
    var count:String
    var time:String

    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .aspectRatio(CGSize(width: 335, height: 175),contentMode: .fit)
            HStack {
                // Image
                Image(imageName)
                    .resizable()
                    .frame(width: 116, height: 116)
                    .clipShape(Circle())
                
                Spacer()
                
                // Text
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .bold()
                    Text(description)
                        .padding(.bottom, 20)
                        .font(.caption)
                    
                    HStack {
                        //number of lessons/questions
                        Image(systemName: "text.book.closed")
                            .resizable()
                            .frame(width:15,height:15)
                        Text(count)
                            .font(Font.system(size:10))
                        
                        Spacer()
                        
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width:15,height:15)
                        Text(time)
                            .font(Font.system(size:10))
                        
                        
                    }
                    
                } .padding(.leading, 20)
            } .padding(.horizontal, 20)
        }
    }
}

struct HomeViewRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewRow(imageName:"swift", title:"Learn Swift", description: "some description", count:"10 Lessons", time: "2 hours")
    }
}
