//
//  ContentModel.swift
//  LearningApp
//
//  Created by Paul Fernbach on 3/20/23.
//

import Foundation

let remoteData = "https://paulfernbach.github.io/learningapp-data/data2.json"

class ContentModel: ObservableObject {
    
    @Published var modules = [Module]()
    
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current Lesson
    @Published var currentLesson: Lesson?
    var currentLessonIndex = 0
    
    // Current Question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current lesson explanation
    @Published var codeText = NSAttributedString()

    // current selected content and test
    @Published var currentContentSelected:Int?
    @Published var currentTestSelected:Int?
    
    var styleData: Data?

    init() {
        getLocalData()
        getRemoteData()
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
    
    func getRemoteData() {
        // string path
        let urlString = remoteData
        
        let url = URL(string: urlString)
        
        guard url != nil else {
            return
        }
        
        // Create a URL Request object
        let request = URLRequest(url: url!)
        
        // get the session
        let session = URLSession.shared
        
        // kick off the task
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            // check if there is an error
            guard error == nil else {
                return
            }
            
             do {
                 // create json decoder
                 let decoder = JSONDecoder()
                 
                 // and decode
                 let modules = try decoder.decode([Module].self, from: data!)
                 
                 // apppend modules
                 self.modules += modules
                 
            } catch {
                print (error)
            }
        }
        
        // kick off data task
        dataTask.resume()
        
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
        codeText = addStyling(currentLesson!.explanation)
    }
    
    //
    func nextLesson() {
        // Advance the lesson index
        currentLessonIndex += 1
        
        // Check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
            codeText = addStyling(currentLesson!.explanation)
        } else {
            currentLessonIndex = 0
            currentLesson = nil
        }
    }
    
    //MARK: is there a next lesson
    func hasNextLesson() -> Bool {
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
    }
    
    // MARK: begin Test
    func beginTest(_ moduleId:Int) {
        // set the current module
        beginModule(moduleId)
        
        // set the current question
        currentQuestionIndex = 0
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            // set the question content
            codeText = addStyling(currentQuestion?.content ?? "")
        }
    }
    
    // MARK: next question
    func nextQuestion() {
        // advance the question index
        currentQuestionIndex += 1
        
        // check that the question index is ok
        if currentQuestionIndex < currentModule!.test.questions.count {
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            codeText = addStyling(currentQuestion!.content)
        } else {
            // if not then reset the question index
            currentQuestionIndex = 0
            currentQuestion = nil
        }
        
    }
    
    //MARK: code styling helper
    private func addStyling(_ htmlString:String) -> NSAttributedString {
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling
        if styleData != nil {
            data.append(styleData!)
        }
        
        //
        data.append(Data(htmlString.utf8))
        
        //
        do {
            let attributeString = try NSAttributedString(data: data, options: [.documentType:                                                                    NSAttributedString.DocumentType.html], documentAttributes: nil)
                resultString = attributeString
        } catch {
            print("Couldn't turn Style HTML into attributed string")
        }
        
        return resultString
    }
}
