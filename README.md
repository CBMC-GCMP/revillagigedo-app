# Parque Nacional Revillagigedo Dashboard README

## Overview
This Shiny application is designed to provide a comprehensive overview of the Parque Nacional Revillagigedo. The app presents a variety of reports and visualizations related to fishing activity, climate change, rocky reefs, expedition summaries, and research efforts within the park. It also features an interactive map displaying the marine protected areas (MPAs) around Revillagigedo.

## Features
1. **Landing Page**: Presents a detailed description of the park's significance, history, and conservation efforts. 
2. **Interactive Map**: Displays MPAs with shapefiles from the `dafishr` package.
3. **Reports**:
   - **Monitoreo de Embarcaciónes**: Fishing activity monitoring report.
   - **Cambio Climático**: Climate change impact report.
   - **Arrecifes Rocosos**: Rocky reefs monitoring report.
   - **Informe de Expedición**: Detailed expedition report.
   - **Investigación**: Access to ongoing research and publications.

## Installation
1. Clone the repository or download the files.
2. Make sure you have the required libraries installed (see below).
3. Run the Shiny app with `shinyApp(ui = ui, server = server)` in your R environment.

## Required Libraries
```r
library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras)
library(dplyr)
library(dafishr)
library(ggplot2)
library(aws.s3)
```


## File Structure
- UI Components: The UI defines the layout of the dashboard, including a header, sidebar, and multiple tabbed panels. Each tab is linked to a different report or visual component.
- Server Logic: The server-side script dynamically renders content for each tab based on user interaction. It pulls data from external sources and integrates shapefiles for MPAs.

## How to Run
- Ensure all dependencies are installed.
- Upload any necessary files such as images (background2.png, gop_conanp_logos.png, etc.) to the appropriate directories.
- Launch the app by executing the following command in your R console:

```r
shinyApp(ui = ui, server = server)
```

## Map Component
The interactive map displays the marine protected areas using the shapefiles provided by the dafishr package. Users can switch between different map layers (Basemap and Satellite view).

## Custom Styling
The app uses custom CSS to style the header, sidebar, and body. Google Fonts are included to enhance the typography, specifically using the 'Montserrat' font family.

## Reports and External Links
The application displays multiple reports hosted externally using the aws.s3 package to pull in documents and visualizations from S3 storage. These include:

- Fishing Activity Report (Monitoreo de Embarcaciónes)
- Climate Change Report (Cambio Climático)
- Rocky Reefs Report (Arrecifes Rocosos)
- Expedition Report (Informe de Expedición)
- Research Publications (Investigación)
- Future Features
- Language switch functionality is planned, allowing users to toggle between English and Spanish interfaces.

## License

This project is under the MIT License.

Feel free to modify and extend the app based on your project requirements!

