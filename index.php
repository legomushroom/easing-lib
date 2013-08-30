<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>Document</title>
    <link rel="stylesheet" type="text/css" href="css/main.css">
  </head>
  <body>
    <div id="target"></div><?php foreach (glob("templates/*.php") as $filename){ include $filename; } ?>
    <script type="text/javascript" data-main="js/main" src="js/lib/require.js"></script>
  </body>
</html>