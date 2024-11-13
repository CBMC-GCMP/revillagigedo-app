# Required Libraries
library(shiny)
library(shinydashboard)
library(leaflet)
library(leaflet.extras)
library(dplyr)
library(dafishr)
library(ggplot2)
library(aws.s3)

# Define UI
ui <- dashboardPage(
     dashboardHeader(
          title = div(
               style = "width: 100%; text-align: center; font-size: 45px; font-family: 'Montserrat', sans-serif; letter-spacing: 2px;",
               span("Parque Nacional Revillagigedo")
          ),
          titleWidth = "100%"
     ),
     dashboardSidebar(
          collapsed = TRUE,
          selectInput("language", "", choices = c("Español", "English"), selected = "Español")  # Placeholder for future language switch
     ),
     dashboardBody(
          tags$head(
               tags$link(rel = "shortcut icon", href = "faviconCON.png"),  # Reference the favicon here
               tags$title("RNP-dashboard"),  # This will set the browser tab title to "RNP"
               tags$style(HTML('
        .skin-blue .main-header .navbar {
            background-color: #235B4E;
            height: 80px;  /* Adjust this to your desired height */
        }
        .skin-blue .main-header .logo {
            background-color: #235B4E;
            height: 80px;  /* Adjust this to match the navbar height */
        }
        .skin-blue .main-header .logo .logo-lg {
            font-size: 40px;  /* You can adjust the font size here */
            line-height: 80px;  /* Adjust line height to center text vertically */
        }
        .nav-tabs li a {
            font-size: 18px;
            font-weight: bold;
            padding: 15px 20px;
        }
        body {
            font-family: "Montserrat", sans-serif;
            background-color: #f4f4f9;
        }
        .landing-container {
            text-align: center;
            margin-top: 20px;
            position: relative;
        }
        .landing-background {
            background-image: url("background2.png");  /* Path to your uploaded image */
            background-size: cover;
            background-position: center;
            width: 100%;
            height: 600px;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7); /* Text shadow for better readability */
        }
        .description-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .description-box {
            width: 90%;
            max-width: 1200px;
            background-color: rgba(255, 255, 255, 0.9); /* Semi-transparent background */
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin: 20px;
            text-align: justify;
        }
        .description-title {
            font-size: 24px;
            font-weight: bold;
            text-align: center;
        }
        .info-box {
            display: inline-block;
            width: 30%;
            background-color: #f4f4f9;
            border: 2px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            margin: 10px;
            text-align: center;
        }
        .info-box p {
            font-size: 16px;
        }
        #mapContainer {
            height: 400px;
            width: 90%;
            max-width: 1200px;
            margin: 20px auto;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
        }
    ')),
               # Load Google Fonts
               tags$link(href = "https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;600&display=swap", rel = "stylesheet")
          ),
          uiOutput("tabPanels")
     ),
     title = "RNP-dashboard"  # Add this to set the browser tab title to "RNP"
)

