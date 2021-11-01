//
//  ContentView.swift
//  Images and Coordinates
//
//  Created by Carmen Morado on 10/9/21.
//

import SwiftUI
import Photos

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    
    @State var selected: [UIImage] = []
    @State var show = false
    @State var rectDict = [String: [Rect]]()
    @State var rectArray: [Rect] = []
 
    var body: some View {
        ZStack {
            Color.black.opacity(0.07).edgesIgnoringSafeArea(.all)
            
            VStack {
                if !self.selected.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(self.selected, id: \.self) {i in
                               Image(uiImage: i)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width - 40, height: 250)
                                .cornerRadius(15)
                                .gesture(DragGesture(minimumDistance: 0).onEnded({ (value) in
                                    
                                 //   let startingCoordinate = (value.startLocation.x, value.startLocation.y)
                                    
                                 //   let endCoordinate = (value.location.x, value.location.y)
            
                                    let pointOfOrigin = (min(value.startLocation.x, value.location.x), min(value.startLocation.y, value.location.y))

                                    let width = abs(value.location.x - value.startLocation.x)
                                    
                                    let height = abs(value.location.y - value.startLocation.y)
                                    
                                  //  print(startingCoordinate)
                                  //  print(endCoordinate)
                                  //  print(pointOfOrigin)
                                    
                                   // print(selected.
                                    
                                    let rect = Rect(x: pointOfOrigin.0, y: pointOfOrigin.1, width: width, height: height)
                                    
                                    rectArray.append(rect)
                                    
                                    //if (rectDict.count == 0 || rectDict["\(selected.hashValue)"] == nil) {
                                        rectDict["\(selected.hashValue)"] = rectArray
                                    //}
                                    
                                    
                                   // print(rectArray)
                                   // print(rectDict)
                                    
                                    //let jsonString = "{\"location\": \"the moon\"}"
                                    
                                    let jsonString = """
                                    [
                                        {
                                            "image": "\(selected.hashValue)",
                                            "annotations": [
                                                {
                                                    "coordinates": {
                                                        "x": \((pointOfOrigin.0).truncate(places: 0)), "y": \((pointOfOrigin.1).truncate(places: 0)), "width": \((width).truncate(places: 0)), "height": \((height).truncate(places: 0))
                                                    }
                                                },
                                                {
                                                    "label": "tuna",
                                                    "coordinates": {
                                                        "x": 230, "y": 321, "width": 50, "height": 50
                                                    }
                                                }
                                            ]
                                        }
                                    ]
                                """
                                    
                                    var jsonString2 = """
                                    [
                                        {

                                    """
                               //     jsonString2.append("        image: \(selected.hashValue),")
                               //     jsonString2.append("\n")
                               //     jsonString2.append("""
                               //         annotations: [
                               //             {

                           /// """)
                                    jsonString2.append(makeJSON(dict: rectDict))
                                    jsonString2.append("""
                                            ]
                                        }
                                    ]
                                    """)
                                   print(jsonString2)
                                  //  print((makeJSON(dict: rectDict)))
                                    
                                    if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                                        in: .userDomainMask).first {
                                        let pathWithFilename = documentDirectory.appendingPathComponent("Essaie.json")
                                        do {
                                            try jsonString.write(to: pathWithFilename,
                                                                 atomically: true,
                                                                 encoding: .utf8)
                                        } catch {
                                            // Handle error
                                        }
                                    }
                                    
                                }))
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                Button(action: {
                    self.selected.removeAll()
                    self.show.toggle()
                    
                }) {
                    Text("Image Picker")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .frame(width: UIScreen.main.bounds.width / 2)
                }
                .background(Color.red)
                .clipShape(Capsule())
                .padding(.top, 25)
            }
            
            if self.show {
                CustomPicker(selected: self.$selected, show: self.$show, rectArray: self.$rectArray)
            }
        }
    }
}

private func makeJSON(dict: Dictionary<String, [Rect]>) -> String {
    var jsonString = ""
    for (key, rects) in dict {
        jsonString.append("        image: \(key),")
        jsonString.append("\n")
        jsonString.append("""
        annotations: [
            {

""")
        
        for rect in rects {
            jsonString.append("                coordinates: { \n")
            jsonString.append("                    x: \(rect.x), y: \(rect.y), width: \(rect.width), height: \(rect.height)\n ")
            jsonString.append("                }\n")
            jsonString.append("             },\n")
            
        }
        
        
    
        
//        for value in dict.values {
//            for i in 0..<dict.values.count {
//                jsonString.append("x: \(value[i].x), ")
//              //  print(("x: \(value[i].x), "))
//           // jsonString.append("y: \(value.y)")
//      //      jsonString.append("\(value.width, )"
//            }
//        }
     }
    
    return jsonString
}

extension CGFloat {
    func truncate(places : CGFloat)-> CGFloat {
        return CGFloat(floor(pow(10.0, CGFloat(places)) * self)/pow(10.0, CGFloat(places)))
    }
}


