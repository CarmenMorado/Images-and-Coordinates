//
//  CustomPicker.swift
//  Images and Coordinates
//
//  Created by Carmen Morado on 10/28/21.
//

import SwiftUI
import Photos

struct CustomPicker: View {
    
    @Binding var selected: [UIImage]
    @State var data: [Images] = []
    @State var grid: [Int] = []
    @Binding var show: Bool
    @State var disabled = false
    @Binding var rectArray: [Rect]
    
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
                        rectArray.removeAll()
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
                    if self.disabled {
                        Text("Enable Storage Access In Settings !!!")
                    }
                    
                    else {
                        Indicator()
                    }
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
                    self.disabled = false
                }
                
                else {
                    print ("not authorized")
                    self.disabled = true
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

