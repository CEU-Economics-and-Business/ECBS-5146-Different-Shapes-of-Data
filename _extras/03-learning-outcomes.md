---
title: Grading Rubric
topics: ["Architecture", "Modeling", "Structures", "Serialization", "Quality", "Integration"]
---

## Learning outcomes
With your data product, demonstrate as many of the following learning outcomes as possible. 

{% for topic in page.topics %}
<blockquote class="callout">
  <h2>Data {{ topic }}</h2>
  <ol>
  {% for row in site.data.rubric %}
    {% if row.topic == topic %}
        <li>{{ row.outcome }}</li>
    {% endif %}
  {% endfor %}
  </ol>
</blockquote>
{% endfor %}

## Grading rubric

|-------|-------------------------|--------------------------|
| Grade | Minimum from each topic | Total number of outcomes |
|-------|-------------------------|--------------------------|
| A  | 2 | 16 |
| A- | 2 | 14 |
| B+ | 1 | 12 |
| B  | 1 | 10 |
| B- | 1 | 7 |
| C+ |  not all demonstrated |  6 |

## Example combinations of outcomes demonstrated

> ### An "A" project
> 1. Separate important from unimportant features.
> 2. Represent a mental model visually.
> 3. Create diagrams with Mermaid or other tool.
> 4. Create concept map of data products.
> 5. Create logical model for simple relational data and represent it with Entity-Relation Diagrams.
> 6. Understand and apply normal forms 1-3 to simple relational data.
> 7. Model many-to-one relationships.
> 8. Express the algorithmic complexity of simple algorithms.
> 9. Understand Big-O notation.
> 10. Understand character encodings and Unicode points.
> 11. Load and save text file with different character encodings.
> 12. Use string functions in OpenRefine or other tool to normalize text data.
> 13. Use OpenRefine or other tool to split and reshape data.
> 14. Use simple regular expressions to exract numerical information from textual data.
> 15. Use wget, curl or other programmatic tool to download data from the web.
> 16. Use for loops to automate data transformations.
> 17. Create a Data Package to share data and metadata together.
>
> All topics include at least 2 outcomes, and the total number of outcomes is 17.
{: .callout}

> ### A "B" project
> 1. Represent a mental model visually.
> 2. Create diagrams with Mermaid or other tool.
> 3. Create concept map of data products.
> 4. Create logical model for simple relational data and represent it with Entity-Relation Diagrams.
> 5. Model many-to-one relationships.
> 6. Understand Big-O notation.
> 7. Understand character encodings and Unicode points.
> 8. Use string functions in OpenRefine or other tool to normalize text data.
> 9. Use OpenRefine or other tool to split and reshape data.
> 10. Create a Data Package to share data and metadata together.
>
> There is only one outcome for "Data Structures" and "Data Integration." You can improve to B+ by demonstrating your understanding of "many-to-many relationships" _and_ JSON, for example. To further improve to A-, you would need more work in Data Integration (for example, using `wget`) _and_ in Data Structures (for example, discussing the complexity of data matching in your report).
{: .callout}

{% include links.md %}
