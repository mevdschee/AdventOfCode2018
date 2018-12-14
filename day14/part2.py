input = bytearray(open('input').read().strip(),'UTF-8')
inputLen = len(input)

recipes = bytearray(b' '*1024*1024*1024)
recipes[0] = ord('3')
recipes[1] = ord('7')
p1 = 0
p2 = 1

pos = 2
done = False
while (not done):
  n1 = int(recipes[p1]-ord('0'))
  n2 = int(recipes[p2]-ord('0'))
  sum = str(n1 + n2)
  for n in sum:
    recipes[pos] = ord(n)
    pos+=1
    if (recipes[pos-inputLen:pos] == input):
      done = True
      break
  p1 = (p1 + 1 + n1) % pos
  p2 = (p2 + 1 + n2) % pos

print(pos - inputLen)