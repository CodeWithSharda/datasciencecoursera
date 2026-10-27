# CarSmart - Shiny user interface
# The 'How to use' tab contains the required on-site documentation.
library(shiny)

shinyUI(fluidPage(
  tags$head(
    tags$title("CarSmart | Fuel Cost Explorer"),
    tags$style(HTML("
      body { background:#f4f7fb; color:#18283e; font-family:'Segoe UI',Arial,sans-serif; }
      .container-fluid { max-width:1280px; }
      .hero { background:linear-gradient(115deg,#132c48,#17647b); color:white;
              padding:26px 30px; border-radius:15px; margin:18px 0 22px; }
      .hero h1 { font-weight:750; margin:0 0 6px; font-size:32px; }
      .hero p { margin:0; color:#d1eaf2; font-size:16px; }
      .well { background:white; border:1px solid #e2e9f2; border-radius:12px;
              box-shadow:0 3px 10px rgba(20,40,70,.035); }
      .form-group { margin-bottom:19px; }
      .nav-tabs > li > a { font-weight:600; }
      .tab-content { background:white; padding:22px 24px; border:1px solid #e2e9f2;
                     border-top:0; border-radius:0 0 12px 12px; margin-bottom:28px; }
      .metrics { display:flex; gap:14px; flex-wrap:wrap; margin:5px 0 19px; }
      .metric { background:#eef6fa; border:1px solid #d8e9f1; border-radius:12px;
                flex:1 1 160px; padding:17px; min-width:150px; }
      .metric .labeltext { color:#475e70; font-size:13px; font-weight:600; }
      .metric .number { margin-top:6px; font-size:25px; font-weight:750; color:#116379; }
      .explain { line-height:1.7; color:#33475e; }
      h3 { font-weight:700; font-size:20px; }
      .small-note { font-size:13px; color:#617085; padding-top:8px; }
      .shiny-plot-output { max-width:100%; }
    "))
  ),
  div(class="hero",
      h1("CarSmart"),
      p("An interactive fuel-efficiency and annual fuel-cost explorer built with R Shiny")),
  sidebarLayout(
    sidebarPanel(width=4,
      h3("Set up your car"),
      sliderInput("weight", "Car weight (1,000 pounds)",
                  min=1.5, max=5.5, value=3.0, step=0.1),
      sliderInput("horsepower", "Engine horsepower", min=52, max=335,
                  value=120, step=1),
      radioButtons("transmission", "Transmission",
                   choices=c("Automatic"="Automatic", "Manual"="Manual"),
                   selected="Automatic", inline=TRUE),
      tags$hr(),
      h3("Set up your driving"),
      sliderInput("annual_miles", "Miles driven each year",
                  min=3000, max=30000, value=12000, step=1000),
      numericInput("fuel_price", "Gas price (USD per US gallon)",
                   value=3.50, min=0.50, max=12.00, step=0.25),
      p(class="small-note", "Change any value to update the calculations instantly.")
    ),
    mainPanel(width=8,
      tabsetPanel(
        tabPanel("Your estimate",
          h3("Personalized estimate"),
          div(class="metrics",
            div(class="metric", div(class="labeltext", "Predicted fuel efficiency"),
                div(class="number", textOutput("predicted_mpg", inline=TRUE))),
            div(class="metric", div(class="labeltext", "Estimated annual fuel bill"),
                div(class="number", textOutput("fuel_cost", inline=TRUE))),
            div(class="metric", div(class="labeltext", "Estimated annual fuel use"),
                div(class="number", textOutput("fuel_gallons", inline=TRUE)))
          ),
          h3("How small improvements can save money"),
          plotOutput("savings_plot", height="285px"),
          textOutput("savings_sentence"),
          p(class="small-note", "Estimates are educational and are not real-world vehicle ratings.")),
        tabPanel("Explore the data",
          h3("How does your car compare with the sample?"),
          plotOutput("car_plot", height="335px"),
          textOutput("model_details"),
          p(class="small-note", "Each dot represents one of the 32 cars in the built-in mtcars dataset.")),
        tabPanel("How to use",
          h3("Getting started — no R knowledge needed"),
          div(class="explain",
            tags$ol(
              tags$li("Adjust car weight and horsepower on the left. Weight is measured in thousands of pounds: 3.0 means 3,000 lb."),
              tags$li("Choose an automatic or manual transmission."),
              tags$li("Enter roughly how many miles you drive in a year and the price of fuel per US gallon."),
              tags$li("Open 'Your estimate' to see miles per gallon (MPG), yearly fuel consumption, and yearly fuel costs."),
              tags$li("Review the savings chart to see hypothetical 10% and 20% MPG improvements."),
              tags$li("Open 'Explore the data' to see how your estimated vehicle sits among sample cars.")
            ),
            h3("What the results mean"),
            p(tags$b("MPG"), " means miles per US gallon; a higher value means less fuel used for the same distance."),
            p(tags$b("Annual fuel use"), " = annual miles driven / predicted MPG."),
            p(tags$b("Annual fuel cost"), " = annual fuel use x price per gallon."),
            h3("Data, method, and limitations"),
            p("The app uses R's built-in mtcars dataset (32 historical vehicles) and fits a linear regression using weight, horsepower, and transmission. The sample is small and old. This is an educational demonstration, not an estimate of a current car's tested MPG, and it does not adjust for traffic, driving style, weather, or technology."),
            p("The displayed 10% and 20% improvement scenarios change MPG, not horsepower or the trained model. Input combinations outside those represented in the historical sample may be unreliable."),
            p(tags$b("Source:"), " R built-in datasets::mtcars; no user data is uploaded or retained."),
            p(tags$b("Help:"), " Try the defaults first, then change one input at a time and observe the updated numbers and charts.")
          )
        )
      )
    )
  )
))
