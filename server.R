#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$graph_cst_empleo <- renderPlotly(
        ggplotly(cst %>% 
                     filter(indicador == "Puestos de trabajo en las industrias turísticas  (en miles)") %>% 
                     ggplot(aes(x=anio,y=valor,
                                text = paste0('Año: ', anio,
                                              '<br>Puestos: ',format(round(valor/1000,2),big.mark=".",
                                                                     decimal.mark = ","),"M")))+
                     geom_col(fill = "#000080")+
                     #geom_label(aes(label = scales::label_number(decimal.mark = ",",big.mark = ".", accuracy =1 )(round(valor/100,1))), size = 2.5)+
                     scale_y_continuous(limits=c(0,NA),labels = scales::label_number( decimal.mark = ",",scale=1/1e+3,
                                                                                      accuracy = .1)) + 
                     theme_minimal()+
                     theme(legend.position = "bottom", 
                           axis.text.x =element_text (size =9, angle = 40, vjust = 0.5),
                           axis.text.y = element_text(size = 12),
                           legend.text = element_text (size =10),
                           plot.caption = ggtext::element_markdown()) +
                     labs(y = "", 
                          x = "", 
                          color= "",
                          fill="",title = "",
                          subtitle = "",
                          caption =  "**Fuente**: Cuenta Satélite de turismo de Argentina (CST-A)" ),
                 tooltip = "text")
        )
    output$informalidad_empleo <- renderPlotly(
        ggplotly(empleo_cat  %>% 
                     ggplot(aes(x=as.character(anio),y=tasa_informal,
                                text = paste0('Año: ', anio,
                                              '<br>Informalidad: ',format(round(tasa_informal*100,2),big.mark=".",
                                                                     decimal.mark = ","),"%")))+
                     geom_col(fill = "#000080")+
                     #geom_label(aes(label = scales::label_number(decimal.mark = ",",big.mark = ".", accuracy =1 )(round(valor/100,1))), size = 2.5)+
                     scale_y_continuous(limits=c(0,NA),labels = scales::percent_format( decimal.mark = ",")) + 
                     theme_minimal()+
                     theme(legend.position = "bottom", 
                           axis.text.x =element_text (size =9, angle = 40, vjust = 0.5),
                           axis.text.y = element_text(size = 12),
                           legend.text = element_text (size =10),
                           plot.caption = ggtext::element_markdown()) +
                     labs(y = "", 
                          x = "", 
                          color= "",
                          fill="",title = "",
                          subtitle = "",
                          caption =  "**Fuente**: Cuenta Satélite de turismo de Argentina (CST-A)" ),
                 tooltip = "text")
    )
    output$graph_pibdt <- renderPlotly(
        ggplotly(cst %>% 
                     filter(indicador == "Producto bruto interno directo turístico (PBIDT)" & valor < 1) %>% 
                     ggplot(aes(x=anio,y=valor,
                                text = paste0('Año: ', anio,
                                              '<br>PIBDT: ',format(round(valor*100,2),big.mark=".",
                                                                     decimal.mark = ","),"%")))+
                     geom_col(fill = "#000080")+
                     #geom_label(aes(label = scales::label_number(decimal.mark = ",",big.mark = ".", accuracy =1 )(round(valor/100,1))), size = 2.5)+
                     scale_y_continuous(limits=c(0,NA),labels = scales::percent_format( decimal.mark = ",")) + 
                     theme_minimal()+
                     theme(legend.position = "bottom", 
                           axis.text.x =element_text (size =9, angle = 40, vjust = 0.5),
                           axis.text.y = element_text(size = 12),
                           legend.text = element_text (size =10),
                           plot.caption = ggtext::element_markdown()) +
                     labs(y = "", 
                          x = "", 
                          color= "",
                          fill="",title = "",
                          subtitle = "",
                          caption =  "**Fuente**: Cuenta Satélite de turismo de Argentina (CST-A)" ),
                 tooltip = "text")
    )
    output$graph_propension <- renderPlotly(
        ggplotly(prop_viaje %>% 
                     ggplot(aes(x=as.character(indice_tiempo),y=participacion,
                                text = paste0('Año: ', indice_tiempo,
                                              '<br>Participación: ',format(round(participacion*100,2),big.mark=".",
                                                                   decimal.mark = ","),"%")))+
                     geom_col(fill = "#00c0ef")+
                     #geom_label(aes(label = scales::label_number(decimal.mark = ",",big.mark = ".", accuracy =1 )(round(valor/100,1))), size = 2.5)+
                     scale_y_continuous(limits=c(0,NA),labels = scales::percent_format( decimal.mark = ",")) + 
                     theme_minimal()+
                     theme(legend.position = "bottom", 
                           axis.text.x =element_text (size =9, angle = 40, vjust = 0.5),
                           axis.text.y = element_text(size = 12),
                           legend.text = element_text (size =10),
                           plot.caption = ggtext::element_markdown()) +
                     labs(y = "", 
                          x = "", 
                          color= "",
                          fill="",title = "",
                          subtitle = "",
                          caption =  "**Fuente**: Encuesta de Viajes y Turismo de los Hogares (EVyTH)" ),
                 tooltip = "text")
    )
    output$graph_gini_todos <- renderPlotly(
        ggplotly(gini_todos %>% 
                     ggplot(aes(x=as.character(anio),y=indice, group=indicador,
                                color=indicador,
                                text = paste0('Año: ', anio,
                                              '<br>Valor: ',format(round(indice*100,2),big.mark=".",
                                                                   decimal.mark = ","))))+
                     geom_point()+
                     geom_line()+
                     #geom_label(aes(label = scales::label_number(decimal.mark = ",",big.mark = ".", accuracy =1 )(round(valor/100,1))), size = 2.5)+
                     scale_y_continuous(limits=c(0,NA),labels = scales::percent_format( decimal.mark = ",")) + 
                     theme_minimal()+
                     #comunicacion::scale_color_dnmye()+
                     theme(legend.position = "bottom", 
                           axis.text.x =element_text (size =9, angle = 40, vjust = 0.5),
                           axis.text.y = element_text(size = 12),
                           legend.text = element_text (size =10),
                           plot.caption = ggtext::element_markdown()) +
                     labs(y = "", 
                          x = "", 
                          color= "",
                          fill="",title = "",
                          subtitle = "",
                          caption =  "**Fuente**: Encuesta de Viajes y Turismo de los Hogares (EVyTH)" ),
                 tooltip = "text") %>% 
            layout(legend = list(
                orientation = "h",
                x = -0.5, y =-1)
            )
            )
        })


