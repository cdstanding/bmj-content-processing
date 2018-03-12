# bmj-content-processing
This is a repository for BMJ content processing. It includes BMJ, Careers and Student production and publication processes.

Production and publication code mainly uses ANT builds and vuses a variety of different extensions and programs as part of the validation, transformation, PDF creation, image conversion and interaction with APIs. The ANT builds are initiated by a windows batch file which is either launched from a SendTo on the users desktop or run on a shedule, depending on the nature of that process.

The processes depend upon the following:

- apache-ant-1.9.4 for build pipelines
- Curl for API interacion
- Ghostscript for PDF creation
- ImageMagick-7.0.3-Q16 for image conversion
- Java 1.8.0_40 for ANT
- RenderX XEP for as an XSL-FO engine
- Saxon 8.0 (located in the ANT lib) for XSLT trsnaformations and Schematron validation

...



