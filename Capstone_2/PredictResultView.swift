import SwiftUI
import Alamofire

struct PredictResult: Codable{
    var name:String
    var score:Double
}

extension View {
    @MainActor func render(scale displayScale: CGFloat = 1.0) -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = displayScale
        return renderer.uiImage
    }
}

struct PredictResultView: View {
    @State var userSelectImage:Image
    @State var userSelectUIImage:UIImage
    @State private var predictResult:PredictResult?
    @State private var boundingBoxWidth:Double = 0.0
    @State private var boundingBoxHeight:Double = 0.0
    @State private var xOffset:Double = 0.0
    @State private var yOffset:Double = 0.0
    @State private var displaedPredictResultNumber = 0
    
    @MainActor
    init(userSelectImage: Image){
        self.userSelectImage = userSelectImage
        self.userSelectUIImage = userSelectImage.render(scale: 1.0) ?? UIImage()
    }
    
    var body: some View {
        ScrollView{
            VStack(spacing:30){
                ZStack{
                    userSelectImage.resizable()
                        .frame(width: UIScreen.main.bounds.width,
                               height: (UIScreen.main.bounds.width / self.userSelectUIImage.size.width) * self.userSelectUIImage.size.height)
                        .onAppear{
                            let url = "http://15.164.100.224:8080/rest/predict"
                            AF.upload(multipartFormData: { multipartData in
                                multipartData.append(userSelectUIImage.jpegData(compressionQuality: 1.0)!, withName: "image", fileName:"test.jpeg", mimeType: "image/jpeg")
                            },to:url,
                                      method: .post,
                                      headers: ["Content-Type" : "multipart/form-data"])
                            .response { response in
                                switch response.result{
                                case .success:
                                    do{
                                        guard var result = response.data else { return }
//                                        var resultString = String(decoding: result, as: UTF8.self)
//                                        print("result : \(resultString)")
                                        let json = try JSONDecoder().decode(PredictResult.self, from: result)
                                        self.predictResult = json
                                    }catch{print(error)}
                                case .failure(let e):
                                    print(e)
                                }
                            }
                        }
                    Rectangle()
                        .frame(width: boundingBoxWidth, height: boundingBoxHeight)
                        .foregroundColor(.black.opacity(0.0))
                        .border(Color.red, width: 3)
                        .position(x:boundingBoxWidth / 2,y:boundingBoxHeight / 2)
                        .offset(x:xOffset, y:yOffset)
                    
//                }.onChange(of:self.displaedPredictResultNumber){ _, newVlaue in
//                    let w = UIScreen.main.bounds.width
//                    let h = (UIScreen.main.bounds.width / self.userSelectUIImage.size.width) * self.userSelectUIImage.size.height
//                    if let boundboxPoints = self.predictResult?.boundBoxCoordinates{
//                        let ymin = boundboxPoints[self.displaedPredictResultNumber * 4] * h
//                        let xmin = boundboxPoints[self.displaedPredictResultNumber * 4 + 1] * w
//                        let ymax = boundboxPoints[self.displaedPredictResultNumber * 4 + 2] * h
//                        let xmax = boundboxPoints[self.displaedPredictResultNumber * 4 + 3] * w
//                        self.boundingBoxWidth = xmax - xmin
//                        self.boundingBoxHeight = ymax - ymin
//                        self.xOffset = xmin
//                        self.yOffset = ymin
//                    }
                }
                
                HStack(spacing:50){
                    Text(self.predictResult?.name ?? "loading")
                    Text(String(self.predictResult?.score ?? 0.0))
                }
                
//                HStack(spacing:30){
//                    Button(action: {
//                        self.displaedPredictResultNumber -= 1
//                        if let count = self.predictResult?.classNames.count{
//                            if self.displaedPredictResultNumber < 0{
//                                self.displaedPredictResultNumber = count
//                            }
//                        }
//                    }) {
//                        Text("prev obj")
//                            .fontWeight(.bold)
//                            .font(.title)
//                            .foregroundColor(.purple)
//                            .frame(width: 110, height: 20)
//                            .padding()
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.purple, lineWidth: 3)
//                            )
//                    }
//                    Button(action: {
//                        self.displaedPredictResultNumber += 1
//                        if let count = self.predictResult?.classNames.count{
//                            if self.displaedPredictResultNumber >= count{
//                                self.displaedPredictResultNumber = 0
//                            }
//                        }
//                    }) {
//                        Text("next obj")
//                            .fontWeight(.bold)
//                            .font(.title)
//                            .foregroundColor(.purple)
//                            .frame(width: 110, height: 20)
//                            .padding()
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.purple, lineWidth: 3)
//                            )
//                    }
//                }
                Spacer()
            }
        }
    }
}

