#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

tagList(dashboardPage(
    
    dashboardHeader(title = "Indicadores ODS", titleWidth = 250,
                    tags$li(a(href = 'https://www.yvera.tur.ar/sinta/',
                              img(src = 'https://tableros.yvera.tur.ar/recursos/logo_sinta.png',
                                  height = "30px"),
                              style = "padding-top:10px; padding-bottom:10px;"),
                            class = "dropdown")),
    
    dashboardSidebar(
        sidebarMenu(
            menuItem(tabName = "summary", "Resumen"),
            menuItem(tabName = "series", "Series"),
            menuItem(tabName = "metodologia", "Metodología"))
        ),
    
    dashboardBody(
        useWaiter(),
        #waiter_show_on_load(html = loading_screen, color = "white"),
        useShinyjs(),
        
        tags$head(
            # Include our custom CSS
            includeCSS("styles.css")
        ),
        
        tabItems(
            ####RESUMEN#####
            tabItem(
                tabName = "summary",
                fluidRow(
                    h4(tags$b("Indicadores para el seguimiento de la actividad turística en el marco de los Objetivos de Desarrollo Sostenible (ODS) ")))
                ,
                fluidRow(
                    h4(tags$b("Impacto económico y empleo")))
                ,
                fluidRow(
                    valueBox(tags$p(style = "font-size: 160%;", cst_empleo),
                             tags$p(style = "font-size: 140%;", "Puestos de trabajo en industrias turísticas (2019)"),
                                    icon = icon("", verify_fa = FALSE), width = 4, color = "navy"),
                    valueBox(tags$p(style = "font-size: 160%;", empleo_informal),
                             tags$p(style = "font-size: 140%;", "Tasa de informalidad del empleo turístico (2019)"),
                             icon = icon("", verify_fa = FALSE), width = 4, color = "navy"),
                    valueBox(tags$p(style = "font-size: 160%;", cst_pibdt),
                             tags$p(style = "font-size: 140%;", "PIB turístico respecto del PIB total (2019)"), 
                             icon = icon("", verify_fa = FALSE), width = 4, color = "navy")),
                fluidRow(
                    h4( tags$b("Acceso al turismo y desigualdad"))),
                fluidRow(
                    valueBox(tags$p(style = "font-size: 240%;", propension),
                             tags$p(style = "font-size: 110%;", "Propensión a viajar (2022)"), 
                             icon = icon("", verify_fa = FALSE), width = 4, color = "red"),
                    column(width=4,
                           column(width=12,
                                  valueBox(tags$p(style = "font-size: 90%;", gini_viajes),
                                           tags$p(style = "font-size: 120%;", "Índice de Gini de viajes turísticos (2022)"),
                                           icon = icon("", verify_fa = FALSE),width=NULL, color = "aqua"),
                                  valueBox(tags$p(style = "font-size: 90%;", gini_viajes_ocio),
                                      tags$p(style = "font-size: 120%;", "Índice de Gini de viajes turísticos de ocio (2022)"),
                                      icon = icon("", verify_fa = FALSE),width=NULL, color = "aqua"))),
                    valueBox(tags$p(style = "font-size: 90%;", gini_gasto),
                                      tags$p(style = "font-size: 120%;", "Índice de Gini del gasto turístico (2022)"), 
                                      icon = icon("", verify_fa = FALSE), width = 4, color = "aqua")
                             )
                           ),
            ####GRÁFICOS#####
            tabItem(
                tabName = "series",
                
                fluidRow(
                    box(width = 12, tags$p(style = "text-align: center; font-size: 20px;","Series de tiempo de los indicadores ODS"))
                ),
                fluidRow(
                    box(width = 4, status = "primary", solidHeader = TRUE,
                                      title = "Puestos de trabajo en industrias turísticas (millones)", plotlyOutput("graph_cst_empleo", height = 200)),
                    box(width = 4, status = "primary", solidHeader = TRUE,
                                      title = "Tasa de informalidad del empleo turístico (%)", plotlyOutput("informalidad_empleo", height = 200)),
                    box(width = 4, status = "primary", solidHeader = TRUE,
                        title = "PIB directo turístico respecto del PIB total (%)", plotlyOutput("graph_pibdt", height = 200))
                ),
                fluidRow(
                    box(width = 4, status = "primary", solidHeader = TRUE,
                        title = "Propensión a viajar (%)", plotlyOutput("graph_propension", height = 200)),
                    box(width = 8, status = "primary", solidHeader = TRUE,
                        title = "Índices de Gini", plotlyOutput("graph_gini_todos", height = 200)))
                ),
            ####METODOLOGÍA#####
            tabItem(
                tabName = "metodologia",
                fluidRow(width=12,
                tabPanel("Metodología",
                         
                        box(width = NULL,status = "primary", solidHeader = TRUE,
                             br(),
                            tags$b(style ="text-align: center; font-size: 20px;color:#37BBED;",'Definiciones y conceptos'),
                             br(),
                             tags$p(style = "font-size=14px","El tablero presenta un conjunto de indicadores que buscan reflejar el aporte del 
                                turismo a los Objetivos de Desarrollo Sostenible (ODS) para nuestro país. El Documento de Trabajo 
                                N°12: El turismo en los Objetivos de Desarrollo Sostenible aborda esta propuesta y describe en detalle las fuentas utilizadas y los indicadores elaborados"), 
                            tags$b(style = "font-size=14px", style ="text-align: center; font-size: 20px;color:#37BBED;",'Fuentes de información'),
                             br(),
                             tags$p(style = "font-size=14px","Los indicadores que reflejan el aporte del turismo a la economía en su conjunto en términos de actividad 
                                económica y empleo, y la tasa de informalidad de éste, provienen de la ",
                                tags$a(href="https://www.yvera.tur.ar/sinta/informe/info/cuenta-satelite-de-turismo", target = '_blank', "Cuenta Satélite de Turismo de Argentina (CST-A)"), 
                                ", publicada en febrero de 2022. El resto de los indicadores, que buscan medir el acceso al turismo y su nivel de desigualdad,
                                toman como fuente de los datos a la ",tags$a(href="https://www.yvera.tur.ar/sinta/informe/info/encuesta-de-viajes-y-turismo-de-los-hogares-evyth", target = '_blank', "Encuesta de Viajes y Turismo de los Hogares (EVyTH), 
                                                                             representativa de los grandes aglomerados del país.")),
                            tags$b(style ="text-align: center; font-size: 20px;color:#37BBED;",'Indicadores'),
                             br(),
                             tags$p(style = "font-size=14px",tags$ul(tags$p(tags$b(" • Puestos de trabajo en industrias turísticas"),style = "font-size=14px",
                                               ": Surge de la suma de los puestos de trabajo existentes en
                                               los establecimientos pertenecientes a las ramas de actividad clasificadas como características del turismo. 
                                               Incluye puestos de trabajo asalariados (registrados y no registrados) y no asalariados."),
                                        tags$p(style = "font-size=14px",tags$b(style = "font-size=14px"," • Tasa de informalidad en el empleo turístico"),": Proporción de puestos de trabajo asalariados no registrados
                                               con respecto al total de puestos de trabajo asalariados, en porcentaje, para ramas características del turismo."),
                                        tags$p(style = "font-size=14px",tags$b(style = "font-size=14px"," • PIB turístico respecto del PIB total"),": la parte del PIB de la economía total atribuible directamente
                                        al consumo turístico realizado dentro de la Argentina, ya sea por visitantes residentes o no residentes, como porcentaje del PIB total."),
                                        tags$p(style = "font-size=14px",tags$b(style = "font-size=14px"," • Propensión a viajar "),": Proporción de la población que realizó al menos un viaje con pernocte durante el año de referencia."),
                                        tags$p(style = "font-size=14px",tags$b(style = "font-size=14px"," • Índice de Gini de viajes turísticos "),": Medida de desigualdad habitual, aplicada a la cantidad total de viajes turísticos 
                                               realizados según quintil de ingresos de los hogares. Valores más cercanos a 0 implican mayor igualdad, mientras que valores más próximos a 100 reflejan una mayor desigualdad en la distribución de los viajes turísticos según ingresos de la población."),
                                        tags$p(style = "font-size=14px",tags$b(" • Índice de Gini de viajes turísticos de ocio "),": El indicador, en este caso, tiene en cuenta únicamente los viajes con motivo de 'esparcimiento, ocio y recreación',
                                               excluyéndose aquellos relacionados con la visita a familiares y amigos; trabajo, negocios, motivos profesionales; y otros."),
                                        tags$p(style = "font-size=14px",tags$b(style = "font-size=14px"," • Índice de Gini del gasto turístico "),": Medida de desigualdad aplicada al gasto que los hogares tuvieron en el viaje, según quintil 
                                               de ingresos de los hogares.")))
                         )
                )
                )
            )
        )
    )
    ),
    tags$footer(includeHTML("/srv/shiny-server/recursos/shiny_footer.html")))