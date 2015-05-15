library(shiny)

shinyUI(fluidPage(
  titlePanel("Simulating Multiplicity"),
  p("Have you ever put all available variables into an analysis and iterated 
    many t-tests praying 'Please be significant!'? I have. I did that kind of 
    the unwise deed when I didn't understand about ",
    em("multiple comparisons problem.")),
  p("In this application, you can conduct t-tests as many as you like 
    at the same time and check the distribution of p-values. You can also
    compare the p-values with the adjusted ones by using the ",
    code("p.adjust()"),
    ". In the first step, the application will create an imaginary population
    of which all variables follow a standard normal distribution. You can set
    the number of the variables to test. And then it will randomly sample 
    two different groups of which the sample size is 30 each. The two groups
    will be compared by an independent samples t-test for each variable. So
    you will be able to get p-values as many as you set at the first step."),
  p("When you finish setting the values, click the submit button. Then you
    can see the results shifting tabs. As you change the correction 
    method and click the submit button again, the result plot will also be 
    changed interactively. As the number of tests increases, you will notice
    that if you don't consider the multiplicity you will reject a null 
    hypothesis falsely more often. However, you will also notice that 
    several methods make it possible to avoid this kind of mistakes."),
  p("This application does not include any mathematical proofs or equations
    because this is just intended for novices to get some ideas. So, enjoy it!"),
  sidebarLayout(
    sidebarPanel(
      numericInput("var_num", "Number of tests : ", value = 10,
                   min = 2, step = 1),
      br(),
      radioButtons("correction", "Adjusting technique : ",
                         choices = list("Bonferroni" = "bonferroni",
                                        "Hommel" = "hommel",
                                        "Holm" = "holm",
                                        "Hochberg" = "hochberg",
                                        "Benjamini & Hochberg" = "BH",
                                        "Benjamini & Yekutieli" = "BY"),
                         selected = "bonferroni"),
      br(),
      submitButton("Submit")),    
    mainPanel(
      tabsetPanel(type = "tabs", 
                  tabPanel("Sample groups",
                           fluidRow("Group A", tableOutput("A")),
                           fluidRow("Group B", tableOutput("B"))),
                  tabPanel("Summary",
                           fluidRow("Group A", verbatimTextOutput("summary_A")),
                           fluidRow("Group B", verbatimTextOutput("summary_B"))),
                  tabPanel("Unadjusted p-values", plotOutput("unadj")),
                  tabPanel("Adjusted p-values", plotOutput("adj")))
                  )
    )
  )
)