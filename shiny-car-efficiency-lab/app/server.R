# CarSmart - Shiny server calculations
# Built-in dataset; only 'shiny' needs to be installed.
library(shiny)

cars <- mtcars
cars$transmission <- factor(cars$am, levels=c(0, 1),
                            labels=c("Automatic", "Manual"))
model <- lm(mpg ~ wt + hp + transmission, data=cars)

shinyServer(function(input, output, session) {
  estimate <- reactive({
    req(input$weight, input$horsepower, input$transmission,
        input$annual_miles, input$fuel_price)
    validate(need(is.finite(input$fuel_price) && input$fuel_price > 0,
                  "Enter a positive fuel price."))
    scenario <- data.frame(
      wt=input$weight,
      hp=input$horsepower,
      transmission=factor(input$transmission,
                          levels=levels(cars$transmission))
    )
    predicted_mpg <- as.numeric(predict(model, newdata=scenario))
    validate(need(is.finite(predicted_mpg) && predicted_mpg > 0,
                  "The model cannot produce a positive MPG for these inputs."))
    gallons <- input$annual_miles / predicted_mpg
    cost <- gallons * input$fuel_price
    list(mpg=predicted_mpg, gallons=gallons, cost=cost)
  })

  output$predicted_mpg <- renderText({
    sprintf("%.1f MPG", estimate()$mpg)
  })
  output$fuel_cost <- renderText({
    paste0("$", format(round(estimate()$cost), big.mark=",", trim=TRUE))
  })
  output$fuel_gallons <- renderText({
    paste0(format(round(estimate()$gallons), big.mark=",", trim=TRUE), " gal")
  })

  output$savings_plot <- renderPlot({
    e <- estimate()
    mpg_scenarios <- e$mpg * c(1, 1.10, 1.20)
    annual_costs <- input$annual_miles / mpg_scenarios * input$fuel_price
    positions <- barplot(annual_costs,
                         names.arg=c("Your estimate", "+10% MPG", "+20% MPG"),
                         col=c("#17647b", "#3a93a8", "#9bd4ce"), border=NA,
                         ylim=c(0, max(annual_costs)*1.24),
                         ylab="Estimated annual fuel cost (USD)",
                         cex.names=0.9, las=1)
    text(positions, annual_costs,
         labels=paste0("$", format(round(annual_costs), big.mark=",")),
         pos=3, cex=0.95, font=2)
    box(bty="l")
  })

  output$savings_sentence <- renderText({
    e <- estimate()
    saving <- e$cost - e$cost / 1.20
    paste0("A hypothetical 20% improvement in MPG would save about $",
           format(round(saving), big.mark=",", trim=TRUE),
           " per year with the driving and gas price you selected.")
  })

  output$car_plot <- renderPlot({
    e <- estimate()
    point_colors <- ifelse(cars$transmission == "Manual", "#d58b40", "#3b90a7")
    plot(cars$wt, cars$mpg,
         xlab="Weight (1,000 pounds)", ylab="Miles per gallon (MPG)",
         main="Historical sample vs. your simulated car",
         pch=19, col=point_colors, cex=1.1,
         xlim=c(1.4, 5.7),
         ylim=range(c(cars$mpg, e$mpg, 5), finite=TRUE))
    grid(col="#e1e8f0")
    points(input$weight, e$mpg, pch=8, cex=2.1, lwd=2.5, col="#b94455")
    legend("topright", legend=c("Automatic (data)", "Manual (data)", "Your estimate"),
           col=c("#3b90a7", "#d58b40", "#b94455"),
           pch=c(19, 19, 8), bty="n", cex=0.83)
  })

  output$model_details <- renderText({
    sprintf("Model: linear regression with weight, horsepower and transmission; R-squared = %.2f. This describes 32 historical cars, not modern vehicle performance.",
            summary(model)$r.squared)
  })
})
