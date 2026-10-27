# CarSmart — Shiny Application and Reproducible Pitch

A complete **Developing Data Products** peer assessment using R's built-in `mtcars` dataset. Prepared October 27, 2026.

## Files

- `app/ui.R` — Shiny inputs, outputs, styling, and the on-site **How to use** documentation.
- `app/server.R` — Linear regression, user-input calculations, and reactive charts.
- `pitch/CarSmart_Pitch.Rpres` — **exactly five slides**, made for **RStudio Presenter**. It has executable R code chunks, including a model computation and a data plot.

## Run the Shiny app locally

1. Install **R** and **RStudio Desktop** (if not installed).
2. Open RStudio. In the R Console run `install.packages(c("shiny", "rsconnect"))` once.
3. Open `app/ui.R` in RStudio and click **Run App**, or run:

   ```r
   shiny::runApp("app")
   ```

   If you downloaded only the `app` folder, run `shiny::runApp()` from that folder.

4. In the app, begin with default settings, then adjust car weight, horsepower, transmission, annual mileage, and gasoline price. Read the **How to use** tab for in-app documentation.

## Deploy the app to shinyapps.io

1. Sign in at https://www.shinyapps.io/ and create an account if needed.
2. In your account's **Tokens** menu, generate/show a token and **copy the provided `rsconnect::setAccountInfo(...)` command into your own private RStudio Console**. Never commit the token or secret to GitHub.
3. In RStudio run:

   ```r
   rsconnect::deployApp(appDir="app", appName="carsmart-fuel-explorer")
   ```

   Alternatively open `app/ui.R`, Run App and click **Publish**.
4. After deployment, open and test the shinyapps.io URL, including the **How to use** tab. **Submit that exact published app URL** for part 1.

## Render and publish the RStudio Presenter pitch

1. In RStudio choose **File > Open File** and open `pitch/CarSmart_Pitch.Rpres`.
2. Use RStudio's **Presentation/Preview** pane to render it and check it shows **exactly 5 slides** and no R errors. The R code chunks run when rendered.
3. Select **Publish** in the RStudio presentation pane and publish to **RPubs**. Follow the account authentication prompts.
4. Open the published RPubs page to confirm that charts and computations display. **Submit the public RPubs presentation URL** for part 2. If the assignment form insists on HTTP rather than HTTPS, use the `http://rpubs.com/...` form with your own actual published slug (do not guess the slug).

## How it works

The Shiny server fits `lm(mpg ~ wt + hp + transmission)` on 32 historical vehicles. The selected inputs produce a predicted MPG. Annual gallons = miles / MPG and annual fuel cost = annual gallons x USD per US gallon. A savings chart compares the current result with hypothetical 10% and 20% MPG gains. User-entered data is used only for in-session calculations.

**Limitations:** Tiny historical dataset and a very simple regression model. It is an educational demonstration, not a certified fuel-efficiency estimate. The 10% and 20% scenarios are hypothetical improvements in MPG.

## Peer assessment checklist

- [x] Input widgets in `ui.R`
- [x] Calculations and reactive expressions in `server.R`
- [x] Visible reactive numeric outputs and two charts
- [x] On-site **How to use** tab
- [x] Source `ui.R` and `server.R` available on GitHub
- [x] Exactly 5 RStudio Presenter source slides
- [x] Executable R code chunks and plotted output in pitch
- [ ] Deploy Shiny app to shinyapps.io and paste live app link
- [ ] Publish presentation to RPubs and paste public presentation link

## Suggested submission title

**CarSmart: Interactive Fuel Efficiency and Annual Cost Predictor**
