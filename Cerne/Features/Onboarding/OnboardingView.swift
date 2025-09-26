//
//  OnboardingView.swift
//  Cerne
//
//  Created by Andrei Rech on 25/09/25.
//

import SwiftUI

struct OnboardingView: View {
    @State var viewModel: OnboardingViewModel
    
    var body: some View {
        ZStack {
            Image(.onboardingBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            LinearGradient(gradient: Gradient(colors: [.white, .blue.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            if viewModel.isCreatingUser {
                UserCreateView(username: $viewModel.username, height: $viewModel.height, onTap: {
                    Task {
                        await viewModel.saveUser()
                    }
                })
                    .frame(height: 612)
                    .glassEffect(in: .rect(cornerRadius: 24))
                    .padding(.horizontal, 14)
            } else {
                TabView(selection: $viewModel.currentPageIndex) {
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
                        .tag(index)
                        .padding(.bottom, 100)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 612)
                .clipShape(RoundedRectangle(cornerRadius: 34))
                .padding(.horizontal, 20)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Pular") {
                            viewModel.finishOnboarding()
                        }
                    }
                }
            }
        }
    }
}
