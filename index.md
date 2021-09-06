---
layout: lesson
root: .  # Is the only page that doesn't follow the pattern /:path/index.html
permalink: index.html  # Is the only page that doesn't follow the pattern /:path/index.html
---

{% include gh_variables.html %}

## Instructors
{% for instructor in site.data.syllabus.instructors %}
{{ instructor.bio }}
{% endfor %}

## Contributors
{% for contributors in site.data.syllabus.contributors %}
{{ contributors.bio }}
{% endfor %}

> ## Prerequisites
> Students should take ECBS5154 - Mathematics and Informatics Pre-session for Business Analytics
> 
{: .prereq}

{% include links.md %}

