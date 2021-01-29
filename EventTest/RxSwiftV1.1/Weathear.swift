//
//  Weathear.swift
//  EventTest
//
//  Created by apple on 2020/10/12.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation
import MapKit

//MARK:-
final class WeathearApiController {
    
    struct Weathear {
        let cityName: String
        let temperature: Int
        let humidity: Int
        let icon: String
        
        
        static let empty = Weathear(cityName: "", temperature: 0, humidity: 0, icon: "")
        
        final class Overlay:NSObject, MKOverlay {
            var coordinate: CLLocationCoordinate2D
            var boundingMapRect: MKMapRect
            

            init(coordinate: CLLocationCoordinate2D
                 ,boundingMapRect:MKMapRect) {
                self.coordinate = coordinate
                self.boundingMapRect = boundingMapRect
            }

        }
        
        final class OverlayView: MKOverlayRenderer {
            
        }
        
        func overlay() -> Overlay {
            //demo
            return Overlay(coordinate: CLLocationCoordinate2D.init(latitude: 20.0, longitude: 20.0),
                           boundingMapRect: .init(x: 0, y: 0, width: 0, height: 0))
        }
    }

    
    static let shared = WeathearApiController()
    
    func currentWeather(city:String) -> Observable<Weathear> {
        return Observable.just(
        Weathear(cityName: city, temperature: 20, humidity: 90, icon: "")
        ).share(replay: 1)
    }
    
    func currentWeather(lat: Double ,lon: Double) -> Observable<Weathear> {
        return Observable.just(Weathear.empty)
            .share(replay: 1)
    }
    
    func currentWeatherAround(lat:Double,lon:Double) -> [Observable<Weathear>] {
        
        //使用算法在中心点计算一些点,这里为了简单,直接循环创建三个
        var result = [Observable<Weathear>]()
        for _ in 0..<3 {
            result.append(Observable.just(
                Weathear(cityName: "challenge", temperature: 20, humidity: 90, icon: "")
                ).share(replay: 1))
        }
        return result
    }
}


//MARK: -
class WeathearViewController: UIViewController {
    
    let tempLabel = UILabel()
    let iconLabel  = UILabel()
    let humidityLabel = UILabel()
    let cityNameLabel = UILabel()
    
    let searchCityName = UITextField()
    
    //计算方式切换开关
    let tempTypeSwitch = UISwitch()
    
    let activityIndicator  = UIActivityIndicatorView()
    
    let locationManager = CLLocationManager()
    let geoLoactionBtn = UIButton()
    
    let disposeBag = DisposeBag()
    
    let mapView = MKMapView()
    let mapBtn = UIButton()
    
