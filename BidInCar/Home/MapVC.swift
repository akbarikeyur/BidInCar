//
//  MapVC.swift
//  BidInCar
//
//  Created by Keyur on 15/11/19.
//  Copyright © 2019 Keyur. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var myMapView: MKMapView!
    
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delay(1.0) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
            self.myMapView.addAnnotation(annotation)
            let region: MKCoordinateRegion = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
            self.myMapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func clickToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
