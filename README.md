# RepositoryStatistics

## Features

* Fetch GitHub Repositories: Displays a list of repositories for a selected GitHub user or organization.
* Repository Statistics: Upon selecting a repository, users can view key statistics like stars, forks, watchers, and open issues.
* Issues History Chart: Shows the number of issues over time in weekly intervals, helping visualize the repository's activity and engagement.
* Interactive Chart:
    * **OnDrag Gesture**: Displays detailed information about each point in the chart.
    * **Zoom Feature**: Zoom in/out along the x-axis to focus on specific time frames.
    
## Usage

1. Unzip archive
2. Open RepositoryStatistics.xcodeproj
3. A list of repositories will display
4. Select a repository to view:
    * Key statistics (stars, forks, open issues).
    * An interactive history chart showing weekly intervals of issue counts.
5. Chart Interactions:
    * Drag to see specific data points in detail (showing exact issue count by date).
    * Pinch to Zoom on the x-axis to stretch the timeline and examine specific intervals more closely.

## Technologies Used

* **Swift**: For the main programming language
* **SwfftUI**: To build the UI and manage state.
* **Charts Framework**: Apple framework for displaying charts.

## Further Improvements

**Features**
    * **Make the Chart Scrollable**: Allow users to scroll horizontally through the chart to explore extended data over time without crowding the display.
    * **Date Range Selection**: Add possibility for users to select predefined date ranges or use a date-picker feature to enable users to select a specific date range for visualizing issue history.
    * **Detailed Issue Information**: Extend the chart data and statistics section to include more issue details, such as:
            * Breakdown of open, closed, and in-progress issues.
            * Highlights of significant spikes in issues.
            * Information on the top contributors addressing issues or key contributors for the selected time period.

**Technical**
    * **Dependency Injector for Dependency Management**: Integrate a dependency injection framework (e.g., Swinject) to better manage dependencies.
    * **Use Coordinators for Navigation Management**: Adopt the Coordinator pattern to handle navigation flow across the app
