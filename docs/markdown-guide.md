## Markdown Guide

#### Headings

```
# The largest heading
## The second largest heading
###### The smallest heading
```
![](https://docs.github.com/assets/cb-8119/images/help/writing/headings-rendered.png)


#### Styling text

Style                  | Syntax             | Example                                  | Output
---                    | ---                | ---                                      | ---
Bold                   | `** **` or `__ __` | `**this is bold text**`                  | **this is bold text** 
Italic                 | `* *` or `_ _`     | `*this text is italicized*`              | *this text is italicized*
Strikethrought         | `~~ ~~`            | `~~This was mistaken text~~`             | ~~This was mistaken text~~ 
Bold and netest italic | `** **` and `_ _`  | `**This text is _extremely_ important**` | **This text is _extremely_ important**
All bold and italic    | `*** ***`          | `***All this text is important***`       | ***All this text is important***

#### Quoting text

```
Text that is not a quote

> Text that is a quote
```
![](https://docs.github.com/assets/cb-12198/images/help/writing/quoted-text-rendered.png)

#### Quoting code

````
Some basic Git commands are:
```
git status
git add
git commit
```
````
![](https://docs.github.com/assets/cb-4274/images/help/writing/code-block-rendered.png)

#### Links

```
This site was built using [GitHub Pages](https://pages.github.com/).
```
![](https://docs.github.com/assets/cb-4329/images/help/writing/link-rendered.png)

#### Section links
![](https://docs.github.com/assets/cb-25655/images/help/repository/readme-links.png)


#### Relative links
````
[Markdown Guide](./markdown-guide.md)
```
[Markdown Guide](./markdown-guide.md)

````

#### Images
```
![This is an image](https://myoctocat.com/assets/images/base-octocat.svg)
```
![This is an image](https://myoctocat.com/assets/images/base-octocat.svg)

Context                          | Relative Link
---                              | ---
In a .md file on the same branch | /assets/images/electrocat.png
In a .md file on another branch  | /../main/assets/images/electrocat.png
In issues, pull requests and comments of the repository     | ../blob/main/assets/images/electrocat.png
In a .md file in another repository                         | /../../../../github/docs/blob/main/assets/images/electrocat.png
In issues, pull requests and comments of another repository | ../../../github/docs/blob/main/assets/images/electrocat.png?raw=true


#### Lists
```
- George Washington
- John Adams
- Thomas Jefferson
```
![](https://docs.github.com/assets/cb-3302/images/help/writing/unordered-list-rendered.png)

```
1. James Madison
2. James Monroe
3. John Quincy Adams
```
![](https://docs.github.com/assets/cb-3403/images/help/writing/ordered-list-rendered.png)

```
1. First list item
   - First nested list item
     - Second nested list item
```
![](https://docs.github.com/assets/cb-5185/images/help/writing/nested-list-alignment.png)
![](https://docs.github.com/assets/cb-3697/images/help/writing/nested-list-example-1.png)


```
100. First list item
     - First nested list item
       - Second nested list item
```
![](https://docs.github.com/assets/cb-3655/images/help/writing/nested-list-example-2.png)

For more examples, see the [GitHub Flavored Markdown Spec](https://github.github.com/gfm/#example-265)

#### Task lists
```
- [x] #739
- [ ] https://github.com/octo-org/octo-repo/issues/740
- [ ] Add delight to the experience when all tasks are complete :tada:
```
![](https://docs.github.com/assets/cb-64632/images/help/writing/task-list-rendered-simple.png)

If a task list item description begins with a parenthesis, you'll need to escape it with `\`:
```
- [ ] \(Optional) Open a followup issue
```

#### Footnotes

```
Here is a simple footnote[^1].

A footnote can also have multiple lines[^2].

You can also use words, to fit your writing style more closely[^note].

[^1]: My reference.
[^2]: Every new line should be prefixed with 2 spaces.
  This allows you to have a footnote with multiple lines.
[^note]:
    Named footnotes will still render with numbers instead of the text but allow easier identification and linking.
    This footnote also has been made with a different syntax using 4 spaces for new lines.
```
![](https://docs.github.com/assets/cb-6345/images/site/rendered-footnote.png)

#### Hiding content with comments
```
<!-- This content will not appear in the rendered Markdown -->
```

#### Ignoring Markdown formatting
```
Let's rename \*our-new-project\* to \*our-old-project\*.
```
![](https://docs.github.com/assets/cb-2978/images/help/writing/escaped-character-rendered.png)


#### Table
```
| Left-aligned | Center-aligned | Right-aligned |
| :---         |     :---:      |          ---: |
| git status   | git status     | git status    |
| git diff     | git diff       | git diff      |
```
![](https://docs.github.com/assets/cb-7653/images/help/writing/table-aligned-text-rendered.png)

#### Collapsed sections

````
<details><summary>CLICK ME</summary>
<p>

#### We can hide anything, even code!

    ```ruby
      puts "Hello World"
    ```

</p>
</details>
````

The Markdown will be collapsed by default.

![](https://docs.github.com/assets/cb-1612/images/help/writing/collapsed-section-view.png)

After a reader clicks <svg version="1.1" width="16" height="16" viewBox="0 0 16 16" class="octicon octicon-triangle-right" aria-label="The right triange icon" role="img"><path d="M6.427 4.427l3.396 3.396a.25.25 0 010 .354l-3.396 3.396A.25.25 0 016 11.396V4.604a.25.25 0 01.427-.177z"></path></svg>, the details are expanded.

![](https://docs.github.com/assets/cb-10711/images/help/writing/open-collapsed-section.png)

#### Code blocks

###### Fenced code blocks

```
function test() {
  console.log("notice the blank line before this function?");
}
```
![](https://docs.github.com/assets/cb-5169/images/help/writing/fenced-code-block-rendered.png)

<pre>
````
```
Look! You can see my backticks.
```
````
</pre>
![](https://docs.github.com/assets/cb-994/images/help/writing/fenced-code-show-backticks-rendered.png)


###### Syntax highlighting
````
```ruby
require 'redcarpet'
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html
```
````
![](https://docs.github.com/assets/cb-7457/images/help/writing/code-block-syntax-highlighting-rendered.png)

#### Auto linked references
```
Visit https://github.com
```
![](https://docs.github.com/assets/cb-3288/images/help/writing/url-autolink-rendered.png)

For more examples, see the [autolinked references and urls](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/autolinked-references-and-urls)


## Further reading
- https://github.github.com/gfm/
- https://docs.github.com/en/articles/about-writing-and-formatting-on-github
- https://docs.github.com/en/articles/basic-writing-and-formatting-syntax
- https://docs.github.com/en/articles/working-with-advanced-formatting