    var cache = [String:WeathearApiController.Weathear]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _Section_III_Chapter_11_Beginning_RxCocoa()
    
    }
    
    
    
    private func _Section_IV_Chapter_14_Error_Hanlding_in_Practice() {
        do {
            let text = "city"
           let weatherRequest = WeathearApiController.shared.currentWeather(city: text)
                .do(onNext: {
                    data in
                    self.cache[text] = data
                })
                .retry(3)
                .catchError { (error) -> Observable<WeathearApiController.Weathear> in
                    if let c = self.cache[text] {
                        return Observable.just(c)
                    } else {
                        return Observable.just(WeathearApiController.Weathear.empty)
                    }
                }
            
            weatherRequest
                .subscribe()
                .disposed(by: disposeBag)
        }
       
        
        do {
            let text = "city"
            let weatherRequest = WeathearApiController.shared.currentWeather(city: text)
                .do(onNext: {
                    data in
                    self.cache[text] = data
                })
                .retryWhen { (error) -> Observable<WeathearApiController.Weathear> in
                    ///解析错误类型,决定是否重试
                    
                   return error.enumerated()
                           .flatMap {
                            (count,e) in
                        return  WeathearApiController.shared.currentWeather(city: text)
                    }
                }
            
            weatherRequest
                .subscribe()
                .disposed(by: disposeBag)
        }
        
     
        
    }
    
    private func  _Section_III_Chapter_12_Intermediate_RxCocoa() {
        
        ///在搜索时显示菊花,和隐藏其它的label
        ///搜索结束隐藏菊花,显示其它的label
        
        mapView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        
        ///显示位置
        do {
            ///获取位置信息按钮点击
            let geoInput =  geoLoactionBtn.rx.tap.asObservable()
                .do(onNext: {
                    [weak self] _ in
                    self?.locationManager.requestWhenInUseAuthorization()
                    self?.locationManager.startUpdatingLocation()
                })
            
            let currentLocation = locationManager.rx.didUpdateLocations
            
            let geolocation = geoInput.flatMap {
                currentLocation.take(1)
            }
            
            
            let geoSearch = geolocation.flatMap {
                location ->  Observable<WeathearApiController.Weathear>  in
               
                return WeathearApiController.shared.currentWeather(lat: location.first!.coordinate.latitude, lon:  location.first!.coordinate.longitude)
                    .catchErrorJustReturn(WeathearApiController.Weathear.empty)
            }
           
            
            let searchInput = searchCityName.rx.controlEvent(.editingDidEndOnExit).asObservable()
                .map {
                    [weak self] in
                    self?.searchCityName.text
                }
                .filter { ($0 ?? "").count > 0 }
            
            let textSearch = searchInput.flatMap {
                text in
                return WeathearApiController.shared.currentWeather(city: text ?? "Error")
                    .catchErrorJustReturn(WeathearApiController.Weathear.empty)
            }
            
            
            
            let mapInput = mapView.rx.regionDidChangeAnimated
                .skip(1)
                .map { [weak self] _ in
                    self?.mapView.centerCoordinate
                }
            ///React to regionDidChangeAnimated events
            ///响应地图的滚动来更新天气信息
            let mapSearch = mapInput.flatMap {
                coordinate -> Observable<WeathearApiController.Weathear> in
               
                if let c = coordinate {
                    return WeathearApiController.shared.currentWeather(lat: c.latitude, lon: c.longitude)
                        .catchErrorJustReturn(WeathearApiController.Weathear.empty)
                } else {
                    return Observable.just(WeathearApiController.Weathear.empty)
                }
            }
            
            
            let search = Observable.from([geoSearch,textSearch,mapSearch])
                .merge()
                .asDriver(onErrorJustReturn: WeathearApiController.Weathear.empty)
            
            
            let running = Observable.from([
                searchInput.map {_ in true },
                geoInput.map { _ in true },
                mapInput.map {_ in true},
                search.map {_ in false }.asObservable()
                
            ])
            .merge()
            .asDriver(onErrorJustReturn: false)
           
            
            
            running
                .skip(1)
                .drive(activityIndicator.rx.isAnimating)
                .disposed(by: disposeBag)
            
            running
                .drive(tempLabel.rx.isHidden)
                .disposed(by: disposeBag)
            
            running
                .drive(iconLabel.rx.isHidden)
                .disposed(by: disposeBag)
            
            running
                .drive(humidityLabel.rx.isHidden)
                .disposed(by: disposeBag)
            
            running
                .drive(cityNameLabel.rx.isHidden)
                .disposed(by: disposeBag)
        
            
            currentLocation
                .subscribe(onNext: {
                    locations in
                    debugPrint(locations)
                })
                .disposed(by: disposeBag)
            
            
           /// Challenge 1: Add a binding property to focus the map on a given point
            let textAndGeoSearch = Observable.from([geoSearch,textSearch])
                .merge()
                .asDriver(onErrorJustReturn: WeathearApiController.Weathear.empty)
            
            textAndGeoSearch
                .map { _ in
                    CLLocationCoordinate2D.init(latitude: 0.0, longitude: 0.0)
                }
                .drive(mapView.rx.centerCoordinate)
                .disposed(by: disposeBag)
                
            /// Challenge 2: 滑动地图,显示中心点和其周围的 天气状况
            
          let mapSearchAround = mapInput.flatMap {
                coordinate -> Observable<WeathearApiController.Weathear> in
                if let c = coordinate {
                    return  Observable
                        .from(WeathearApiController.shared.currentWeatherAround(lat: c.latitude, lon: c.longitude))
                        .merge()
                        .catchErrorJustReturn(WeathearApiController.Weathear.empty)
                } else {
                    return Observable.just(WeathearApiController.Weathear.empty)
                }
            }
            .asDriver(onErrorJustReturn: WeathearApiController.Weathear.empty)
          
           mapSearchAround
            .map {[$0.overlay()]}
            .drive(mapView.rx.overlays)
            .disposed(by: disposeBag)
            
        }
        
        ///扩展地图
        do {
            
            let searchInput = searchCityName.rx.controlEvent(.editingDidEndOnExit).asObservable()
                .map {
                    [weak self] in
                    self?.searchCityName.text
                }
                .filter { ($0 ?? "").count > 0 }
            
            let search = searchInput
                .flatMap {
                    text in
                   return WeathearApiController.shared.currentWeather(city: text ?? "Error")
                        .catchErrorJustReturn(WeathearApiController.Weathear.empty)
                }
                .asDriver(onErrorJustReturn: WeathearApiController.Weathear.empty)
            
       ///更新地图上的小图标
            search
                .map { return [$0.overlay()]}
                .drive(mapView.rx.overlays)
                .disposed(by: disposeBag)
                
            
            mapBtn.rx.tap
                .subscribe(onNext: {
                    [weak self] _ in
                    self?.mapView.isHidden = !(self?.mapView.isHidden ?? false)
                })
                .disposed(by: disposeBag)
            
        }
        
       
       
    }
    
    private func  _Section_III_Chapter_11_Beginning_RxCocoa() {
        
        WeathearApiController.shared.currentWeather(city: "RxSwift")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {
                [weak self]
                (weather) in
              
                self?.tempLabel.text = "\(weather.temperature) ℃"
                self?.humidityLabel.text = "\(weather.humidity)%"
                self?.iconLabel.text = weather.icon
                self?.cityNameLabel.text = weather.cityName
                
            })
            .disposed(by: disposeBag)
         
        let search = searchCityName.rx.controlEvent(.editingDidEndOnExit).asObservable()
            .map {
                [weak self] in
                self?.searchCityName.text
                
            }
            .flatMap {
                text in
                return WeathearApiController.shared.currentWeather(city: text ?? "Error")
            }
            .asDriver(onErrorJustReturn: WeathearApiController.Weathear.empty)
        
        
        search.map { "\($0.temperature) ℃" }
            .drive(tempLabel.rx.text)
            .disposed(by: disposeBag)
        
        search.map{ $0.icon }
            .drive(iconLabel.rx.text)
            .disposed(by: disposeBag)
        
        search.map { "\($0.humidity)" }
            .drive(humidityLabel.rx.text)
            .disposed(by: disposeBag)
        
        search.map { "\($0.cityName)"}
            .drive(cityNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        ///changllengs
        
        ///摄氏度
          tempTypeSwitch.rx.isOn
            .map {
                //获取本地的温度数据
                
                $0 == true ? "摄氏度" : "华氏度"
            }
            .asDriver(onErrorJustReturn: "--")
            .drive(self.tempLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
}


extension WeathearViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if let overlay = overlay as? ApiController.Weather.Overlay {
//        let overlayView = ApiController.Weather.OverlayView(overlay: overlay, overlayIcon: overlay.icon)
//                    return overlayView
//                }
        return MKOverlayRenderer()
    }
}
