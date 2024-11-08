# Antimicrobial resistance dashboard

This is a version of a resiatance dashboard that we use locally to view resistance patterns for isolates over the last year.

A version of the finished product with dummy data can be found here:
https://jackwgoodall.github.io/Resistance_dashboard/

Cloning this repository and running the run_project.R file will generate an html and should give you a pretty good idea of how it works.  I have tried to leave clear instructions throught the script as to how everything works.

The project generates an R Markdown html using the amazing [flexdashboard R package](https://pkgs.rstudio.com/flexdashboard/).  

We have lots of tabs for different sample types but I have simplified it here to just show two: one of everything and another of urines to show how subsections (e.g. inpatient vs outpatient) is possible). 

There is a fair amount of custom javascript that has been added to the markdown that you shouldn't have to worry too much about when recreating.  This lets you scroll through long tables (<div id="scrollable">) and sets up the side drop down nicely (removeAllOption).

The key feature of this is that it is a static html.  This means it can be hosted locally (e.g. on your antimicobial intranet page), sent my email or just stored in a folder. 
Doing this whilst having interactive elements is a ***real pain***.  I am very grateful to a [blog post](https://www.erikigelstrom.com/articles/interactive-dashboards-in-r-without-shiny/) by Erik Igelström which solved quite a few of the problems I was facing.  I've leaned heavily on his ideas for some of the interactive elements and would suggest reading his blogpost before starting to try and localise. 

## Localising

The key challenge to localising this will be either getting your data into the same format as ours, or tweaking the code to accept your formatting.  The former is probably easier.

### SQL

Like many large hosptials our data is stored in a SQL server.  I would strongly suggest using a SQL package to download the data directly into R if you are able to.
We do this with the [odbc](https://github.com/r-dbi/odbc) SQL package. 

### Table formats 

Our input data looks like this:

| DTC   | Organism | OrgDescrip       | Antibiotic      | Sensitivity | Location_Code | ID | SpecNo   | Hospital_No   |
|-------|----------|------------------|-----------------|-------------|---------------|----|----------| ------------- |
| 01/01/2024    | ESCO     | Escherichia coli | Amp/amoxicillin | R           | GP            | 1  | MU00001  | MU00001       |

**Here:**
DTC = date collected <br>
Organism = the EUCAST organism code <br>
OrgDescription = human readable version of the organism <br> 
Location_Code = this is the code of the location it has come from (there are lots of these but I have simplified to GP / inpatient for the dummy data) <br>
ID = is the organism ID *in that sample*.  I.e. if there is a Klebsiella and a Pseudomonas in a urine sample one will get ID 1 and one ID 2. <br>

Please do feel free to ask questions on this page and to suggest improvements and refinments. 

