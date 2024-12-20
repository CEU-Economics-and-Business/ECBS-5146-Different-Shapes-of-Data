---
title: Knime.
teaching: 90
questions:
- How the data science landscape looks like in regard to tools?
- How to implement an end-to-end data analytics workflow integrated with multiple sources?
- How to do rapid prototype a data analytics workflow with low code tools, opposed to using a programing language (R,Python etc)?

objectives:
- Introducing KNIME as data analytics tool
- Basic exercises with KNIME
- End-to-end (from data acquisition to visualization) practice exercise

keypoints:
- \#DATA SCIENCE BY GARTNER
- \#KNIME 
- \#EUROSTAT WORKFLOW
- \#CLIMATE WORKFLOW

---




<br/><br/>


> ## Prerequisites for this chapter
>**Installing KNIME Analytics Platform**  
>* Download KNIME for (Window/Linux/Mac) from: [https://www.knime.com/downloads/download-knime](https://www.knime.com/downloads/download-knime)
>* Please make sure the installation is valid and the application starts properly!
>* Play around with the UI and review the [Getting Started Guide]([https://www.knime.com/downloads/download-knime](https://www.knime.com/getting-started-guide)) 
{: .prereq} 




## Introducing KNIME

#### Why KNIME? 


![Gartner]({{ page.root }}/artifacts/knime/gartner.png)

[Data Science and ML Platforms (Gartner 2019)](https://www.kdnuggets.com/2019/02/gartner-2019-mq-data-science-machine-learning-changes.html)

<br/>

[Data Science and ML Platforms (Gartner 2024)](https://azure.microsoft.com/en-us/blog/microsoft-is-a-leader-in-the-2024-gartner-magic-quadrant-for-data-science-and-machine-learning-platforms/)


<br/>

#### KNIME Ecosystem
[Picture](https://github.com/salacika/DE2DSD/tree/main/knime/pictures/Picture3.png)

<br/>

#### KNIME Nodes Classification 
[Picture](https://github.com/salacika/DE2DSD/tree/main/knime/pictures/Picture2.png)


<br/>

>## End-to-end example
> [Source file (fips.csv)]({{ page.root }}/artifacts/knime/fips.csv)
>
>We will be using the NOAA CDO API (see [Chapter 7](https://ceu-economics-and-business.github.io/ECBS-5146-Different-Shapes-of-Data/08-dsd/index.html#noaa))
>
> [Final KNIME Workflow]({{ page.root }}/artifacts/knime/w24.knwf)
>
{: .challenge}

![wind]({{ page.root }}/artifacts/knime/wind.png)

[Result on sample of 999 records]({{ page.root }}/artifacts/knime/result.png)

<br/><br/>

