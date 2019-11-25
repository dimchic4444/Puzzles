//
//  NetworkService.swift
//  Puzzles
//
//  Created by Leonid Serebryanyy on 18.11.2019.
//  Copyright © 2019 Leonid Serebryanyy. All rights reserved.
//

import Foundation
import UIKit


class NetworkService {
	
	let session: URLSession
	
	private var queue = DispatchQueue(label: "com.sber.puzzless", qos: .default, attributes: .concurrent)

	
	init() {
		session = URLSession(configuration: .default)
	}
	
	
	// MARK:- Первое задание
	
	///  Вот здесь должны загружаться 4 картинки и совмещаться в одну.
	///  Для выполнения этой задачи вам можно изменять только этот метод.
	///  Метод, соединяющий картинки в одну, уже написан (вызывается в конце).
	///  Ответ передайте в completion.
	///  Помните, что надо сделать так, чтобы метод работал как можно быстрее.
	public func loadPuzzle(completion: @escaping (Result<UIImage, Error>) -> ()) {
		// это адреса картинок. они работающие, всё ок!
		let firstURL = URL(string: "https://i.imgur.com/JnY1dY7.jpg")!
		let secondURL = URL(string: "https://i.imgur.com/S93pvex.jpg")!
		let thirdURL = URL(string: "https://i.imgur.com/pvCHGsL.jpg")!
		let fourthURL = URL(string: "https://i.imgur.com/DgijrVE.jpg")!
		let urls = [firstURL, secondURL, thirdURL, fourthURL]
        
        
        
		// в этот массив запишите итоговые картинки
			var results = [UIImage]()
		

//        let session = URLSession.shared
        let myGroup = DispatchGroup()
            for ImageUrl in urls {
                myGroup.enter()
//                let task = session.dataTask(with: ImageUrl, completionHandler: { (data, response, error) in
                if let data = try? Data(contentsOf: ImageUrl) {
                    if let imageData = UIImage(data: data) {
                        results.append(imageData)
                        print("Image was download")
                    }
//                })
//                task.resume()
                }
                myGroup.leave()
            }
        myGroup.notify(queue: DispatchQueue.main) {
            DispatchQueue.main.async {
                if let merged = ImagesServices.image(byCombining: results) {
                    completion(.success(merged))
                    print("Images was merged")
                }
            }
        }
        
        
           
        
        
//        ImagesServices.image(byCombining: results)
		
	
        
	}
	
	
	// MARK:- Второе задание
	
	
	///  Здесь задание такое:
	///  У вас есть ключ keyURL, по которому спрятан клад.
	///  Верните картинку с этим кладом в completion
    public func loadQuiz(completion: @escaping(Result<UIImage, Error>) -> ()) {
        let keyURL = URL(string: "https://sberschool-c264c.firebaseio.com/enigma.json?avvrdd_token=AIzaSyDqbtGbRFETl2NjHgdxeOGj6UyS3bDiO-Y")!
        var results = [UIImage]()
        let myGroup = DispatchGroup()
        myGroup.enter()
        if let urlData = try? Data(contentsOf: keyURL) {

            if let str = String(data: urlData, encoding: .utf8) {
                let urlStr = str.replacingOccurrences(of: "\"", with: "")
                let imgUrl = URL(string: urlStr)
                if let data = try? Data(contentsOf: imgUrl!) {
                    if let imageData = UIImage(data: data) {
                        results.append(imageData)
                    }
                }

            }
            myGroup.leave()
            myGroup.notify(queue: DispatchQueue.main) {
                DispatchQueue.main.async {
                    completion(.success(results[0]))
                }
            }
            
        }
		// Вам придёт строка, её надо прочитать с помощью JSONDecoder (ну как мы всегда читали с файрбэйза)
		

    }

}
