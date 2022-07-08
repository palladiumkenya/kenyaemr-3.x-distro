
# kenyaemr-3.x-distro (WIP)
 > This project is inspired by the new OpenMRS reference application packaging [here](https://github.com/openmrs/openmrs-distro-referenceapplication/tree/3.x)

## Pre-requisites
  - Install and configure tomcat server
  - MySQL Server

## Quick Start
Package kenyaemr distribution by running the following command:

```
mvn clean package
```

Then prepare the final package by running the following command:

```
sh prepare.sh
```
The output package has the following folder structure:

```
|------------------------
+-- _configuration
|   +-- _ampathforms
|   +----- cervical_screening Forme
|   +----- HIV Enrollment Form
+-- _frontend
|   +-- _openmrs-esm-active-visits
|   +---- index.html
+-- _modules
|   +-- idgen-4.6.0.omod
|   +-- fhir2-1.4.0
+-- _webapps
|   +-- openmrs.war
+-- setup.sh
+-- instructions.pdf
|--------------------
```

## Notes
