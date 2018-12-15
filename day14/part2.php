<?php
$input = trim(file_get_contents('input'));

$recipes = '37';
$p1 = 0;
$p2 = 1;

$done = false;
while (!$done) {
  $n1 = (int)$recipes[$p1];
  $n2 = (int)$recipes[$p2];
  $sum = (string)($n1 + $n2);
  for($i=0; $i<strlen($sum); $i++) {
    $recipes .= $sum[$i];
    if (substr($recipes,-strlen($input), strlen($input)) == $input) {
      $done = true;
      break;
    }
  }
  $p1 = ($p1 + 1 + $n1) % strlen($recipes);
  $p2 = ($p2 + 1 + $n2) % strlen($recipes);
}

echo (strlen($recipes) - strlen($input))."\n";