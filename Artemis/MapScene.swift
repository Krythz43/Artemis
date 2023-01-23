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

class MapScene: UIViewController , GMSMapViewDelegate{
    
    var delegate: geoSearchDelegate?
    var countryCode: String = "in"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                // Create a GMSCameraPosition that tells the map to display the
                // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.isIndoorEnabled = false
        mapView.delegate = self
        self.view.addSubview(mapView)
        // Creates a marker in the center of the map.
        setMarker(mapView, -33.86, 151)
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
        displayNews()
    }
    
    fileprivate func displayNews() {
        let newsView =  TableViewController()
        self.delegate = newsView
        
        print("Delegated function to be invoked :",delegate ?? "Error invoking delegate")
        delegate?.geoSearch(countryCode: countryCode)
        
        newsView.title = "Displaying news from : " + countryCode
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
