//
//  MapViewController.swift
//  MapKitAssignment
//
//  Created by Sindhya on 9/26/17.
//  Copyright © 2017 SJSU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Foundation

class MapViewController: UIViewController,MKMapViewDelegate {

    var fromLocation = ""
    var toLocation = ""
    var viewType = ""
    var clGeocoder = CLGeocoder()
    var locations = [String]()
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate=self
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func onClickMapType(_ sender: Any) {
        
        if mapView.mapType == MKMapType.standard {
            mapView.mapType = MKMapType.satellite
        } else {
            mapView.mapType = MKMapType.standard
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("fromLoc = "+fromLocation)
        print("toLoc = "+toLocation)
        
        if(!fromLocation.isEmpty){
            locations.append(fromLocation)
        }
        if(!toLocation.isEmpty){
            locations.append(toLocation)
        }
        
        if viewType == "map" {
            mapPlot(places: locations, polyline: false)
        } else if viewType == "route" {
            mapPlot(places: locations, polyline: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func mapPlot(places:[String], polyline:Bool) {
        var i = 1
        var coordinates: CLLocationCoordinate2D?
        var placemark: CLPlacemark?
        var annotation: Annotation?
        var annotationsArr:Array = [Annotation]()
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        for address in places {
            clGeocoder = CLGeocoder()
            clGeocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil)  {
                    print("Error", error!)
                }
                placemark = placemarks?.first
                if placemark != nil {
                    coordinates = placemark!.location!.coordinate
                    points.append(coordinates!)
                    
                    print("locations = \(coordinates!.latitude) \(coordinates!.longitude)")
                    annotation = Annotation(latitude: coordinates!.latitude, longitude: coordinates!.longitude, address: address)
                    annotationsArr.append(annotation!)
                    print(annotationsArr.count)
                    print(i)
                    if (i == self.locations.count) {
                        
                        self.mapView.addAnnotations(annotationsArr)
                        if (polyline == true) {
                            //let line = MKPolyline(coordinates: &points, count: points.count)
                            //self.mapView.add(line)
                            
                            let srcPlacemark = MKPlacemark(coordinate: points[0], addressDictionary: nil)
                            let descPlacemark = MKPlacemark(coordinate: points[1], addressDictionary: nil)
                            
                            let srcMapItem = MKMapItem(placemark: srcPlacemark)
                            let descMapItem = MKMapItem(placemark: descPlacemark)
                            
                            let directionRequest = MKDirectionsRequest()
                            directionRequest.source = srcMapItem
                            directionRequest.destination = descMapItem
                            directionRequest.transportType = .automobile
                            
                            let directions = MKDirections(request: directionRequest)
                            
                            directions.calculate{
                                (response, error) -> Void in
                                
                                guard let response = response else {
                                    if let error = error {
                                        print("Error: \(error)")
                                    }
                                    
                                    return
                                }
                                
                                let route = response.routes[0]
                                self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                                
                                let rect = route.polyline.boundingMapRect
                                self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
                                
                                
                            }
                            
                        }
                    }
                    i+=1
                }
            })
            
        }
        
        }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }
    
    class Annotation: NSObject, MKAnnotation {
        var title: String?
        var lat: Double
        var long:Double
        
        var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
        
        init(latitude: Double, longitude: Double, address: String) {
            self.lat = latitude
            self.long = longitude
            self.title = address
        }
    }

}
