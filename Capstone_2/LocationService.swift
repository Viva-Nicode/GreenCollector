//
//  LocationService.swift
//  Capstone_2
//
//  Created by Nicode . on 11/28/23.
//

import Foundation
import CoreLocation

// 이 클래스가 CLLocationManager의 어떤 처리를 대신해주는 클래스 즉 델리게이트가 된다.
class LocationService: NSObject, CLLocationManagerDelegate{
    
    private let manager = CLLocationManager()
    var completionHandler: ((CLLocationCoordinate2D) -> (Void))?
    
    override init(){
        super.init()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.delegate = self
        //위치 정보 승인 요청
        manager.requestWhenInUseAuthorization()
    }
    
    // 위치 정보 요청 - 정보 요청이 성공하면 실행될 completionHandler를 등록
    func requestLocation(completion: @escaping ((CLLocationCoordinate2D) -> (Void))) {
        completionHandler = completion
        manager.requestLocation()
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingHeading()
    }
    
    // CLLocationManagerDelegate에 옵셔널로 명시되어 있는 메서드로, manager가 호출해준다.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        //requestLocation 에서 등록한 completion handler를 통해 위치 정보를 전달
        if let completion = self.completionHandler {
            completion(location.coordinate)
        }
        //위치 정보 업데이트 중단
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
