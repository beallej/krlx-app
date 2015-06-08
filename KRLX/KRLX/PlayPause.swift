//
//  PlayPause.swift
//  KRLX
//
//  Created by Josie Bealle on 07/06/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//


/*This allows us to not have duplicate code in controlling play/pause via a button on the
navigation bar.*/
protocol PlayPause {
    
    var buttonPlay: UIButton  { get set }
    var buttonPause: UIButton  { get set }
    var navigationItem: UINavigationItem { get }
    func musicButtonClicked(sender: AnyObject)
}