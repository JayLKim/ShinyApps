library(shiny)

shinyServer(function(input, output) {
  # Creating an imaginary population
  pop <- reactive({
    df <- numeric()
    columnnames <- character()
    for(i in 1 : input$var_num) {
      variables <- rnorm(100000)
      df <- cbind(df, variables)
      columnnames <- c(columnnames, paste("variable_", i))
    }
    colnames(df) <- columnnames
    df
  })
  # Sampling process
  sampling <- reactive({
    sample(1 : 100000, size = 30 * 2)
  })
  group_A <- reactive({
    pop()[sampling()[1 : 30], ]
  })
  group_B <- reactive({
    pop()[sampling()[31 : 60], ]
  })
  # Calculating p-values
  p_values <- reactive({
    p_val <- numeric()
    for(i in 1 : input$var_num) {
      temp <- t.test(group_A()[, i], group_B()[, i], var.equal = TRUE)$p.value
      p_val <- c(p_val, temp)
    }
    p_val
  })
  # getting p-values adjusting methods
  correction <- reactive({
    input$correction
  })
  
  # Displaying output
  output$A <- renderTable({
    group_A()
  })
  
  output$B <- renderTable({
    group_B()
  })
  
  output$summary_A <- renderPrint({
    summary(group_A())
  })
  
  output$summary_B <- renderPrint({
    summary(group_B())
  })
  
  output$unadj <- renderPlot({
    plot(p_values(), ylim = c(0, 1), ylab = "p-values")
    abline(h = 0.05, col = "red", lwd = 1.5)
    text(x = 1, y = 0.065, "0.05", col = "red")
  })
  
  output$adj <- renderPlot({
    p_val <- p.adjust(p_values(), method = input$correction)
    plot(p_val, ylim = c(0, 1), ylab = "p-values")
    abline(h = 0.05, col = "red", lwd = 1.5)
    text(x = 1, y = 0.06, "0.05", col = "red")
  })
})