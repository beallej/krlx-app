//
//  PlayPause.swift
//  KRLX
//
//  Created by Josie Bealle on 07/06/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

protocol PlayPause {
    //var rightBarButtonItem: UIBarButtonItem! { get set }
    var buttonPlay: UIButton  { get set }
    var buttonPause: UIButton  { get set }
    var navigationItem: UINavigationItem { get }
    func musicButtonClicked(sender: AnyObject)
}