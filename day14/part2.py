input = bytearray(open('input').read().strip(),'UTF-8')

recipes = bytearray(b'37')
p1 = 0
p2 = 1

done = False
while (not done):
  n1 = recipes[p1]-ord('0')
  n2 = recipes[p2]-ord('0')
  for n in str(n1 + n2):
    recipes.append(ord(n))
    if (recipes[-len(input):] == input):
      done = True
      break
  p1 = (p1 + 1 + n1) % len(recipes)
  p2 = (p2 + 1 + n2) % len(recipes)

print(len(recipes) - len(input))