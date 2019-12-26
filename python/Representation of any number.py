import struct
import math

#перевод десятичного числа в битовую строку
def NumberToBits(n):    
    #запись в файл
    floats = [n]
    s = struct.pack('f'*len(floats), *floats)
    f = open('filename', 'wb')
    f.write(s)
    f.close()

    #чтение из файла
    arr = []
    f = open('filename', 'rb')
    for i in range(4):
        arr.append(f.read(1))

    #преобразование в массив символов в двоичном виде
    d = []
    for i in range(4):
        d.append(bin(int.from_bytes(arr[i], byteorder='little')))
        d[i] = d[i][2:].zfill(8)
    f.close()

    #конкантенация символов в одну строку
    string = ''
    for i in range(4):
        for j in range(8):
            string = string + d[3 - i][j]

    return(string)

#перевод битовой строки в десятичное число
def BitsToNumber(st):  
    #перевод двоичной строки в число по стандарту IEEE 754
    s = int(st[0])
    e = int(st[1:9], 2)
    m = int(st[9:], 2)
    if (e == 255):
        if (m == 0):
            if (s == 0):
                return float('inf')
            else:
                return float('-inf')
        else:
            if (s == 0):
                return float('nan')
            else:
                return float('-nan')
    else:
        if (e == 0):
            #субнормальное число
            return (-1)**s * 2**(e-2**7 + 2) * m / 2**23
        else:
            #нормальное число
            return (-1)**s * 2**(e-2**7 + 1) * (1 + m / 2**23)

#перевод битовой строки в число с помощью встроенных функций
def BitsToNumberIn(st):
    return struct.unpack('!f',struct.pack('!I', int(st, 2)))[0]

#примеры

#нормальные числа
a1 = 3.4
b1 = NumberToBits(a1)
print(a1, ' -> ', NumberToBits(a1))
print(b1, ' -> ', BitsToNumber(b1))
print(b1, ' -> ', BitsToNumberIn(b1))
print()

#положительный nan (python не делает различий)
a2 = float('nan')
b2 = '01111111101000000000000000000000'
print(a2, ' -> ', NumberToBits(a2))
print(b2, ' -> ', BitsToNumber(b2))
print(b2, ' -> ', BitsToNumberIn(b2))
print()

#отрицательный nan (python не делает различий)
a3 = float('nan')
b3 = '11111111101000000000000000000000'
print(a3, ' -> ', NumberToBits(a3))
print(b3, ' -> ', BitsToNumber(b3))
print(b3, ' -> ', BitsToNumberIn(b3))
print()

#положительная бесконечность
a4 = float('inf')
b4 = '01111111100000000000000000000000'
print(a4, ' -> ', NumberToBits(a4))
print(b4, ' -> ', BitsToNumber(b4))
print(b4, ' -> ', BitsToNumberIn(b4))
print()

#отрицательная бесконечность
a5 = float('-inf')
b5 = '11111111100000000000000000000000'
print(a5, ' -> ', NumberToBits(a5))
print(b5, ' -> ', BitsToNumber(b5))
print(b5, ' -> ', BitsToNumberIn(b5))
print()

#субнормальные числа
b6 = '00000000001111000000000000000000'
print(BitsToNumber(b6))
print(BitsToNumberIn(b6))
print(NumberToBits(BitsToNumber(b6)))
print(NumberToBits(BitsToNumberIn(b6)))
