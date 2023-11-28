//
//  Post.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 02.10.2023.
//

import Foundation

//MARK: - Post

public struct Post {

    public var author: String
    public var description: String
    public var image: String?
    public var likes: Int
    public var views: Int
    
    public init(
        author: String,
        description: String,
        image: String? = nil,
        likes: Int,
        views: Int
    ) {
        self.author = author
        self.description = description
        self.image = image
        self.likes = likes
        self.views = views
    }
}

//MARK: - Post Title

public struct PostTitle {
    
   public var title: String
    
    public init(title: String) {
        self.title = title
    }
}
