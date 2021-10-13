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
    var body: some View {
        ZStack {
            Color.black.opacity(0.07).edgesIgnoringSafeArea(.all)
            
            VStack {
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
            }
            
            if self.show {
                CustomPicker(selected: self.$selected, show: self.$show)
            }
        }
    }
}

struct CustomPicker: View {
    
    @Binding var selected: [UIImage]
    @State var data: [Images] = []
    @State var grid: [Int] = []
    @Binding var show: Bool
    
    var body: some View {
        GeometryReader {geometry in
           // Spacer()
            VStack {
                if !self.grid.isEmpty {
                    HStack {
                        Text("Pick a Image")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.leading)
                    .padding(.top)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 20) {
                            ForEach(self.grid, id: \.self) {i in
                                HStack(spacing: 8) {
                                    ForEach(i..<i+3, id: \.self){j in
                                        HStack {
                                            if j < self.data.count {
                                                Card(data: self.data[j], selected: self.$selected)
                                            }
                                        }
                                    }
                                    if self.data.count % 3 != 0 && i == self.grid.last! {
                                        Spacer()
                                    }
                                }
                                .padding(.leading, (self.data.count % 3 != 0 && i == self.grid.last!) ? 15: 0)
                            }
                        }
                    }
                    
                    Button(action: {
                        self.show.toggle()
                    }) {
                        
                        Text("Select")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .frame(width: UIScreen.main.bounds.width / 2)
                    }
                    .background(Color.red.opacity((self.selected.count != 0) ? 1 : 0.5))
                    .clipShape(Capsule())
                    .padding(.bottom, 25)
                    .disabled((self.selected.count != 0) ? false : true)
                }
                
                else {
                    Indicator()
                }
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height / 1.5, alignment: .center)
            .background(Color.white)
            .cornerRadius(12)
        }
        .background(Color.black.opacity(0.1).edgesIgnoringSafeArea(.all))
        .onTapGesture {
            self.show.toggle()
        }
        .onAppear {
            PHPhotoLibrary.requestAuthorization{ (status) in
                if status == .authorized {
                    self.getAllImages()
                }
                else {
                    print ("not authorized")
                }
            }
        }
    }
    func getAllImages() {
        let req = PHAsset.fetchAssets(with: .image, options: .none)
        DispatchQueue.global(qos: .background).async {
            req.enumerateObjects { (asset, _, _) in
                
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                PHCachingImageManager.default().requestImage(for: asset, targetSize: .init(), contentMode: .default, options: options) { (image, _) in
                    
                    let data1 = Images(image: image!, selected: false)
                    self.data.append(data1)
                }
            }
            
            if req.count == self.data.count {
                self.getGrid()
            }
        }
    }
    
    func getGrid() {
        for i in stride(from: 0, to: self.data.count, by: 3) {
            self.grid.append(i)
        }
    }
}

struct Images {
    
    var image: UIImage
    var selected: Bool
}

struct Card : View {
    @State var data: Images
    @Binding var selected : [UIImage]
    
    var body: some View {
        
        ZStack {
            Image(uiImage: self.data.image)
            .resizable()
            
            if self.data.selected {
                ZStack {
                    Color.black.opacity(0.5)
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(width: (UIScreen.main.bounds.width - 80) / 3, height: 90)
        .onTapGesture {
            if !data.selected {
                print(data.image.hashValue)
            }
            
            if !self.data.selected {
                self.data.selected = true
                self.selected.append(self.data.image)
            }
            
            else {
                for i in 0..<self.selected.count {
                    if self.selected[i] == self.data.image {
                        self.selected.remove(at: i)
                        self.data.selected = false
                        return
                    }
                }
            }
        }
    }
}

struct Indicator : UIViewRepresentable {
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
