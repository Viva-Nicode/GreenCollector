import SwiftUI
import PhotosUI
import Foundation

struct ContentView: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var shouldShowLogOutOptions = false
    @State var shouldShowPredictResult = false
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var userSelctedImage: Image?
    @State private var isLogin =  true
    @State private var currentUserEmail = "dmswns0147@gmail.com"
    
    init(){
        isLogin = FirebaseManager.shared.auth.currentUser?.uid == nil
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing:16){
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipped()
                        .cornerRadius(50)
                        .shadow(radius: 5)
                    
                    VStack(alignment: .leading, spacing: 4){
                        Text(self.currentUserEmail).font(.system(size: 20, weight: .bold))
                            .frame(maxWidth:300, alignment:.leading)
                        HStack{
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: 14, height: 14)
                            Text("online")
                                .font(.system(size:12))
                                .foregroundColor(Color(.lightGray))
                        }
                    }
                    Button{
                        shouldShowLogOutOptions.toggle()
                    }label: {
                        Image(systemName: "gear")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.gray)
                    }
                }.padding().background(.gray.opacity(0.2))
                    .actionSheet(isPresented: $shouldShowLogOutOptions) {
                        .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                            .destructive(Text("Sign Out"), action: {
                                print("handle sign out")
                            }),
                            .cancel()
                        ])
                    }
                HStack{
                    Text("Options").font(.system(size:40))
                        .foregroundStyle(.black)
                        .padding(.leading,20)
                        .underline(true, color: .gray)
                    Spacer()
                }.padding(.bottom,-10)
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        PhotosPicker(selection:$photosPickerItem, matching: .images){
                            ZStack{
                                Rectangle()
                                    .frame(height:200)
                                    .cornerRadius(20)
                                VStack{
                                    Image(systemName: "photo.fill.on.rectangle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.black)
                                    Text("get photo").foregroundStyle(.black)
                                }
                            }.containerRelativeFrame(.horizontal,
                                                     count:verticalSizeClass == .regular ? 2 : 4, spacing: 14)
                            .foregroundStyle(.indigo.gradient)
                            .scrollTransition{ content, phase in
                                content.opacity(phase.isIdentity ? 1.0 : 0.0)
                                    .scaleEffect(x:phase.isIdentity ? 1.0 : 0.3, y:phase.isIdentity ? 1.0 : 0.3)
                                    .offset(y:phase.isIdentity ? 0 : 50)
                            }
                        }
                        
                        ZStack{
                            NavigationLink(value:3){
                                Rectangle()
                                    .frame(height:200)
                                    .cornerRadius(20)
                            }
                            VStack{
                                Image(systemName: "location.magnifyingglass")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.black)
                                Text("recycling station").foregroundStyle(.black)
                            }
                        }.containerRelativeFrame(.horizontal,
                                                 count:verticalSizeClass == .regular ? 2 : 4, spacing: 14)
                        .foregroundStyle(.green.gradient)
                        .scrollTransition{ content, phase in
                            content.opacity(phase.isIdentity ? 1.0 : 0.0)
                                .scaleEffect(x:phase.isIdentity ? 1.0 : 0.3, y:phase.isIdentity ? 1.0 : 0.3)
                                .offset(y:phase.isIdentity ? 0 : 50)
                        }
                        
                        ZStack{
                            NavigationLink(value:2){
                                Rectangle()
                                    .frame(height:200)
                                    .cornerRadius(20)
                            }
                            VStack{
                                Image(systemName: "chart.line.downtrend.xyaxis")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.black)
                                Text("statistics").foregroundStyle(.black)
                            }
                        }.containerRelativeFrame(.horizontal,
                                                 count:verticalSizeClass == .regular ? 2 : 4, spacing: 14)
                        .foregroundStyle(.pink.gradient)
                        .scrollTransition{ content, phase in
                            content.opacity(phase.isIdentity ? 1.0 : 0.0)
                                .scaleEffect(x:phase.isIdentity ? 1.0 : 0.3, y:phase.isIdentity ? 1.0 : 0.3)
                                .offset(y:phase.isIdentity ? 0 : 50)
                        }
                        
                        ForEach(MockData.items){ item in
                            ZStack{
                                Rectangle()
                                    .frame(height:200)
                                    .cornerRadius(20)
                                VStack{
                                    Image(systemName: item.sysImageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(.black)
                                    Text(item.title).foregroundStyle(.black)
                                }
                            }.containerRelativeFrame(.horizontal,
                                                     count:verticalSizeClass == .regular ? 2 : 4, spacing: 14)
                            .foregroundStyle(item.color.gradient)
                            .scrollTransition{ content, phase in
                                content.opacity(phase.isIdentity ? 1.0 : 0.0)
                                    .scaleEffect(x:phase.isIdentity ? 1.0 : 0.3, y:phase.isIdentity ? 1.0 : 0.3)
                                    .offset(y:phase.isIdentity ? 0 : 50)
                            }
                        }
                    }.scrollTargetLayout()
                        .onChange(of: photosPickerItem){ _, _ in
                            Task{
                                if let data = try? await photosPickerItem?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        userSelctedImage = Image(uiImage: uiImage)
                                        self.shouldShowPredictResult.toggle()
                                        return
                                    }
                                }
                            }
                        }
                }.contentMargins(16, for:.scrollContent)
                    .scrollTargetBehavior(.viewAligned)
                GeometryReader { proxy in
                    Spacer().frame(maxHeight:proxy.size.height)
                }
            }.navigationDestination(isPresented: self.$shouldShowPredictResult) {
                PredictResultView(userSelectImage: self.userSelctedImage ?? Image("heating_pad451"))
            }.navigationDestination(for: Int.self){ number in
                switch number{
                case 3:
                    MapView()
                case 2:
                    StatisticsView()
                default:
                    Text("error")
                }
                
            }
        }
        .fullScreenCover(isPresented:$isLogin){
            AccountView(didCompleteLoginProcess: {
                self.isLogin = false
                guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
                FirebaseManager.shared.firestore.collection("users").document(uid).getDocument{
                    snapshot, error in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let data = snapshot?.data() else { return }
                    self.currentUserEmail = data["email"] as? String ?? ""
                }
            })
        }
    }
}

struct Item: Identifiable{
    let id = UUID()
    let color: Color
    let title: String
    let sysImageName: String
}

struct MockData{
    static var items = [Item(color:.orange, title:"community", sysImageName: "list.clipboard"),
                        Item(color:.purple, title:"your info", sysImageName: "person.crop.rectangle")]
}

#Preview {
    ContentView()
}

