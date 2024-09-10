library(shiny)
library(leaflet)
library(leaflet.extras)
library(shinydashboard)
library(dplyr)
library(dafishr)
library(ggplot2)
library(aws.s3)

ui <- dashboardPage(
     dashboardHeader(
          title = div(
               style = "width: 100%; 
                    text-align: center; 
                    display: flex; 
                    align-items: center; 
                    justify-content: center;
                    font-size: 45px;
                    font-family: 'GMX', sans-serif;",
               span("Parque Nacional Revillagigedo"),
               tags$img(src = "UK.png", id = "toggle-sidebar", style = "height: 30px; cursor: pointer; position: absolute; left: 10px;")
          ),
          titleWidth = "100%"
     ),
     dashboardSidebar(
          collapsed = TRUE,
          selectInput("language", "", choices = c("English", "Español"), selected = "Español")
     ),
     dashboardBody(
          tags$head(
               tags$style(HTML('
               .skin-blue .main-header .navbar {
          background-color: #235B4E; /* Change this to your desired color */
               }
        .skin-blue .main-header .logo {
          background-color: #235B4E; /* Change this to your desired color */
        }
        .nav-tabs li a {
          font-size: 16px;
          font-weight: bold;
        }
        #backgroundContainer {
          background: url("background2.png") no-repeat center center;
          background-size: cover;
          position: relative;
          height: 500px;
          width: 1700px;
          margin: auto;
          display: flex;
          align-items: center;
          justify-content: center;
        }
        #mapContainer {
          height: 450px;
          width: 600px;
          border-radius: 1px;
        }
        #map {
          height: 100%;
          width: 100%;
          border-radius: 15px;
        }
        .description-container {
          display: flex;
          justify-content: center;
          margin-top: 20px;
        }
        .description-box {
          width: 1400px;
          border: 1px solid #ddd;
          padding: 15px;
          border-radius: 5px;
          background-color: #f9f9f9;
          text-align: justify;
          font-family: "Montserrat", sans-serif;
          font-size: 18px; /* Adjust the size as needed */
        }
        .description-title {
          display: block;
          text-align: center;
          font-size: 24px; /* Adjust the size as needed */
          font-family: "GMX", sans-serif;
        }
      ')),
               tags$script(HTML("
      $(document).ready(function() {
        $('#toggle-sidebar').on('click', function() {
          var sidebar = $('body').toggleClass('sidebar-collapse');
        });
      });
    "))
               ),
          div(style = "display: flex; flex-direction: column; align-items: center;",
              fluidRow(
                   column(5,
                          div(id = "backgroundContainer",
                              div(id = "mapContainer",
                                  checkboxInput("togglePolygons", "Show/Hide Polygons", value = TRUE),
                                  leafletOutput("map", height = "400px")
                              )
                          )
                   )
              )
          ),
          div(style = "margin-top: 20px;"),
          fluidRow(
               column(12,
                      div(id = "acknowledgments",
                          style = "text-align: center; display: flex; justify-content: center;",
                               img(src = "gop_conanp_logos.png", alt = "Logo 1", style = "height:100px; padding: 5px;")
                      )
               )
          ),
          div(class = "description-container",
              div(class = "description-box",
                  uiOutput("description")
              )
          ),
          div(style = "margin-top: 20px;"),
          fluidRow(
               column(12,
                      div(id = "acknowledgments",
                          style = "text-align: center; display: flex; justify-content: center;",
                          img(src = "scripps.png", alt = "Logo 1", style = "height:100px; padding: 5px;"),
                          img(src = "cbmc1.png", alt = "Logo 2", style = "height:100px; padding: 5px;"),
                          img(src = "BNA-logo-full-blue-txt-transparent-300x.png", alt = "Logo 2", style = "height:100px; padding: 5px;")
                      )
               )
          ),
          div(style = "margin-top: 20px;"),
          uiOutput("tabPanels")
     )
)





# Define server logic
server <- function(input, output, session) {
     text <- reactive({
          if (input$language == "English") {
               list(
                    title = "Revillagigedo National Park",
                    description = "<p style='text-align: justify;'>
  <strong style='display: block; text-align: center; font-size: 20px;'>The Revillagigedo Archipelago:</strong><br>
  It consists of a set of four volcanic islands located in the Pacific Ocean. These islands are recognized for hosting a unique and singular ecosystem. Located approximately 458 kilometers south and southwest of the municipality of Los Cabos, Baja California Sur, and 698 kilometers west of Manzanillo, they are in a remote and distant position. Initially linked to the Mexican state of Colima, they were granted in 1861 to establish a penal colony, but they are currently owned and under federal Mexican jurisdiction.<br><br>
  Decreed in November 2017 as a National Park under the responsibility of the National Commission of Natural Protected Areas of Mexico, it became the largest no-take marine protected area in North America. It has important international designations, which reaffirm the importance of the area:<br>
  <ul>
    <li>1996: Area of importance for bird nesting</li>
    <li>2002: Wetland of international importance, RAMSAR site number: 1357</li>
    <li>2016: UNESCO World Heritage Site</li>
    <li>2021: Blue Park</li>
  </ul>
  Access to these islands from Los Cabos usually takes between 26 and 30 hours by sea, although there is a small military airstrip on Socorro Island, which is owned by the Secretariat of the Navy, which collaborates in the protection and surveillance of the area.
</p>
",
                    fishing_activity_link = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/vms_revillagigedo_report.html",
                    climate_change_link = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/revillagigedo_report.html",
                    rocky_reefs_link = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/rocky_reefs_monitoring_report.html",
                    expedition_report_link = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/expedition_report_final_ENG.pdf",
                    research_link = "https://docs.google.com/spreadsheets/d/1T5vlpiKDtAICR7UXaZIEtrN_WUWXcNIgTw9yt_fk0Ho/edit?usp=sharing",
                    fishing_activity_tab = "Industrial Fishing Activity",
                    climate_change_tab = "Climate Change",
                    rocky_reefs_tab = "Rocky Reefs",
                    expedition_report_tab = "Expedition Report",
                    research_tab = "Research",
               )
          } else {
               list(
                    title = "El Archipiélago de Revillagigedo",
                    description = "<p style='text-align: justify;'>
  <strong style='display: block; text-align: center; font-size: 20px;'>El Archipiélago de Revillagigedo:</strong><br>
  Constituye un conjunto de cuatro islas volcánicas situadas en el Océano Pacífico. Estas son reconocidas por albergar un 
  ecosistema único y singular. Ubicadas aproximadamente a 458 kilómetros al sur y suroeste del municipio de Los Cabos, Baja 
  California Sur, y a 698 kilómetros al oeste de Manzanillo, se encuentran en una posición remota y distante. Inicialmente 
  vinculadas al estado mexicano de Colima, fueron otorgadas en 1861 para establecer una colonia penal, pero actualmente son 
  propiedad y están bajo jurisdicción federal mexicana.<br><br>
  Decretado en noviembre de 2017 como Parque Nacional a cargo de la Comisión Nacional de Áreas Naturales Protegidas de
  México, se convirtió en el área marina protegida de no pesca más grande de Norteamérica. Contando con importantes
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
    <li>Actividad de Pesca Industrial: visualización y análisis de la actividad pesquera en Revillagigedo, mostrando su distribución espacial y temporal.</li>
    <li>Cambio Climático: datos y estudios sobre los efectos del cambio climático en el archipiélago.</li>
    <li>Arrecifes Rocosos: información sobre la biodiversidad y conservación de los arrecifes rocosos en Revillagigedo.</li>
    <li>Informe de Expedición: resúmenes de expediciones científicas con hallazgos clave y recomendaciones para futuras investigaciones.</li>
    <li>Investigación: acceso a listado de publicaciones, facilitando la colaboración y el intercambio de conocimientos.</li>
  </ul><br>
                  </p>",
                    fishing_activity_link = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/vms_revillagigedo_report_es.html",
                    climate_change_link = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/revillagigedo_report_es.html",
                    rocky_reefs_link = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/rocky_reefs_monitoring_report_es.html",
                    expedition_report_link = "https://datalake-cbmc-revillagigedo.s3.amazonaws.com/revillagigedo_dashboard/Expedicion_revillagigedo_2023_completa_final.pdf",
                    research_link = "https://docs.google.com/spreadsheets/d/1hHpilcl1OB417mQp5hLs-qkWeIiq6b5aj-jMS4ZzM7Y/edit?usp=sharing",
                    fishing_activity_tab = "Actividad de Pesca Industrial",
                    climate_change_tab = "Cambio Climático",
                    rocky_reefs_tab = "Monitoreo Ecológico",
                    expedition_report_tab = "Informe de Expedición",
                    research_tab = "Investigación"
               )
          }
     })
     
     output$description <- renderUI({
          HTML(text()$description)
     })
     
     output$fishing_activity <- renderUI({
          tags$iframe(
               src = text()$fishing_activity_link,
               style = "width: 100%; height: 1200px; border: none;"
          )
     })
     
     output$climate_change <- renderUI({
          tags$iframe(
               src = text()$climate_change_link,
               style = "width: 100%; height: 1200px; border: none;"
          )
     })
     
     output$rocky_reefs <- renderUI({
          tags$iframe(
               src = text()$rocky_reefs_link,
               style = "width: 100%; height: 1200px; border: none;"
          )
     })
     
     output$expedition_report <- renderUI({
          tags$iframe(
               src = text()$expedition_report_link,
               style = "width: 100%; height: 1200px; border: none;"
          )
     })
     
     output$research <- renderUI({
          tags$iframe(
               src = text()$research_link,
               style = "width: 100%; height: 1200px; border: none;"
          )
     })
   
     
     output$tabPanels <- renderUI({
          tabsetPanel(id = "tabs",
                      tabPanel(text()$fishing_activity_tab, 
                               fluidRow(
                                    column(12,
                                           uiOutput("fishing_activity")
                                    )
                               ),
                               value = "FishTab"
                      ),
                      tabPanel(text()$climate_change_tab, 
                               fluidRow(
                                    column(12,
                                           uiOutput("climate_change")
                                    )
                               ),
                               value = "ClimTab"
                      ),
                      tabPanel(text()$rocky_reefs_tab, 
                               fluidRow(
                                    column(12,
                                           uiOutput("rocky_reefs")
                                    )
                               ),
                               value = "Monit"
                      ),
                      tabPanel(text()$expedition_report_tab, 
                               fluidRow(
                                    column(12,
                                           uiOutput("expedition_report")
                                    )
                               ),
                               value = "ExpRep"
                      ),
                      tabPanel(text()$research_tab, 
                               fluidRow(
                                    column(12,
                                           uiOutput("research")
                                    )
                               ),
                               value = "Research"
                      )
          )
     })
     
     output$map <- renderLeaflet({
          leaflet() %>% 
               addProviderTiles(providers$Esri.NatGeoWorldMap, group = "Basemap") %>% 
               addProviderTiles(providers$Esri.WorldImagery, group = "Sat") %>% 
               
               addLayersControl(
                    baseGroups = c("Basemap", "Sat"),
                    options = layersControlOptions(collapsed = FALSE)
               ) %>%
               setView(lng = -113, lat = 18.8, zoom = 5)
     })
     
     observe({
          if(input$togglePolygons) {
               leafletProxy("map") %>%
                    clearShapes() %>%
                    addPolygons(data = all_mpas,
                                color = "white",
                                fillColor = "#532543",
                                fillOpacity = 0.3,
                                weight = 2,
                                popup = ~paste(NOMBRE)
                    )
          } else {
               leafletProxy("map") %>%
                    clearShapes()
          }
     })
}

shinyApp(ui = ui, server = server)
