var fs = require('fs')
 
let input = String(fs.readFileSync('input')).trim().split('')
for (var i = 0; i < input.length; i++) {
    input[i] = input[i].charCodeAt(0)-'0'.charCodeAt(0)
}

let recipes = [3, 7]
let p1 = 0
let p2 = 1

let done = false
while (!done) {
  let n1 = recipes[p1]
  let n2 = recipes[p2]
  let sum = n1 + n2
  if (sum<10) {
    num = [sum]
  } else {
    num = [1, sum-10]
  }
  for (let i = 0; i < num.length; i++) {
    recipes.push(num[i])
    for (var j = 0; j<input.length; j++) {
        if (recipes[recipes.length-1-j]!=input[input.length-1-j]) {
            break
        }
    }
    if (j==input.length) {
        done = true
        break
    }
  }
  p1 = (p1 + 1 + n1) % recipes.length
  p2 = (p2 + 1 + n2) % recipes.length
}
console.log(recipes.length - input.length)