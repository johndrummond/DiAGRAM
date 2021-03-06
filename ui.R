
# Following script defines components displayed on the webpage.

# This script was built for DiAGRAM by the University of Warwick and The National
# Archive.

# @author: Stephen James Krol, Monash University, Melbourne
# @email: stephen.james.krol@gmail.com

library(shiny)
library(rintrojs)
library(networkD3)
library(shinydashboard)
library(gRbase)
library(gRain)
library(shinysky)
library(shinyWidgets)
library(shinyjs)
library(shinyalert)
library(tidyverse)
library(plotly)
library(DT)
library(V8)

options(repos = BiocManager::repositories())
nquestions <- read_csv("setup_questions.csv") %>% nrow()

# create main dashboard page
dashboardPage(
  skin="purple",
  
  # Add header and title to Dashboard
  dashboardHeader(
    title="DiAGRAM"
  ),
  
  # Add dashboard sidebar
  dashboardSidebar(
    
    # Create sidebar menu
    sidebarMenu(
      id="sidebarMenu",
      
      # Create home page
      menuItem(
        "Home",
        tabName="Home",
        icon=icon("home")
      ),
      
      # Create Network Info Page
      menuItem("Definitions",
               tabName="Node_definitions",
               icon=icon("info")),
      
      # Customise model tab
      menuItem("1. Create your model",
               tabName="CustomiseModel",
               icon=icon("user-edit")),
      
      # Sensitivity Page
      menuItem("Recommendations", 
               tabName = "Sensitivity",
               icon=icon("clipboard")),
      
      # Simple View Page
      menuItem("2. Compare policies",
               tabName = "CustomiseNode",
               icon=icon("chart-bar")),
      
      # Create Report Tab
      menuItem("3. Report",
               tabName="Report",
               icon=icon("book")),
      
      # Advanced Page
      menuItem("Advanced customisation", 
                 tabName = "AdvancedCustomiseNode",
                 icon=icon("project-diagram"))
      
      
    )
  ),
  
  # Create Dashboard body
  dashboardBody(
    id="dashboardBody",
    
    # include introjs UI
    introjsUI(),
    
    # create content for tabs
    tabItems(
      
      # Home Tab
      tabItem(
        tabName="Home",
        
        shiny::fluidRow(
          
          # Welcome box
          shinydashboard::
          box(title = NULL,
              width = 12,
              background="orange",
              h3(strong("Important note: This model is still in development")),
              p("There will be further user interface changes and additional functionality added as the 
              project progresses. Any feedback to inform the future development would be welcome 
                - please send your comments to a member of the project team.")),
          box(
            title = NULL,
            width = 12,
            shiny::h2("DiAGRAM - The ",tags$b("Di",.noWS="outside"),"gital ",tags$b("A",.noWS="outside"),"rchiving ",tags$b("G",.noWS="outside"),"raphical 
                      ",tags$b("R",.noWS="outside"),"isk ",tags$b("A",.noWS="outside"),"ssessment ",tags$b("M",.noWS="outside"),"odel", align="center"),
            h3("Version 0.9.7 (Prototype)", align="center"), #update in June   
            br(),
            
            p("This is the Digital Archiving Graphical Risk Assessment Model (DiAGRAM) built by the ",
             a(href="https://warwick.ac.uk", "University of Warwick"),
              " and ",
              a(href="https://www.nationalarchives.gov.uk"," The National Archives"), 
              "with support from the ",
              a(href="https://www.heritagefund.org.uk/", "National Lottery Heritage Fund"),
              " and the ",
              a(href="https://epsrc.ukri.org/", "Engineering and Physical Sciences Research Council."),
              "For more information about the project please see our ",
              a(href="https://www.nationalarchives.gov.uk/information-management/manage-information/preserving-digital-records/research-collaboration/safeguarding-the-nations-digital-memory/",
                "project page.")),
            p("Before using the tool for the first time, we would advise you to read the ",
              a(href="https://www.dpconline.org/events/past-events/quantifying-digital-preservation-risk-online-workshop-2",
              "presentations")," from our online workshop with the Digital Preservation Coalition, where there is also an ",
              a(href="https://www.dpconline.org/docs/miscellaneous/events/2020-events/2307-dpc-workshop-2-exercise/file", "exercise sheet"),
              " you can work though."),
            br(),
            tags$style(HTML('#createModel{background-color:green}')),
            tags$style(HTML('#createModel{color:white}')),
            tags$style(HTML('#createModel{width:30%')),
            div(actionButton("createModel","Create your model"), style="text-align:center"),
            br(),
            h3("Introduction"),
            p("This decision support tool enables users to score their archive's
            digital preservation risk and then explore how this would change under
            different policies and risk scenarios. The risk score is based on the proportion of 
              files in the archive that are renderable and where the archivist has full
              intellectual control."),
            p("The underlying methodology used to create this model is based on a Bayesian network
            - a probabilistic graphical model that captures the conditional dependencies of risk 
            events. When historical data were unavailable, data from an expert elicitation 
            session conducted in April 2020 were used to inform the probabilities needed for
            this model."),
            
            p("This interface enables users to:"),
            tags$ul(
              tags$li("Understand the risk definitions used in the model and 
                      how the risk events are linked together"),
              tags$li("Create a model that reflects the policies and practices for their 
                      Digital Archive"),
              tags$li("Test alternative policies to see how this impacts the risk score"),
              tags$li("Download the model and a summary of the results"),
              tags$li("Upload a pre-built model and continue exploring scenarios from there"),
              tags$li("Update the probability tables for the model based on the user's own data or 
                      experience"),
              tags$li("Create bespoke scenarios by directly manipulating the probabilities
                      used in the model")),
            br(),
            # Adding Logos
            img(src="https://www.nationalarchives.gov.uk/wp-content/uploads/2019/06/TNA-SQUARE-LOGO-POSITIVE-01-720x720.jpg",
                height=100,
                width=100),
            img(src='https://www.underconsideration.com/brandnew/archives/university_of_warwick_logo_detail.png',
                height=80,
                width=120),
                        img(src="https://www.heritagefund.org.uk/sites/default/files/media/attachments/English%20logo%20-%20Colour%20%28JPEG%29.jpg",
                height=80,
                width=216),
            img(src="UKRI_EPSR_Council-Logo_Horiz-RGB.png", height=75)),
          box(
            width = 12,
            h3("Guidance"),
            br(),
            p(tags$b("Definitions"),": This page has a visualisation of the underlying network of digital preservation risks and
              allows you to see the full definitions, states and data sources used for each 'node'."),
            p(tags$b("1. Create your model"),": This goes through 9 questions to create a risk model and a score which is
              based on the user's archive and policies."),
            p(tags$b("Recommendations"),": This page looks at the impact changing each of the answers to the input questions would
              have to the risk score."),
            p(tags$b("2. Compare policies"),": Create and save different policies and see how the risk score changes."),
            p(tags$b("3. Advanced customisation"),": This tab allows users to edit the marginal and conditional probabilities
              in the model directly. This allows for users to input their own data for any nodes within the model 
              or create scenarios by altering conditional probabilities."),
            p(tags$b("4. Report"),": This contains a summary and comparison of the policies for each model, and allows 
              the model and plots to be downloaded.")
            #br(),
            #p("If you have further questions, please contact the workshop facilitator.")
          )
        )
      ),
      
      # Network Tab
      tabItem(
        tabName="Node_definitions",
        useShinyalert(),
        box(title = NULL,
            width = 12,
            background="orange",
            h3(strong("Important note: This model is still in development")),
            p("There will be further user interface changes and additional functionality added as the 
              project progresses. Any feedback to inform the future development would be welcome 
                - please send your comments to a member of the project team.")),
        h1("Definitions"),
        br(),
        fluidRow(
          column(
            width=4,
            box(
              title="Node selection",
              width=NULL,
              collapsible=TRUE,
              h4("Please select a node from the menu to view its definition."),
              br(),
              br(),
              tags$style(type='text/css', ".selectize-input { font-size: 15px; line-height: 15px;} 
                     .selectize-dropdown { font-size: 15px; line-height: 15px; }"),
              selectInput(
                inputId="NodeSelection",
                label=NULL,
                choices="No Nodes Available"
              )
            )
          ),
          column(
            width=8,
            box(
              title="Node description",
              width=NULL,
              collapsible=TRUE,
              column(
                width=6,
                uiOutput("NodeDefinition"),
                br(),
                uiOutput("DataLink"),
                br(),
                uiOutput("DataYear")
              ),
              column(
                width=6,
                tableOutput("StateDefinition")
              )
            )
          )
        ),
        fluidRow(
          column(width=12,
                 box(
                   title="DiAGRAM structure",
                   collapsible=TRUE,
                   width=NULL,
                   plotOutput("NetworkStructure")
                 )
          )
        )
      ),
      # Policy Tab
      tabItem(
        tabName="CustomiseModel",
        useShinyalert(),
        box(title = NULL,
            width = 12,
            background="orange",
            h3(strong("Important note: This model is still in development")),
            p("There will be further user interface changes and additional functionality added as the 
              project progresses. Any feedback to inform the future development would be welcome 
                - please send your comments to a member of the project team.")),
        h1("Create your model"),
        br(),
        fluidRow(
          column(
            width=12,
            box(
              title=NULL,
              width=NULL,
              progressBar("Question_Progress", value=1, total=nquestions),
              #h4("Please answer the following question: "),
              uiOutput("Question"),
              useShinyjs(),
              br(),
              uiOutput("CustomisationInput")
            )
          )
        ),
        fluidRow(
          column(
            width=8,
            box(
              title="Model risk score",
              width=NULL,
              collapsible=TRUE,
              plotOutput("BasicUtilityComparison")
            )
          ),
          column(
            width=4,
            box(
              title="Upload a previous model",
              collapsible=TRUE,
              width=NULL,
              strong("Please ensure any models uploaded have been generated from DiAGRAM"),
              br(),
              br(),
              fileInput("customModel",
                        "Choose custom model",
                        accept=c(".bif")),
              textInput("uploadName",
                        label="Custom Model Name"),
              tags$style(HTML('#uploadCustomModel{background-color:green}')),
              tags$style(HTML('#uploadCustomModel{color:white}')),
              actionButton("uploadCustomModel",
                           "Add model")
            )
          )
        )
      ),
      
      # TODO:sid - change policyTab identifier to the most appropriate (once decided)
      tabItem(
        tabName="CustomiseNode",
        useShinyalert(),
        box(title = NULL,
            width = 12,
            background="orange",
            h3(strong("Important note: This model is still in development")),
            p("There will be further user interface changes and additional functionality added as the 
              project progresses. Any feedback to inform the future development would be welcome 
                - please send your comments to a member of the project team.")),
        h1("Create and compare different policies"),
        br(),
        div(
          selectInput("customModelSelection",
                      h3("Select model"),
                      choices = "Default")
        ),
        fluidRow(
          column(
            width = 3,
            selectInput("customOaisEntitySelection",
                        h5("Select OAIS Function Entity"),
                        choices="None", 
                        multiple = TRUE),
            box(
              title="Nodes checklist",
              width=NULL,
              checkboxGroupInput("policyTabNodesChecklist", 
                                 label=NULL,
                                 choices=character(0))
            )
          ),
          column(
            width=4,
            useShinyjs(),
            box(
              id="StateNodeSliderBox",
              title=NULL,
              width=NULL,
              div(id="nodeSliderPlaceholder", h4('No nodes selected')),
              uiOutput("policyTabNodesSlider"),
              tags$style(HTML('#SimpleViewPolicyPrevious{background-color:grey}')),
              tags$style(HTML('#SimpleViewPolicyPrevious{color:white}')),
              actionButton("SimpleViewPolicyPrevious", label = "Previous"),
              tags$style(HTML('#SimpleViewPolicyNext{background-color:green}')),
              tags$style(HTML('#SimpleViewPolicyNext{color:white}')),
              actionButton("SimpleViewPolicyNext", label = "Next"),
              br()
            ),
            box(
              id="SimpleViewPolicyAddBox",
              title=NULL,
              width=NULL,
              textInput("SimpleViewPolicyName", label = h4("Enter policy name"), value = ""),
              tags$style(HTML('#SimpleViewAddPolicy{background-color:green}')),
              tags$style(HTML('#SimpleViewAddPolicy{color:white}')),
              actionButton("SimpleViewAddPolicy", "Add policy")
            ),
              tags$style(HTML('#SimplePolicyReset{background-color:gray}')),
               tags$style(HTML('#SimplePolicyReset{color:white}')),
               div(actionButton('SimplePolicyReset', 'Reset model'), style="float:right")
          ),
          column(
            width=5,
            plotOutput("policyTabUtilityScorePlot"),
            br(),
            box(id="RemovePolicyBox",
                width=NULL,
                title="Remove policy",
                selectInput("policyTabPolicyRemove",
                        h5("Select policy to remove"),
                        choices=""),
            tags$style(HTML('#RemovePolicy{background-color:red}')),
            tags$style(HTML('#RemovePolicy{color:white}')),
            div(actionButton('RemovePolicy', 'Remove'), style="float:right")
          )       
        )
      )),
      
      # Policy Tab
      tabItem(
        tabName="AdvancedCustomiseNode",
        useShinyalert(),
        box(title = NULL,
            width = 12,
            background="orange",
            h3(strong("Important note: This model is still in development")),
            p("There will be further user interface changes and additional functionality added as the 
              project progresses. Any feedback to inform the future development would be welcome 
                - please send your comments to a member of the project team.")),
        h1("Advanced model customisation"),
        br(),
        fluidRow(
          width=8,
          fluidRow(
            column(width=12,
                   # Plot the bayesian network
                   box(
                     title="DiAGRAM structure",
                     collapsible=TRUE,
                     width=NULL,
                     plotOutput("netPlot")
                   )
            )
          ),
          fluidRow(
            column(
              width=4,
              box(
                width=NULL,
                selectInput("model_version",
                            h3("Select Model"),
                            choices="Default"),
                selectInput("nodeProbTable",
                            h4("Select Node"),
                            choices=c("nodes loading")),
                tags$style(HTML('#networkReset{background-color:gray}')),
                tags$style(HTML('#networkReset{color:white}')),
                actionButton('networkReset','Reset model')
              )
            ),
            column(
              width=8,
              box(
                title="Probability table",
                width=NULL,
                column(
                  width=4,
                  radioButtons("probtabltype",
                               "Table Type",
                               choices=c("Independent Probability Table",
                                         "Conditional Probability Table")),
                  tags$style(HTML('#updateProb{background-color:green}')),
                  tags$style(HTML('#updateProb{color:white}')),
                  actionButton("updateProb", "Add changes")
                  
                ),
                column(
                  width=8,
                  hotable("probabilityTable")
                )

              )
            )
          ),
          fluidRow(
            column(
              width=4,
              box(
                title="Changed nodes",
                width=NULL,
                collapsible=TRUE,
                tags$ul(
                  uiOutput("ChangeNodes")
                )
              ),
              box(
                title="Save model",
                width=NULL,
                collapsible=TRUE,
                textInput("policyName",
                          label="Modified model name:",
                          value=""),
                tags$style(HTML('#addPolicy{background-color:green}')),
                tags$style(HTML('#addPolicy{color:white}')),
                actionButton("addPolicy",
                             "Add as policy"),
                tags$style(HTML('#addModelAdvanced{background-color:green}')),
                tags$style(HTML('#addModelAdvanced{color:white}')),
                actionButton("addModelAdvanced",
                             "Add as custom model")
              )
            ),
            column(
              width=8,
              box(
                title="Node probability",
                width=NULL,
                collapsible=TRUE,
                plotOutput("nodeProbability")
              )
            )
          ),
          fluidRow(
            column(
              width=6,
              box(
                title="Policy comparison",
                width=NULL,
                plotOutput("PolicyComparison")
              )
            ),
            column(
              width=6,
              box(
                title="Model comparison",
                width=NULL,
                plotOutput("BaseUtilityComparison")
              )
            )
          )
        )
      ),
      tabItem(
        tabName="Report",
        box(title = NULL,
            width = 12,
            background="orange",
            h3(strong("Important note: This model is still in development")),
            p("There will be further user interface changes and additional functionality added as the 
              project progresses. Any feedback to inform the future development would be welcome 
                - please send your comments to a member of the project team.")),
        h1("Report"),
        br(),
        div(
          selectInput(
            "reportTabModelSelection",
            h3("Select model"),
            choices ="Default")
        ),
        fluidRow(
          column(
            width=6,
            box(
              title="Summary",
              width=NULL,
              htmlOutput("ReportTabSummaryText")
            ),
            box(
              title="Score function weightings",
              width=NULL,
              collapsible = TRUE,
              collapsed = TRUE,
              sliderInput(inputId="RenderabilityWeighting",
                          label="Renderability weighting",
                          min=0,
                          max=1,
                          value=1,
                          step=0.1),
              sliderInput(inputId="IntellectualWeighting",
                          label="Intellectual control weighting",
                          min=0,
                          max=1,
                          value=1,
                          step=0.1)
            ),
            box(
              title="Downloads",
              width=NULL,
              "Select what you would like to download:",
              br(),
              br(),
              checkboxGroupInput("downloadOptions",
                                 NULL,
                                 choices=c("The plot",
                                 "The model",
                                  "A policy")),
              br(),
              selectInput("ReportTabPolicySelection",
                          h5("Select policy to download"),
                          choices="Base"),
              br(),
              tags$style(HTML('#Download{background-color:green}')),
              tags$style(HTML('#Download{color:white}')),
              downloadButton("reportTabDownloadBtn",
                             "Download")
              
            ),
          ),
          column(
            width=6,
            box(
              title="Comparing policies",
              width=NULL,
              plotOutput("ReportTabUtilityComparisonPlot")
            ) #,
            #box(id="RemovePolicyBoxReport",
            #    width=NULL,
            #    title="Remove policy",
            #    selectInput("reportTabPolicyRemove",
            #                h5("Select policy to remove"),
            #                choices=""),
            #    tags$style(HTML('#RemovePolicyReport{background-color:red}')),
            #    tags$style(HTML('#RemovePolicyReport{color:white}')),
            #    div(actionButton('RemovePolicyReport', 'Remove'), style="float:right")
            #)
          )
        )
      ),
      tabItem(
        tabName="Sensitivity",
        box(title = NULL,
            width = 12,
            background="orange",
            h3(strong("Important note: This model is still in development")),
            p("There will be further user interface changes and additional functionality added as the 
              project progresses. Any feedback to inform the future development would be welcome 
                - please send your comments to a member of the project team.")),
        h1("Recommendations"),
        br(),
        div(
          selectInput(
            "sensTabModelSelection",
            h3("Select model"),
            choices ="Default")
        ),
        fluidRow(
          useShinyjs(),
          # code to reset plotlys event_data("plotly_click", source="A") to NULL -> executed upon action button click
          # note that "A" needs to be replaced with plotly source string if used
          extendShinyjs(text = "shinyjs.resetClick = function() { Shiny.onInputChange('plotly_click-A', 'null'); }"),
          column(
            width=12,
             
            box(
              title="Visualisation of potential policy changes",
              width=NULL,
              h5("This plot shows how changing your answers to the input questions will impact the score for renderability
                 (on the x axis) and intellectual control (on the y axis). Changes that improve the score will appear as 
                 points above and to the right of the origin (where the axes meet) and changes that decrease the score 
                 will be to the bottom and left."),
              h5("Note: All input nodes are considered changable here but some may not be in your control."),
              br(),
              plotlyOutput("SensitivityPlot")
            ),
             # box(
             #   title="Selected Node",
             #   width=NULL,
             #   textOutput("clickevent")
             # ),
            box(
              title="Summary table of potential policy changes",
              width=NULL,
              h5("Note: All input nodes are considered changable here but some may not be in your control."),
              br(),
              dataTableOutput("SensitivityTable")
            )
          )
        )
      )
    )
  )
)
