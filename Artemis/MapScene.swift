//
//  MapScene.swift
//  Artemis
//
//  Created by Krithick Santhosh on 23/01/23.
//

import UIKit
import GoogleMaps

protocol geoSearchDelegate {
    func geoSearch(countryCode: String)
    func resetNews()
}

/// Handler that reports a geocoding response, or error.
//public typealias GeocodeCallback = (_ results: [GMSReverseGeocodeCallback]?, _ error: Error?) -> Void

class MapScene: UIViewController , GMSMapViewDelegate{
    
    var delegate: geoSearchDelegate?
    var countryCode: String = "in"
    var countryName: String = "India"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                // Create a GMSCameraPosition that tells the map to display the
                // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 10.86, longitude: 60.20, zoom: 3.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.isIndoorEnabled = false
        mapView.delegate = self
        self.view.addSubview(mapView)
        toastSettings(message: "Select a location",duration: 1)
        // Creates a marker in the center of the map.
//        setMarker(mapView, -33.86, 151)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        setMarker(mapView, coordinate.latitude, coordinate.longitude)
    }
    
    func setMarker(_ mapView: GMSMapView, _ lat: Double ,_ long: Double){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        marker.title = "Sydney"
//        marker.snippet = "Australia"
        marker.map = mapView
        let geoCoder = GMSGeocoder()
        geoCoder.reverseGeocodeCoordinate(marker.position, completionHandler: {Result,Error in
            guard let Result else {
                print("unavaible")
                self.countryNotFoundToast()
                return
            }
            
            let country = Result.firstResult()?.country ?? "none"
            if(country == "none"){
                self.countryNotFoundToast()
            }
            else {
                self.countryCode = countryCodeDict[country] ?? "none"
                self.countryName = country
                if(self.countryCode != "none"){
                    self.displayNews()
                }
                else {
                    self.countryNotFoundToast()
                }
            }
        })
    }
    
    fileprivate func countryNotFoundToast() {
        toastSettings(message:  "Can't display news for selected location",duration: 0.5)
    }
    
    fileprivate func toastSettings(message: String,duration: Double){
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .systemGray
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        alert.view.translatesAutoresizingMaskIntoConstraints = false

        
        self.sheetPresentationController?.detents = [.medium()]
        self.present(alert,animated:true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration){
            alert.dismiss(animated: true)
        }
    }
    
    fileprivate func displayNews() {
        let newsView =  TableViewController()
        self.delegate = newsView
        newsView.newsType = .geopraphicNews
        print("Delegated function to be invoked :",delegate ?? "Error invoking delegate")
        delegate?.geoSearch(countryCode: countryCode)
        
        newsView.title = "News from : " + countryName
        newsView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "<<", style: .plain, target: self, action: #selector(dismissSelf))
        
        let navVC = UINavigationController(rootViewController: newsView)
        
        navVC.modalPresentationStyle = .pageSheet
        navVC.sheetPresentationController?.detents = [.medium(),.large()]
        navVC.sheetPresentationController?.prefersGrabberVisible = true
        present(navVC,animated: true,completion: nil)
    }
    
    @objc private func dismissSelf() {
        delegate?.resetNews()
        dismiss(animated: true,completion: nil)
    }

}
