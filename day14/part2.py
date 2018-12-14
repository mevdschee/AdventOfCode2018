input = open('input').read().strip()
inputLen = len(input)

recipes = bytearray(b' '*1024*1024*1024)
recipes[0] = b'3'
recipes[1] = b'7'
p1 = 0
p2 = 1

pos = 2
done = False
while (not done):
  n1 = int(recipes[p1]-ord('0'))
  n2 = int(recipes[p2]-ord('0'))
  sum = n1 + n2
  if sum<10:
    num = chr(sum+ord('0'))
  else:
    num = chr(sum/10+ord('0'))+chr(sum%10+ord('0'))
  for n in num:
    recipes[pos] = n
    pos+=1
    if (recipes[pos-inputLen:pos] == input):
      done = True
      break
  p1 = (p1 + 1 + n1) % pos
  p2 = (p2 + 1 + n2) % pos

print pos - inputLen