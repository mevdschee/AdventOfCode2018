<?php
$input = trim(file_get_contents('input'));
$inputLen = strlen($input);

$recipes = str_repeat(' ', 1024*1024*1024);
$recipes[0] = '3';
$recipes[1] = '7';
$p1 = 0;
$p2 = 1;

$len = 2;
$done = false;
while (!$done) {
  $n1 = (int)$recipes[$p1];
  $n2 = (int)$recipes[$p2];
  $str = (string)($n1 + $n2);
  for($i=0; $i<strlen($str); $i++) {
    $recipes[$len] = $str[$i];
    $len++;
    if (substr($recipes,$len-$inputLen, $inputLen) == $input) {
      $done = true;
      break;
    }
  }
  $p1 = ($p1 + 1 + $n1) % $len;
  $p2 = ($p2 + 1 + $n2) % $len;
}

echo ($len - $inputLen)."\n";