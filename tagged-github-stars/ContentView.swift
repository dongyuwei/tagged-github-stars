import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: StateStore
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if store.token == "" {
                    UserInfoView()
                } else {
                    VStack {
                        BasicUserInfoView()
                        List {
                            ForEach(store.stars) { starRepo in
                                NavigationLink(destination: StarRepoDetailView(starRepo: starRepo)) {
                                    StarRepoItemView(starRepo: starRepo)
                                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            }
                        }.frame(width: 300)
                    }
                }
            }.padding(10)
        }.frame(idealWidth: 1200, maxWidth: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