# Define Server Logic
server <- function(input, output, session) {
     # Define the reactive content for the Spanish text and links
     text <- reactive({
          list(
               fishing_activity_link = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/vms_revillagigedo_report_es.html",
               climate_change_link = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/revillagigedo_report_es.html",
               bio_mon_link = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/rocky_reefs_monitoring_report_es.html",
               expedition_report_link = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/Expedicion_revillagigedo_2023_completa_final.pdf",
               research_link = "https://docs.google.com/spreadsheets/d/1hHpilcl1OB417mQp5hLs-qkWeIiq6b5aj-jMS4ZzM7Y/edit?usp=sharing"
          )
     })
     
     # Landing Page Content
     output$tabPanels <- renderUI({
          tabsetPanel(id = "tabs",
                      tabPanel("Inicio",  # Landing Page
                               fluidRow(
                                    column(12,
                                           div(class = "landing-background",
                                               h1("Bienvenidos al Parque Nacional Revillagigedo", style = "font-size: 50px;")
                                           )
                                    )
                               ),
                               div(style = "margin-top: 20px;"),
                               fluidRow(
                                    column(12,
                                           div(id = "acknowledgments",
                                               style = "text-align: center; display: flex; justify-content: center;",
                                               img(src = "government_logos.jpg", alt = "Logo 1", style = "height:100px; padding: 5px;")
                                           )
                                    )
                               ),
                               fluidRow(
                                    column(12,
                                           div(class = "landing-container",
                                               div(class = "description-container",
                                                   div(class = "description-box",
                                                       HTML("<p style='text-align: justify;'>
  <strong style='display: block; text-align: center; font-size: 30px;'>El Archipiélago de Revillagigedo:</strong><br>
  Constituye un conjunto de cuatro islas volcánicas situadas en el Océano Pacífico. Estas son reconocidas por albergar un 
  ecosistema único y singular. Ubicadas aproximadamente a 458 kilómetros al suroeste del municipio de Los Cabos, Baja 
  California Sur, y a 698 kilómetros al oeste de Manzanillo, se encuentran en una posición remota y distante. Inicialmente 
  vinculadas al estado mexicano de Colima, fueron otorgadas en 1861 para establecer una colonia penal, pero actualmente son 
  propiedad y están bajo jurisdicción federal mexicana.<br><br>
  Decretado en noviembre de 2017 como Parque Nacional a cargo de la Comisión Nacional de Áreas Naturales Protegidas de
  México (CONANP), se convirtió en el área marina protegida de no pesca más grande de Norteamérica. Contando con importantes
  designaciones internacionales, las cuales reafirman la importancia del área:<br>
  <ul>
    <li>1996: Área de importancia para la anidación de Aves</li>
    <li>2002: Humedal de importancia internacional, sitio RAMSAR número: 1357</li>
    <li>2016: Patrimonio de la Humanidad por la UNESCO</li>
    <li>2021: Blue Park</li>
  </ul>
  El acceso a estas islas desde Los Cabos suele llevar entre 26 y 30 horas por vía marítima, aunque existe una pequeña pista de aterrizaje militar en la Isla Socorro, 
  la cual es propiedad de la Secretaría de Marina, la cual colabora en el resguardo y vigilancia del área.<br><br>
  <strong style='display: block; text-align: center; font-size: 20px;'>Importancia de la Colaboración en la Plataforma de Investigación del Parque Nacional Revillagigedo</strong><br>
La plataforma de investigación del Parque Nacional Revillagigedo es esencial para integrar y coordinar los esfuerzos científicos y de conservación. 
Esta herramienta permite a los investigadores acceder a datos actualizados, 
compartir hallazgos y colaborar eficientemente. 
Al centralizar la información, se facilita el análisis de los impactos ambientales y 
se mejora la toma de decisiones para la protección del archipiélago.<br><br>
Descripción de las pestañas en el dashboard<br>

<ul>
    <li>Monitoreo Embarcaciónes: visualización y análisis de la actividad de embarcaciones de pesca en Revillagigedo, mostrando su distribución espacial y temporal.</li>
    <li>Cambio Climático: datos y estudios sobre los efectos del cambio climático en el archipiélago.</li>
    <li>Monitoreo Biológico: información sobre el monitoreo biológico en el Parque Nacional.</li>
    <li>Informe de Expedición: resúmenes de expediciones científicas con hallazgos clave y recomendaciones para futuras investigaciones.</li>
    <li>Investigación: acceso a listado de publicaciones, facilitando la colaboración y el intercambio de conocimientos.</li>
  </ul><br>
                  </p>")
                                                   )
                                               ),
                                               
                                               # Interactive Map Section
                                               div(id = "mapContainer",
                                                   leafletOutput("map", height = "100%")
                                               ),
                                               div(style = "margin-top: 20px;"),
                                               fluidRow(
                                                    column(12,
                                                           div(id = "acknowledgments",
                                                               style = "text-align: center; display: flex; justify-content: center;",
                                                               img(src = "logoPNR.png", alt = "Logo 1", style = "height:100px; padding: 5px;"),
                                                               img(src = "UCSD-SIO_Hrizontal-Color_RGB.png", alt = "Logo 1", style = "height:100px; padding: 5px;"),
                                                               img(src = "cbmc.png", alt = "Logo 2", style = "height:80px; padding: 5px;"),
                                                               img(src = "BNA-logo-full-blue-txt-transparent-300x.png", alt = "Logo 2", style = "height:100px; padding: 5px;"),
                                                               img(src = "betadiversidad.png", alt = "Logo 2", style = "height:100px; padding: 5px;")
                                                           )
                                                    )
                                               )
                                           )
                                    )
                               )
                      ),
                      # Fishing Activity Tab
                      tabPanel("Monitoreo Embarcaciónes", uiOutput("fishing_activity")),
                      # Climate Change Tab
                      tabPanel("Cambio Climático", uiOutput("climate_change")),
                      # Rocky Reefs Tab
                      tabPanel("Monitoreo Biológico", 
                               fluidRow(
                                    column(12,
                                           div(style = "background-image: url('link_to_background_image.jpg'); background-size: cover; background-position: center; padding: 20px; border-radius: 10px;",
                                               
                                           div(class = "landing-container",
                                               div(class = "description-container",
                                                   div(class = "description-box",
                                                       # Add CSS for background image
                                                       style = "background-image: url('background_green.png'); background-size: cover; background-position: center; padding: 20px;",
                                                       
                                                       # Center and style the title
                                                       h3("Informes de Monitoreo Biológico", style = "text-align: center; color: black;"),
                                                       div(class = "row",
                                                           div(class = "col-md-4",
                                                               div(style = "background-color: #ff9999; color: black; padding: 20px; margin: 10px; border-radius: 10px;",
                                                                   tags$a(href = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/rocky_reefs_monitoring_report_es.html", target = "_blank", "Arrecifes rocosos", style = "color: black;")
                                                               )
                                                           ),
                                                           div(class = "col-md-4",
                                                               div(style = "background-color: #99ccff; color: black; padding: 20px; margin: 10px; border-radius: 10px;",
                                                                   tags$a(href = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/Informe_Tortugas_PNR_2022.pdf", target = "_blank", "Tortugas Marinas", style = "color: black;")
                                                               )
                                                           ),
                                                           div(class = "col-md-4",
                                                               div(style = "background-color: #99ff99; color: black; padding: 20px; margin: 10px; border-radius: 10px;",
                                                                   tags$a(href = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/mamiferos_marinos.pdf", target = "_blank", "Mamiferos Marinos", style = "color: black;")
                                                               )
                                                           )
                                                       )
                                                   )
                                               )
                                           )
                                    )
                               )
                      )
                      ),
                      # Expedition Report Tab
                      tabPanel("Informe de Expedición", 
                               fluidRow(
                                    column(12,
                                           div(style = "background-image: url('link_to_background_image.jpg'); background-size: cover; background-position: center; padding: 20px; border-radius: 10px;",
                                               
                                               div(class = "landing-container",
                                                   div(class = "description-container",
                                                       div(class = "description-box",
                                                           
                                                           # Add CSS for background image
                                                           style = "background-image: url('background.png'); background-size: cover; background-position: center; padding: 20px;",
                                                           
                                                           # Center and style the title
                                                           div(class = "row",
                                                               div(class = "col-md-4",
                                                                   div(style = "background-color: #009da6; color: black; padding: 20px; margin: 10px; border-radius: 10px; text-align: center; display: flex; justify-content: center; align-items: center; height: 150px;", # Added height to control box size and centering
                                                                       tags$a(href = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/Expedicion_revillagigedo_2023_completa_final.pdf", target = "_blank", "2023", style = "color: black; font-size: 20px;")
                                                                   )
                                                               )
                                                           )
                                                       )
                                                   )
                                               )
                                           )
                                    )
                               )
                      )
                      ,
                      # Research Tab
                      tabPanel("Investigación", uiOutput("research"))
          )
     })
     
     # Fishing Activity report
     output$fishing_activity <- renderUI({
          tags$iframe(src = text()$fishing_activity_link, style = "width: 100%; height: 100vh; border: none;")
     })
     
     # Climate Change report
     output$climate_change <- renderUI({
          tags$iframe(src = text()$climate_change_link, style = "width: 100%; height: 100vh; border: none;")
     })
     
     # Rocky Reefs report
     output$bio_mon <- renderUI({
          tags$iframe(src = text()$bio_mon_link, style = "width: 100%; height: 100vh; border: none;")
     })
     
     # Expedition Report
     output$expedition_report <- renderUI({
          tags$iframe(src = text()$expedition_report_link, style = "width: 100%; height: 100vh; border: none;")
     })
     
     # Research
     output$research <- renderUI({
          tags$iframe(src = text()$research_link, style = "width: 100%; height: 100vh; border: none;")
     })
     
     # Render the interactive map with dafishr::all_mpas shapefiles
     output$map <- renderLeaflet({
          leaflet() %>%
               addProviderTiles(providers$Esri.NatGeoWorldMap, group = "Basemap") %>%
               addProviderTiles(providers$Esri.WorldImagery, group = "Sat") %>%
               setView(lng = -113, lat = 18.8, zoom = 6) %>%  # Set initial view for Revillagigedo Archipelago
               addPolygons(data = dafishr::all_mpas,
                           color = "white",
                           fillColor = "#532543",
                           fillOpacity = 0.4,
                           weight = 2,
                           popup = ~paste(NOMBRE)) %>%
               addLayersControl(
                    baseGroups = c("Basemap", "Sat"),
                    options = layersControlOptions(collapsed = FALSE)
               )
     })
}

# Run the Application
shinyApp(ui = ui, server = server)