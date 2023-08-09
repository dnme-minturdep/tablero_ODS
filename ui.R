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
            tabItem(
                tabName = "summary",
                fluidRow(
                    box(width = 12, tags$b("Indicadores para el seguimiento de la actividad turística en el marco de los Objetivos de Desarrollo Sostenible (ODS) ")))
                ,
                fluidRow(
                    box(width = 12, tags$b("Impacto económico y empleo")))
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
                    box(width = 12, tags$b("Acceso al turismo y desigualdad"))),
                fluidRow(
                    valueBox(tags$p(style = "font-size: 250%;", propension),
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
                    box(width = 4, status = "primary", solidHeader = TRUE,
                        title = "Índice de Gini de viajes turísticos", plotlyOutput("graph_gini_viajes", height = 200)),
                   box(width = 4, status = "primary", solidHeader = TRUE,
                    title = "Índice de Gini de viajes turísticos de ocio", plotlyOutput("graph_gini_viajes_ocio", height = 200))
                ),
                fluidRow(
                    box(width = 4, status = "primary", solidHeader = TRUE,
                        title = "Índice de Gini del gasto turístico", plotlyOutput("graph_gini_gasto", height = 200)))
                )
            )
        )
    ),
    tags$footer(includeHTML("/srv/shiny-server/recursos/shiny_footer.html")))