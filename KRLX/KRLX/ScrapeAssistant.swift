//
//  ScrapeAssistant.swift
//  KRLX
//
//  Created by Phuong Dinh and Josie Bealle on 22/05/2015.
//  Copyright (c) 2015 KRLXpert. All rights reserved.
//

class ScrapeAssistant {    
    init(){
        
    }
    
    //does scraping for an article content
    func scrapeArticle(url: String) -> String {
        let myURLString = url
        var article_content = String()
        if let myURL = NSURL(string: myURLString) {
            var error: NSError?
            let myHTMLString = String(contentsOfURL: myURL, encoding: NSUTF8StringEncoding, error: &error)
            if let error = error {
                println("Error : \(error)")
            } else {
                let html = myHTMLString
                var err : NSError?
                var parser = HTMLParser(html: html!, error: &err)
                if err != nil {
                    exit(1)
                }
                var allArticle = parser.body
                if let inputAllArticleNodes = allArticle?.xpath("//div[@class='gk-article']") {
                    for node in inputAllArticleNodes {
                        article_content = node.rawContents
                        
                    }
                }
                else {
                    //println("Error: \(myURLString) doesn't seem to be a valid URL")
                }
            }
        }
        return String(article_content)
    }
    
    // does scraping for article title, date, author
    func scrapeArticleInfo() -> [ArticleHeader] {
        var articles = [ArticleHeader]()
        let myURLString = "http://www.krlx.org/"
        if let myURL = NSURL(string: myURLString) {
            var error: NSError?
            let myHTMLString = String(contentsOfURL: myURL, encoding: NSUTF8StringEncoding, error: &error)
            if let error = error {
                println("Error : \(error)")
            } else {
                let html = myHTMLString
                var err : NSError?
                var parser = HTMLParser(html: html!, error: &err)
                if err != nil {
                    println(err)
                    exit(1)
                }
                
                var allArticle = parser.body
                if let inputAllArticleNodes = allArticle?.xpath("//div[@class='items-leading']/div[@class='items-leading'] | //div[@class='items-leading']/div[@class='leading-0']") {
                    for node in inputAllArticleNodes {
                        var bodyHTML = node.rawContents
                        var parser = HTMLParser(html: bodyHTML, error: &err)
                        var bodyNode   = parser.body
                        var author = String()
                        var article_url = String()
                        var article_header = String()
                        var datetime = String()
                        
                        
                        //Get link and title of the article
                        if let inputNodes = bodyNode?.xpath("//h2[@class='article-header']") {
                            for node in inputNodes {
                                var eachArticle = node.rawContents
                                var parserArticle = HTMLParser(html: eachArticle, error: &err)
                                var articleBody   = parserArticle.body
                                if let inputArticle = articleBody?.findChildTags("a") {
                                    for node in inputArticle {
                                        article_header = node.contents
                                        article_url = node.getAttributeNamed("href")
                                        article_url = "http://krlx.org/"+article_url
                                        
                                    }
                                }
                            }
                        }
                        
                        //Get author
                        if let inputNodes = bodyNode?.xpath("//dl[@class='article-info']/dd") {
                            for node in inputNodes {
                                author = node.contents
                                
                            }
                        }
                        
                        if let inputNodes = bodyNode?.xpath("//aside/time") {
                            for node in inputNodes {
                                datetime = node.getAttributeNamed("datetime")
                                
                            }
                        }
                        var article = ArticleHeader(authorString: author, titleString: article_header, dateString: datetime, urlString: article_url)
                        if !(sharedData.loadedArticleHeaders.containsObject(article)) {
                            articles.append(article)
                        }
                        
                    }
    
                    

                }
            }
        } else {
            println("Error: \(myURLString) doesn't seem to be a valid URL")
        }
        return articles
    }

    
    

}
