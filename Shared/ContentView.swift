//
//  ContentView.swift
//  Shared
//
//  Created by Sergio Deleon on 9/9/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Model : Identifiable {

    var id: Int
    var offset : CGFloat
    var color: Color
}

let cardSpace:CGFloat = 10

struct Home : View {

    var width = UIScreen.main.bounds.width - (40 + 60)
    var height = UIScreen.main.bounds.height / 2

    @State var books = [
        // Make Sure id is in ascending Order....

        Model(id: 0, offset: 0, color: Color.blue),
        Model(id: 1, offset: 0, color: Color.red),
        Model(id: 2, offset: 0, color: Color.purple),
        Model(id: 3, offset: 0, color: Color.yellow),
        Model(id: 4, offset: 0, color: Color.orange),
        Model(id: 5, offset: 0, color: Color.pink),
    ]

    @State var swiped = 0

    var body: some View{

        VStack{

            Spacer(minLength: 0)

            ZStack{

                // Since its zstack it overlay one on another so reversed....

                ForEach(books.reversed()){book in

                    HStack{
                        Spacer(minLength: 0)
                        ZStack{
                            Rectangle()
                                .foregroundColor(book.color)
                                .ignoresSafeArea()
                                .frame(width: width, height: getHeight(index: book.id))
                                .cornerRadius(25)
                                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5)
                        }
                        .offset(y: (cardSpace * CGFloat(book.id)))
                        .rotationEffect(
                            // You can play with the degrees to change angles of cards
                            (book.id % 2 == 0) ? .degrees(-0.2 * Double(arc4random_uniform(20)+1) ) : .degrees(0.2 * Double(arc4random_uniform(15)+1) )
                        )
                        Spacer(minLength: 0)
                    }
                    // Content Shape For Drag Gesture...
                    .contentShape(Rectangle())
                    .padding(.horizontal,20)
                    // Gesture...
                    .offset(x: book.offset)
                    .gesture(DragGesture().onChanged({ (value) in
                        withAnimation{onScroll(value: value.translation.width, index: book.id)}
                    }).onEnded({ (value) in
                        withAnimation{onEnd(value: value.translation.width, index: book.id)}
                    }))
                }
            }
            // Max height...
            .frame(height: height)
            Spacer(minLength: 0)
        }
    }

    // Dynamic height Change...

    func getHeight(index : Int)->CGFloat{

        return height - (index - swiped < 3 ? CGFloat(index - swiped) * 40 : 80)
    }

    func onScroll(value: CGFloat,index: Int){

        if value < 0{

            // Left Swipe...

            if index != books.last!.id{

                books[index].offset = value
            }
        }
        else{

            // Right Swipe....

            // Safe Check...
            if index > 0{

                if books[index - 1].offset <= 20{

                    books[index - 1].offset = -(width + 40) + value
                }
            }
        }
    }

    func onEnd(value: CGFloat,index: Int){

        if value < 0{

            if -value > width / 2 && index != books.last!.id{

                books[index].offset = -(width + 100)
                swiped += 1
            }
            else{

                books[index].offset = 0
            }
        }
        else{

            if index > 0{

                if value > width / 2{

                    books[index - 1].offset = 0
                    swiped -= 1
                }
                else{

                    books[index - 1].offset = -(width + 100)
                }
            }
        }
    }
}

