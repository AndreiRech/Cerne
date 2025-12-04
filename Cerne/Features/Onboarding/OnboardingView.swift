import SwiftUI

struct OnboardingView: View {
    @State var viewModel: OnboardingViewModel
    @Binding var isOnbDone: Bool
    
    var body: some View {
        ZStack {
            Image(.onboardingBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            LinearGradient(gradient: Gradient(colors: [.white, .blue.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            if viewModel.isCreatingUser {
                GeometryReader { geometry in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            Spacer()
                            
                            UserCreateView(
                                username: $viewModel.username,
                                height: $viewModel.height,
                                usernameError: $viewModel.usernameError,
                                heightError: $viewModel.heightError,
                                heightErrorMessage: $viewModel.heightErrorMessage,
                                onTap: {
                                    Task {
                                        await viewModel.validateAndSaveUser()
                                    }
                                    isOnbDone = true
                                }
                            )
                            .glassEffect(in: .rect(cornerRadius: 24))
                            .padding(.horizontal, 14)
                            .padding(.bottom, 20)
                            
                            Spacer()
                        }
                        .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                }
            } else {
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(viewModel.onboardingPages.indices, id: \.self) { index in
                                let page = viewModel.onboardingPages[index]
                                OnboardingComponent(
                                    image: page.image,
                                    title: page.title,
                                    description: page.description,
                                    isLastPage: index == viewModel.onboardingPages.count - 1,
                                    onTap: {
                                        viewModel.finishOnboarding()
                                    }
                                )
                                .containerRelativeFrame(.horizontal)
                                .id(index)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $viewModel.currentPageIndex)
                    
                    HStack(spacing: 8) {
                        ForEach(viewModel.onboardingPages.indices, id: \.self) { index in
                            Capsule()
                                .fill(index == viewModel.currentPageIndex ? .primitivePrimary : Color.gray.opacity(0.5))
                                .frame(width: index == viewModel.currentPageIndex ? 24 : 8, height: 8)
                        }
                    }
                    .animation(.easeInOut, value: viewModel.currentPageIndex)
                    .padding(.bottom, 40)
                }
                .frame(height: 620)
                .clipShape(RoundedRectangle(cornerRadius: 34))
                .padding(.horizontal, 20)
            }
        }
        .animation(.easeInOut, value: viewModel.isCreatingUser)
        .onChange(of: viewModel.isOnboardingFinished) {
            if viewModel.isOnboardingFinished {
                withAnimation {
                    isOnbDone = true
                }
            }
        }
    }
}

//#Preview {
//    OnboardingView(viewModel: OnboardingViewModel(userDefaultService: UserDefaultService(), userService: UserService()))
//}
