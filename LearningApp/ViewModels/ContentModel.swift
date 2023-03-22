//
//  ContentModel.swift
//  LearningApp
//
//  Created by Paul Fernbach on 3/20/23.
//

import Foundation

class ContentModel: ObservableObject {
    
    @Published var modules = [Module]()
    var styleData: Data?
    
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current Lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    init() {
        getLocalData()
    }
    
    func getLocalData() {
        
        // Get a url to the json file
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        // Read the file into a data object
        do {
            let jsonData = try Data(contentsOf: jsonUrl!)
        
            // Try to decode the json into an array of modules
            let jsonDecoder = JSONDecoder()
        
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)

            // Assign parsed modules ot modules property
            self.modules = modules
            
        } catch {
            // TODO log error
            print("Couldn't parse local json data")
            print(error)
        }
        
        // Parse the style.data
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")
        
        do {
            // Read the file into a data object
            let styleData = try Data(contentsOf:styleUrl!)
            
            // Read the file as a data object
            self.styleData = styleData
            
        } catch {
            print ("Couldn't parse style data!")
        }
    }
    
    // MARK: data setters
    func beginModule(_ moduleid:Int) {
        
        for index in 0..<modules.count {
            if modules[index].id == moduleid {
                currentModuleIndex = index
                break
            }
        }
        
        currentModule = modules[currentModuleIndex]
    }
    
    //MARK: set current lesson
    func beginLesson(_ lessonIndex:Int) {
        // check that the lesson index is within range
        if lessonIndex < currentModule!.content.lessons.count {
            currentLessonIndex = lessonIndex
        } else {
            currentLessonIndex = 0
        }
        
        // set the current lesson
        currentLesson = currentModule?.content.lessons[currentLessonIndex]
    }
    
    //
    func nextLesson() {
        // Advance the lesson index
        currentLessonIndex += 1
        
        // Check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
        } else {
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    //MARK: is there a next lesson
    func hasNextLesson() -> Bool {
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
}
