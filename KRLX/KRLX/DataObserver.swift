//
//  DataObserver.swift
//  KRLX
//
//  Created by Josie Bealle on 28/05/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//


/*This allows us to tell a viewcontroller that it should either update it's data,
and/or update its view with the new data*/

protocol DataObserver{
    func notify()
    func updateView()
}