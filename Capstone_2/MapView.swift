//
//  MapView.swift
//  Capstone_2
//
//  Created by Nicode . on 11/13/23.
//

import SwiftUI
import MapKit


extension CLLocationCoordinate2D{
    func getDistance(order:CLLocationCoordinate2D) -> Double{
        let x1 = Int(self.latitude * 100000)
        let x2 = Int(self.longitude * 100000)
        let y1 = Int(order.latitude * 100000)
        let y2 = Int(order.longitude * 100000)
        return sqrt(Double((x1 - y1) * (x1 - y1) + (x2 - y2) * (x2 - y2)))
    }
}

struct Place : Identifiable {
    var id: UUID = UUID()
    var locationName:String
    var handling_items:String
    var location: CLLocationCoordinate2D
    
    init(data : [String: Any]) {
        self.locationName = data["locationName"] as? String ?? "error"
        self.handling_items = data["handling_items"] as? String ?? "error"
        let lati = data["latitude"] as? CLLocationDegrees ?? 0
        let long = data["longitude"] as? CLLocationDegrees ?? 0
        self.location = CLLocationCoordinate2D(latitude: lati, longitude: long)
    }
    
    func getitems() -> [String]{
        return handling_items.components(separatedBy: "/")
    }
}

class SortObject:ObservableObject{
    @Published var sortBy = "distance"
    @Published var sortOrder = true
}

class PlacesObject: ObservableObject{
    @Published var places:[Place] = []
    @Published var region:MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -90.000000, longitude: 0.000000),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
}


struct MapView: View {
    
    @ObservedObject private var placesobject:PlacesObject = PlacesObject()
    @ObservedObject private var sortObject:SortObject = SortObject()
    
    private var locationService:LocationService = LocationService()
    
    func fetchCurrentLocation(){
        locationService.requestLocation { coordinate in
            placesobject.region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
    }
    
    func fetchRecyclingStations(){
        FirebaseManager.shared.firestore
            .collection("recycling station")
            .document("Seoul-Gangnamgu")
            .collection("places")
            .getDocuments(){
                (querySnapshot, error) in
                if let error = error {
                    print(error)
                    return
                }else{
                    for document in querySnapshot!.documents {
                        placesobject.places.append(.init(data: document.data()))
                    }
                }
            }
    }
    
    init(){
        fetchCurrentLocation()
        fetchRecyclingStations()
    }
    
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $placesobject.region, showsUserLocation: true, annotationItems: placesobject.places) { item in
                MapAnnotation(coordinate: item.location) {
                    VStack {
                        ZStack{
                            Circle()
                                .foregroundColor(.green.opacity(0.6))
                                .frame(width: 30, height: 30)
                            Image(systemName: "arrow.3.trianglepath")
                        }
                    }
                }
            }
            
            Button(action:{
                locationService.requestLocation { coordinate in
                    placesobject.region = MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))}
            }){
                Image(systemName: "location.north.circle.fill")
                    .resizable()
                    .frame(width:50, height:50)
            }.offset(x:165, y:140)
        }
        GeometryReader { proxy in
            HStack(spacing:10){
                Spacer().frame(maxWidth:proxy.size.width)
                Button(action: {
                    self.sortObject.sortBy = "stuff"
                    self.sortObject.sortOrder.toggle()
                    if (self.sortObject.sortOrder){
                        self.placesobject.places.sort(by: {$0.getitems().count > $1.getitems().count})
                    }else{
                        self.placesobject.places.sort(by: {$0.getitems().count < $1.getitems().count})
                    }
                }){
                    Text("물품순")
                    if (sortObject.sortOrder){
                        Image(systemName:"chevron.up")
                    }else{
                        Image(systemName:"chevron.down")
                    }
                }.foregroundColor(.black)
                Button(action: {
                    self.sortObject.sortBy = "distance"
                    self.sortObject.sortOrder.toggle()
                    if (self.sortObject.sortOrder){
                        self.placesobject.places.sort(by :{return $0.location.getDistance(order: self.placesobject.region.center) > $1.location.getDistance(order: self.placesobject.region.center)})
                    }else{
                        self.placesobject.places.sort(by :{return $0.location.getDistance(order: self.placesobject.region.center) < $1.location.getDistance(order: self.placesobject.region.center)})
                    }
                }){
                    Text("거리순")
                    if (sortObject.sortOrder){
                        Image(systemName:"chevron.up").padding(.trailing, 10)
                    }else{
                        Image(systemName:"chevron.down").padding(.trailing, 10)
                    }
                }.foregroundColor(.black)
            }.frame(width:proxy.size.width, height:20, alignment: .trailing)
        }.frame(height:20)
        ScrollView(showsIndicators: false){
            VStack(spacing:0){
                ForEach(placesobject.places){ place in
                    Divider().overlay(Color.gray.opacity(1))
                    ZStack{
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width, height:100)
                            .foregroundColor(.black.opacity(0.0))
                        VStack(alignment: .leading){
                            Text("위치 : " + place.locationName).bold().font(.system(size: 18))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 10).padding(.bottom, 5)
                            HStack(){
                                Text("취급물품 : ")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 10)
                                ForEach(place.getitems(), id:\.self){ i in
                                    Text(i).frame(maxWidth: 60, alignment: .leading).padding(0)
                                        .background(Rectangle().fill(.gray.opacity(0.4)).cornerRadius(6))
                                }
                            }.frame(maxWidth: place.getitems().count == 1 ? 146 : 214)
                        }
                    }.onTapGesture {
                        placesobject.region = MKCoordinateRegion(
                            center: place.location,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    MapView()
}
