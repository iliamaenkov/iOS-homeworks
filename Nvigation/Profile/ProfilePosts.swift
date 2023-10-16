//
//  ProfilePosts.swift
//  Nvigation
//
//  Created by Ilya Maenkov on 15.10.2023.
//

import UIKit

    // Creating an array of Post objects.

var posts: [Post] = [
    
    Post(
        author: "Jedi Academy",
        description: "С гордостью объявляем, что наша Академия на Явине 4 продолжает формировать новое поколение джедаев. Ученики изучают силу и ее использование, и они будут нашими надежными стражами в этом непредсказуемом мире. Да пребудет с ними Сила.",
        image: "Post_4",
        likes: 557, 
        views: 4560
    ),
    
    Post(author: "Unknown",
         description: "Последние решения принятые Канцлером Палпатином, оставляют желать лучшего, хочется верить, что он по прежнему выступает за мир, но его влияние распространилось слишком широко и добралось даже до совета джедаев...",
         image: "Post_3",
         likes: 7,
         views: 6774
        ),
    
    Post(author: "Obi-Van Kenobi",
         description: "Больше миллиона клонов на подходе 🔥💪🏼💪🏼. Планета Камино.",
         image: "Post_1",
         likes: 2000,
         views: 10700
        ),
    
    Post(author: "Corusant Daily Post",
         description: "Битва при Корусанте закончилась аварийной посадкой крейсера Республики, о жертвах среди гражданских не сообщается, совет джедаев пока не сделал официального заявления...",
         image: "Post_2", likes: 1000,
         views: 38954
        ),
    
    Post(author: "Chewbacca",
         description: "Uuuuuuuuur Alihlilm Uhmr AlilihhmiiT Aaaarhg...",
         image: nil,
         likes: 9079,
         views: 153457
        )
    
]
