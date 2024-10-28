//
//  RepositoryDetailsView.swift
//  RepositoryStatistics
//
//  Created by Veronica Gliga on 22.10.2024.
//

import SwiftUI
import Charts

struct RepositoryDetailsView: View {
    let repository: Repository
    @StateObject private var viewModel = RepositoryDetailViewModel(githubService: GithubServiceIssues(networkProvider: NetworkingService(baseURL: URL(string: "https://api.github.com")!)))
    
    @State private var selectedDataPoint: GroupedIssue? = nil
    @State private var yScale: CGFloat = 1.0
    @State private var dateScale: CGFloat = 1.0
    @State private var offset: CGFloat = 0.0
    @State private var showDataPointInfo = false
    
    @State private var showSelectionBar = false
    @State private var offsetX = 0.0
    @State private var offsetY = 0.0
    
    var body: some View {
        VStack {
            // Display key repository statistics
            VStack(alignment: .leading, spacing: 10) {
                Text("⭐️ Stars: \(viewModel.stargazers.count)")
                Text("🍴 Forks: \(viewModel.forks.count)")
                Text("🐞 Open Issues: \(viewModel.issues.count)")
            }
            .padding()
            
            // Chart for issue history
            if viewModel.openIssues.isEmpty {
                Text("No issues to show")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                Chart(viewModel.openIssues) { issueCount in
                    LineMark(
                        x: .value("Week", issueCount.weekStart),
                        y: .value("Issues", issueCount.count)
                    )
                    .foregroundStyle(.cyan)
                    .interpolationMethod(.catmullRom)
                    .lineStyle(.init(lineWidth: 2))
                    .symbol {
                        Circle()
                            .fill(.cyan)
                            .frame(width: 12, height: 12)
                    }
                }
                .frame(height: 300)
                .padding()
                .chartYScale(domain: 0...(viewModel.openIssues.map { Double($0.count) }.max() ?? 1) * yScale) // Scale Y-axis
                .chartXScale(domain: computeXDomain())
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle()
                            .foregroundStyle(Color.orange.gradient)
                            .frame(width: 2, height: geometry.size.height * 0.95)
                            .opacity(showSelectionBar ? 1.0 : 0.0)
                            .offset(x: offsetX)
                        
                        if let selectedDataPoint {
                            Capsule()
                                .foregroundStyle(.orange.gradient)
                                .frame(width: 100, height: 50)
                                .overlay {
                                    VStack {
                                        Text(selectedDataPoint.formattedWeekStart)
                                            .font(.caption)
                                            .minimumScaleFactor(0.5)
                                        Text("\(selectedDataPoint.count) issues")
                                            .font(.caption)
                                            .minimumScaleFactor(0.5)
                                    }
                                    .foregroundStyle(.white.gradient)
                                    .padding(2)
                                }
                                .opacity(showSelectionBar ? 1.0 : 0.0)
                                .offset(x: offsetX - 50, y: offsetY - 60)
                        }
                        
                        Rectangle()
                            .fill(Color.clear)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        showSelectionBar = true
                                        let location = value.location
                                        
                                        // Convert the location to an X-axis date
                                        if let date: Date = proxy.value(atX: location.x) {
                                            // Find the nearest data point by date
                                            if let nearestPoint = viewModel.openIssues.min(by: { abs($0.weekStart.timeIntervalSince(date)) < abs($1.weekStart.timeIntervalSince(date)) }) {
                                                selectedDataPoint = nearestPoint
                                                
                                                if let position = proxy.position(for: (nearestPoint.weekStart, nearestPoint.count)),
                                                let plotFrame = proxy.plotFrame {
                                                    offsetX = geometry[plotFrame].origin.x + position.x
                                                    offsetY = geometry[plotFrame].origin.y + position.y
                                                }
                                            }
                                        }
                                    }
                                    .onEnded { _ in
                                        showSelectionBar = false
                                    }
                            )
                    }
                }
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            yScale = value.magnitude
                        }
                )
            }
        }
        .navigationTitle(repository.name)
        .task {
            await viewModel.fetchRepositoryIssues(for: repository)
            await viewModel.fetchStargazers(for: repository)
            await viewModel.fetchForks(for: repository)
        }
        .alert(isPresented: .constant(viewModel.errorMessage != nil)) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.errorMessage ?? ""),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    func findIssue(on date: Date) -> GroupedIssue? {
        // Set up the date formatter to ignore the time component
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Format the target date
        let formattedTargetDate = dateFormatter.string(from: date)
        
        // Search for an issue with a matching formatted date
        return viewModel.openIssues.first { issue in
            let formattedWeekStart = dateFormatter.string(from: issue.weekStart)
            return formattedWeekStart == formattedTargetDate
        }
    }
    
    // Compute dynamic X-axis domain based on dateScale
    private func computeXDomain() -> ClosedRange<Date> {
        guard let minDate = viewModel.openIssues.map({ $0.weekStart }).min(),
              let maxDate = viewModel.openIssues.map({ $0.weekStart }).max() else {
            return Date()...Date()
        }
        
        let interval = maxDate.timeIntervalSince(minDate) * Double(dateScale)
        let adjustedMinDate = minDate.addingTimeInterval(-interval / 2)
        let adjustedMaxDate = maxDate.addingTimeInterval(interval / 2)
        
        return adjustedMinDate...adjustedMaxDate
    }
}

#Preview {
    RepositoryDetailsView(repository: Repository(id: 1, name: "Test Name", owner: Owner(id: 1, name: "Test Name"), description: "Test Description", stargazersCount: 2, forksCount: 3, url: ""))
}
