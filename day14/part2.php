<?php
$input = trim(file_get_contents('input.test2'));
$inputLen = strlen($input);

$recipes = str_repeat(' ', 1024*1024*1024);
$recipes[0] = '3';
$recipes[1] = '7';
$p1 = 0;
$p2 = 1;

$pos = 2;
$done = false;
while (!$done) {
  $n1 = (int)$recipes[$p1];
  $n2 = (int)$recipes[$p2];
  $sum = (string)($n1 + $n2);
  for($i=0; $i<strlen($sum); $i++) {
    $recipes[$pos] = $sum[$i];
    $pos++;
    if (substr($recipes,$pos-$inputLen, $inputLen) == $input) {
      $done = true;
      break;
    }
  }
  $p1 = ($p1 + 1 + $n1) % $pos;
  $p2 = ($p2 + 1 + $n2) % $pos;
}

echo ($pos - $inputLen)."\n";