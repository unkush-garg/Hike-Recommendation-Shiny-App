# CSX415 Final Project

Projects are due **before** the last section.

Much of the deliverables were completed during the course. If they were, you 
can simply move them from the assignments folder here.  Make sure that you 
respond to the feedback that was provided and correct any deficiencies that 
arose along the way. The master branch of your fork should contain the most 
current tested-and-working version of your code. 

The goal here is to that a sufficiently trained data scientist can checkout your
project and with a minimal amount of effort contribute to the project. It is a 
good idea to have someone else evaluate your code and provide a grade for your 
code.

Your project will be evaluated on the following.


# Requirements


Project must be: 
 - [ ] in the students `csx415-project` fork of github
 - [ ] follows a framework paradigm (e.g. *ProjectTemplate*)
 - [ ] It contains all assets: documents, code, data 
 
 - [ ] All documents need to be knitted and placed in the correct place. This 
   includes files that are necessary 
   - `reports/` in your *ProjectTemplate* folder).
 - [ ]All data in the correct place

 - [ ] has completed an anaylsis or trained a model 
   - [ ] The analysis is easily run. 
   - [ ] The evaluation is easily run.
   - [ ] The analysis was performed and the model was evaluated and assessed. An evaluation document was knited.
   
 - [ ] has incorporated the analysis or models into an R packages; 
   - [ ] R package is documented and has test code.
   
 - [ ] has created a deployable application of some type. 
   - [ ] completely encapsulated all dependcies using *packrat*
   - [ ] provides instructions for installing and running.
 
 
## Assets 

### Documents: 

 - [ ] `README.md` in the project root that gives the orientation of the 
   packages, with a brief introduction and explains how the project deviants
   from the presumed standards (e.g. ProjectTemplate). ( Hint: There shouldn't be
   much here. )
 - [ ] `deploy/README.md` for instructions on deploying your solution (install/run) (if applicable)
 - [ ] *Formal Problem Statement* (Assignment 1.)
 - [ ] *Model Performance Evaluation* generated from the Model Evaluation RMarkdown (Assignment: 2)
 - [ ] code documentation especially for packages in the correct place and format.


### Code

 - Model Training 

 - Seperate R packages for: model(s), scoring of model(s), deployment(optional) and general utilities (optional) 
   - [ ] DESCRIPTION file is complete and maintained 
     - [ ] version
     - [ ] date  
     - [ ] title 
     - [ ] description 
   - [ ] Tests and test data

 - The `deploy` directory should contain a fully encapsulated, working version of your solution
   - [ ] `deploy/README.md`
   - [ ] uses packrat to capture all dependencies.
   - [ ] test data if appropriate.

### Data: 

 - [ ] Data or code needed to perform the analysis.
 - [ ] test data for packages and 
