//
//  SelectAddressVC.swift
//  BidInCar
//
//  Created by Keyur on 18/11/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol SelectAddressDelegate {
    func updateLocationAddress(_ lat : Double, _ lng : Double, _ address : String)
}

class SelectAddressVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var titleLbl: Label!
    @IBOutlet weak var addressTxt: TextField!
    
    var currentLocation: CLLocation!
    let locationManager = CLLocationManager()
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var selectedAddress : String = ""
    var isReadyToCall = true
    var delegate : SelectAddressDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            print("Location services are not enabled");
        }
        myMapView.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        locationManager.stopUpdatingLocation()
        updateLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func updateLocation()
    {
        let region: MKCoordinateRegion = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
        self.myMapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        latitude = mapView.centerCoordinate.latitude
        longitude = mapView.centerCoordinate.longitude
        getSelectedAddress()
    }
    
    @IBAction func clickToBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickToDone(_ sender: Any) {
        self.view.endEditing(true)
        if addressTxt.text?.trimmed == "" {
            displayToast("enter_auction_address")
        }
        else {
            delegate?.updateLocationAddress(latitude, longitude, addressTxt.text!)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func getSelectedAddress()
    {
        if !isReadyToCall {
            return
        }
        isReadyToCall = false
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = latitude
        center.longitude = longitude

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc) { (placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            if pm.count > 0 {
                  let pm = placemarks![0]
                  var addressString : String = ""
                  if pm.subLocality != nil {
                      addressString = addressString + pm.subLocality! + ", "
                  }
                  if pm.thoroughfare != nil {
                      addressString = addressString + pm.thoroughfare! + ", "
                  }
                  if pm.locality != nil {
                      addressString = addressString + pm.locality! + ", "
                  }
                  if pm.country != nil {
                      addressString = addressString + pm.country! + ", "
                  }
                  if pm.postalCode != nil {
                      addressString = addressString + pm.postalCode! + " "
                  }
                self.selectedAddress = addressString
                self.addressTxt.text = addressString
                print(addressString)
                self.isReadyToCall = true
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
