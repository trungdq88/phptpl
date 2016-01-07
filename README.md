phptpl
======

Static HTML template engine for template developer

Install
= 

    npm install -g phptpl

Start a project
=

    phptpl create example
    
Use your favorite PHP web server to preview.

Project Structure
=

    ▾ dist/
      ▸ css/
      ▸ js/
        index.html
    ▾ src/
      ▸ css/
      ▸ js/
        footer.inc.php
        header.inc.php
        index.php
      .tpl

**Rules**:
- Source files in `src` directory
- Generated HTML files in `dist` directory
- Source files with `.inc.php` in filename won't be generated to html.
- You can use all the php helpers function to help you build the template (ex. `for` loop, `if` `else` conditions, `include_once`, and more...)


Build the html files:
    
    phptpl build example

