
#The vector that is properly formatted to be passed to the writer
gfr <- '---\ntitle: "DA5020.Huessy.A5"\nauthor: "James Huessy"\ndate: "June 7, 2018"\noutput: pdf_document\n---\n```{r setup, include=FALSE}\nknitr::opts_chunk$set(echo = TRUE)\n```\nThis weeks assignment is about tidying up the structure of data collected by the US census. Load the Unemployment and Educational data files into R studio. One file contains yearly unemployment rates from 1970 to 2015, for counties in the US. The other file contains aggregated data percentages on the highest level of education achieved for each census member. \nThe levels of education are: "less than a high school diploma", "high school diploma awarded", "attended some college", "college graduate and beyond". The census tracks the information at the county level and uses a "fips" number to represent a specific county within a U.S. state. The fips number is a 5 digit number where the first two digits of the fips number represents a U.S. state, while the last three digits represent a specific county within that state.\n\n\n###This should be a new thing\n\nAnother two lines!\n\n###Then again!'


#writes the text to a .Rmd file
write(gfr, 'D:/Users/James/Documents/Northeastern/Grad/test.Rmd')

#Then I will need to knit it from where I saved it to a different, "final" location


tev <- "Johnny Coder
============

----

>  In this style, the resume starts with a blockquote, where
>  you can briefly list your specialties, or include a salient
>  quote. Ending a line with a backslash forces a line break.

----

Education
---------

2010-2014 (expected)
:   **PhD, Computer Science**; Awesome University (MyTown)

*Thesis title: Deep Learning Approaches to the Self-Awesomeness
Estimation Problem*

2007-2010
:   **BSc, Computer Science and Electrical Engineering**; University of
HomeTown (HomeTown)

*Minor: Awesomeology*

Experience
----------

**Your Most Recent Work Experience:**

Short text containing the type of work done, results obtained,
lessons learned and other remarks. Can also include lists and
links:

* First item

* Item with [link](http://www.example.com). Links will work both in
the html and pdf versions.

**That Other Job You Had**

Also with a short description.

Technical Experience
--------------------

My Cool Side Project
:   For items which don't have a clear time ordering, a definition
list can be used to have named items.

* These items can also contain lists, but you need to mind the
indentation levels in the markdown source.
* Second item.

Open Source
:   List open source contributions here, perhaps placing emphasis on
the project names, for example the **Linux Kernel**, where you
implemented multithreading over a long weekend, or **node.js**
(with [link](http://nodejs.org)) which was actually totally
your idea...

Programming Languages
:   **first-lang:** Here, we have an itemization, where we only want
to add descriptions to the first few items, but still want to
mention some others together at the end. A format that works well
here is a description list where the first few items have their
first word emphasized, and the last item contains the final few
emphasized terms. Notice the reasonably nice page break in the pdf
version, which wouldn't happen if we generated the pdf via html.

:   **second-lang:** Description of your experience with second-lang,
    perhaps again including a [link] [ref], this time placing the url
    reference elsewhere in the document to reduce clutter (see source
    file). 

:   **obscure-but-impressive-lang:** We both know this one's pushing
it.

:   Basic knowledge of **C**, **x86 assembly**, **forth**, **Common Lisp**

[ref]: https://github.com/githubuser/superlongprojectname

Extra Section, Call it Whatever You Want
----------------------------------------

* Human Languages:

* English (native speaker)
* ???
* This is what a nested list looks like.

* Random tidbit

* Other sort of impressive-sounding thing you did

----

> <email@example.com> . +00 (0)00 000 0000 . XX years old\
> address - Mytown, Mycountry"

write(tev, 'D:/Users/James/Documents/Northeastern/Grad/test.Rmd')




######## INDEED SCRAPER!!!! ################
library(tidyverse)
library(httr)
library(XML)
library(RCurl)
library(xml2)
library(magrittr)
library(rvest)

#load search url results
s.list <- read_html("https://www.indeed.com/jobs?q=R+Analyst&l=02130&radius=10") %>%
  html_node("body") %>%
  html_node("td#resultsCol") %>%
  html_nodes("div.result") 



##pull out jk=... url suffix for each listing

#dummy dataframe because why not
suf.list <- list()
for (i in 1:length(s.list)){
  df <- as.character(s.list[i]) %>%
    #split at data-jk because the following string is the url prefix
    str_split('data-jk') %>%
    #select the first part of the list generated
    extract2(1) %>%
    #select the second part of the first part of the list generated
    extract(2) %>%
    #splitting the extracted string at the point after the jk- string
    str_split('" data') %>%
    #again, extracting the first part of the list
    extract2(1) %>%
    #extracting the first part of the first part of the list
    extract(1) %>%
    #gsub out the \, it needs the braces apparently and the period to represent where it sends the vector
    {gsub('\"', "", .)} %>%
    {paste("https://www.indeed.com/viewjob?jk", ., sep = "")}
  suf.list <- rbind(suf.list, df)
}

#picking through a listing and finding all the parts I need:
#-Title
#-Company
#-Location [town, state]
#-Body
#--EXPLORE! Figure out what common sections are called or what keywords I should be 

#listing body seems to come in seperate divs for each paragraph. This may change the number of divs per table, but it's all here
jobsdat <- data.frame("Link"= as.character(), "Body" = as.character())

for (i in 1:length(suf.list)){
p2 <- read_html(as.character(suf.list[i])) %>%
  html_nodes("table") %>%
  html_node(xpath = '//*[@id="job-content"]') %>%
  html_node("span#job_summary") %>%
 # html_nodes("div") %>%
  html_text() %>%
  #str_split("\\n") %>%
  unlist() %>%
  unique() %>%
  paste(collapse = "\n")
#cat(p2)
#}
fbn <- data.frame("Link"= as.character(suf.list[i]), "Body" = p2)

jobsdat <- rbind(jobsdat, fbn)
}

jobsdat

as.character(p2[2])






