import Combine
import SwiftUI

struct MainView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var player: PlayerPublisher
    @State private var showMenu: Bool = false
    @State private var menuOffsetX = CGFloat(0.0)

    func getMenuCloseGesture(_ offsetClose: CGFloat) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let newOffsetX = value.location.x - value.startLocation.x
                if newOffsetX < 0 {
                    self.menuOffsetX = newOffsetX
                }
            }
            .onEnded { value in
                withAnimation {
                    let finalOffsetX = value.location.x - value.startLocation.x
                    if finalOffsetX < -offsetClose {
                        self.showMenu = false
                    }
                    self.menuOffsetX = 0
                }
            }
    }

    var header: some View {
        HStack {
            if router.route.showMenuButton {
                Button(action: {
                    withAnimation {
                        self.showMenu.toggle()
                    }
                }, label: { Image(systemName: "list.bullet") })
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityLabel("Menu")
                    .accessibilityHidden(showMenu)
            }
            Text(router.route.title)
                .font(.title)
                .fontWeight(.black)
            Spacer()
            if router.route.showTraillingButton {
                router.route.traillingButton
            }
            Button(action: {
                withAnimation {
                    player.togglePlayer()
                }
            }, label: {
                Image(systemName: "music.note")
            }).buttonStyle(PlainButtonStyle())
                .accessibilityLabel("Entries player")
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                VStack {
                    if self.router.route.showHeader {
                        self.header.padding(.horizontal).padding(.top, 15)
                            .accessibilityHidden(showMenu)
                    }
                    ErrorView()
                    RouterView()
                        .accessibilityHidden(showMenu)
                }.frame(width: geometry.size.width, height: geometry.size.height)
                    .blur(radius: self.showMenu ? 10 : 0)

                if self.showMenu {
                    Rectangle()
                        .opacity(0.1)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                self.showMenu = false
                            }
                        }
                    MenuView(showMenu: self.$showMenu)
                        .frame(width: geometry.size.width / 1.5)
                        .offset(x: self.menuOffsetX)
                        .transition(.move(edge: .leading))
                        .gesture(self.getMenuCloseGesture(geometry.size.width / 4))
                        .edgesIgnoringSafeArea(.all)
                }
                if player.showPlayer {
                    PlayerView()
                        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topTrailing)
                        .transition(.move(edge: .trailing))
                        .offset(x: 0, y: 60)
                }
            }
        }
    }
}

#if DEBUG
    struct MainView_Previews: PreviewProvider {
        static var previews: some View {
            Text("nothing")
        }
    }
#endif
