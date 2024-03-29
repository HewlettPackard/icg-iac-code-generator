# ICG: Infrastuctural Code Generator

This repository contains all the required code and templates to run the ICG component, it also contains a Dockerfile that builds the complete image of the ICG with a provided REST API

What is ICG?
-------------
- ICG can be seen as a DOML compiler that generates executable IaC code
  - Input: DOML (DevOps Modeling Language), is a high level language that allows to model infrastructure
  - Output: IaC (Infrastructure as Code, e.g. Terraform)
- ICG is a tool for low-code/no-code IaC development
- ICG is not an HPE product, it’s a research prototype created by HPE in the context of an EU funded research project (PIACERE)

How does ICG work?
-------------
- User creates a model, written in DOML, representing the desired infrastructure
- ICG parser extracts from DOML the information needed, creating an Intermediate Representation
- One or more plugins generate the target IaC code
![ICG how does it work](https://github.com/HewlettPackard/icg-iac-code-generator/assets/9378908/8826ca3e-db51-4c22-b43d-8d3f708c4248)


Benefits
-------------
- **IaC Benefits**
  - Lower DevOps costs
  - Shorter delivery times
  - Automation and Repeatability
    - Enables the automation of manual tasks
    - Each IaC code execution creates the desired infrastructure
- **ICG benefits**
  - Generates IaC code to automate provisioning, deployment and configuration
  - Low-code/No-code: creates IaC code with low or even no IaC code expertise
  - Overcomes the difficulty in hiring/retaining expert IaC developers
  - GitOps ready: DOML models can be versioned and ICG can be used in CI/CD pipelines
  - Expertise from master IaC developers can be captured into templates and reused many times
  - Extensibility allows this solution to fit multiple problems

ICG internal architecture
-------------
- ICG code generation is based on templates
- ICG architecture is based on plug-ins
- ICG internal architecture:
![image](https://github.com/HewlettPackard/icg-iac-code-generator/assets/9378908/787db7be-2053-44cd-a0be-d0f880fabc7d)

ICG usage and extensibility
-------------
- ICG can be used as a command line tool
- ICG can be run as a container and used through its REST interface
- ICG is extensible, support can be added for
  - Additional primitives
  - New target platform
  - New target IaC language
  - New modelling languages

Requirements
-------------
- Docker

Installation 
-------------

To have a functional ICG application the following steps can be used.

- Download the full content of this repository, there are git submodules, so add them using this command: `git submodule update --init --recursive`
- Build the docker image launching the following command: `docker build -t icg:1.0.0 .` 
- Run the container: `docker run --name icg -d -p 5000:5000 icg:1.0.0`
 
Usage
------------

To use the now running ICG docker container we can call the available REST API.

The API is available at http://localhost:5000/docs. You can try here the endpoint behavior:

- POST /infrastructure/files generates iac compress folder from json intermediate representation (see input_file_example/nginx/parameters.json as an example body).
- POST /iac/files generates iac compress folder from doml model (ex. nginx-openstack_v2.domlx)

Otherwise, send a POST request at this endpoint with the indicated json body (see input_file_example/nginx/parameters.json as an example body) it will respond with a .tar.gz file containing all the required IaC files:

    - curl --location --request POST localhost:5000/infrastructure/files --header "Content-Type: application/json" --data "@parameters.json" --output "OutputIaC.tar.gz"

Uninstall
------------
Remove the docker container and the docker image:

```
docker container rm -f icg
docker rmi icg:0.1
```

Usage from command line
------------
Usage: python main.py [-h] [-d dir] model
- -h  prints usage
- -d dir loads metamodel from \<dir>
- --single or --single_mmodel   use the single (non-split) metamodel
- model  the model to be loaded
` py .\main.py -d <doml_folder> --single <metamodel_file_path>`

Example:

` py .\main.py -d icgparser/doml --single icgparser/doml/nginx-openstack_v2.domlx`

Folders Structure
------------
- _output_file_example_: in this folder there is the output of the ICG tested for the examples considered during the PIACERE interations. The output files are tested and represents how the ICG output should be.
- _output_files_generated_: in this folder there is the output generated by the execution of the ICG 
- _input_file_example_: in this folder there is an example of how the ICG intermediate representation should be for the examples considered during the PIACERE interations
- _input_file_generated_: in this folder there is the intermediate representation generated by the execution of the ICG
