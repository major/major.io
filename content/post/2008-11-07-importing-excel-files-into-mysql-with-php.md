---
title: Importing Excel files into MySQL with PHP
author: Major Hayden
type: post
date: 2008-11-07T19:42:45+00:00
url: /2008/11/07/importing-excel-files-into-mysql-with-php/
dsq_thread_id:
  - 3642805368
categories:
  - Blog Posts
tags:
  - mysql
  - php

---
If you have Excel files that need to be imported into MySQL, you can import them easily with PHP. First, you will need to download some prerequisites:

PHPExcelReader - <http://sourceforge.net/projects/phpexcelreader/>

Spreadsheet\_Excel\_Writer - [http://pear.php.net/package/Spreadsheet\_Excel\_Writer][1]

Once you've downloaded both items, upload them to your server. Your directory listing on your server should have two directories: `Excel` _(from PHPExcelReader)_ and `Spreadsheet_Excel_Writer-x.x.x` _(from Spreadsheet\_Excel\_Writer)_. To work around a bug in PHPExcelReader, copy `oleread.inc` from the `Excel` directory into a new path:

`Spreadsheet/Excel/Reader/OLERead.php`

The PHPExcelReader code will expect `OLERead.php` to be in that specific location. Once that is complete, you're ready to use the PHPExcelReader class. I made an example Excel spreadsheet like this:

<pre>Name                Extension   Email
----------------------------------------------------
Jon Smith           2001        jsmith@domain.com
Clint Jones         2002        cjones@domain.com
Frank Peterson      2003        fpeterson@domain.com</pre>

After that, I created a PHP script to pick up the data and insert it into the database, row by row:

```
require_once 'Excel/reader.php';
$data = new Spreadsheet_Excel_Reader();
$data->setOutputEncoding('CP1251');
$data->read('exceltestsheet.xls');

$conn = mysql_connect("hostname","username","password");
mysql_select_db("database",$conn);

for ($x = 2; $x &lt; = count($data->sheets[0]["cells"]); $x++) {
    $name = $data->sheets[0]["cells"][$x][1];
    $extension = $data->sheets[0]["cells"][$x][2];
    $email = $data->sheets[0]["cells"][$x][3];
    $sql = "INSERT INTO mytable (name,extension,email)
        VALUES ('$name',$extension,'$email')";
    echo $sql."\n";
    mysql_query($sql);
}
```


After the script ran, each row had been added to the database table successfully. If you have additional columns to insert, just repeat these lines, using an appropriate variable for each column:

```
sheets[0]["cells"][$row_number][$column_number];
```


For more details, you can refer to a [post in Zend's Developer Zone][2].

 [1]: http://pear.php.net/package/Spreadsheet_Excel_Writer
 [2]: http://devzone.zend.com/article/3336-Reading-and-Writing-Spreadsheets-with-PHP
