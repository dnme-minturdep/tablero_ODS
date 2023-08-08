#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

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
                    valueBox(tags$p(style = "font-size: 160%;", cst_empleo),
                             tags$p(style = "font-size: 140%;", "Puestos de trabajo en industrias turísticas (2019)"), 
                             icon = icon("glyphicon glyphicon-user", verify_fa = FALSE), width = 4, color = "navy"),
                    valueBox(tags$p(style = "font-size: 160%;", empleo_informal),
                             tags$p(style = "font-size: 140%;", "Tasa de informalidad del empleo turístico (2019)"), 
                             icon = icon("glyphicon glyphicon-user", verify_fa = FALSE), width = 4, color = "navy"),
                    valueBox(tags$p(style = "font-size: 160%;", cst_pibdt),
                             tags$p(style = "font-size: 140%;", "PIB turístico respecto del PIB total (2019)"), 
                             icon = icon("glyphicon glyphicon-user", verify_fa = FALSE), width = 4, color = "navy")),
                fluidRow(
                    valueBox(tags$p(style = "font-size: 160%;", propension),
                             tags$p(style = "font-size: 140%;", "Propensión a viajar (2022)"), 
                             icon = icon("glyphicon glyphicon-user", verify_fa = FALSE), width = 4, color = "navy"),
                    valueBox(tags$p(style = "font-size: 160%;", gini_viajes),
                             tags$p(style = "font-size: 140%;", "Índice de Gini de viajes turísticos (2022)"), 
                             icon = icon("glyphicon glyphicon-user", verify_fa = FALSE), width = 4, color = "navy"),
                    valueBox(tags$p(style = "font-size: 160%;", gini_viajes_ocio),
                             tags$p(style = "font-size: 140%;", "Índice de Gini de viajes turísticos de ocio (2022)"), 
                             icon = icon("glyphicon glyphicon-user", verify_fa = FALSE), width = 4, color = "navy")
                ),
                fluidRow(valueBox(tags$p(style = "font-size: 160%;", gini_gasto),
                                  tags$p(style = "font-size: 140%;", "Índice de Gini del gasto turístico (2022)"), 
                                  icon = icon("glyphicon glyphicon-user", verify_fa = FALSE), width = 4, color = "navy"))
                        )
                        
                    )
                )),
    tags$footer(includeHTML("/srv/shiny-server/recursos/shiny_footer.html")))