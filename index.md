---
layout: lesson
root: .  # Is the only page that doesn't follow the pattern /:path/index.html
permalink: index.html  # Is the only page that doesn't follow the pattern /:path/index.html
---

{% include gh_variables.html %}

## Instructor
{% for instructor in site.data.syllabus.instructors %}
{{ instructor.bio }}
{% endfor %}

> ## Prerequisites
> Students should have taken Informatics Pre-Session and Data Engineering 1.
> 
{: .prereq}

{% include links.md %}
