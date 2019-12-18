function ChisloToBit(st: single): string; //функция, которая переводит число в побитовое представление
  var f: file;
  str: byte;
  i,j,b: integer;
  ss: string;
  a: array [1..4] of integer;
  s: array [1..4] of string;
begin
  assign(f, 'f.txt');
  rewrite(f);
  write(f,st); //запись в файл числа в виде знаков таблицы ASCII
  close(f);
  i:=1;
  assign(f, 'f.txt');
  reset(f);
  while not Eof(f) do
  begin
    read(f,str);
    a[i]:=ord(str); //переводит знак в ее числовой код таблицы ASCII
    i:=i+1;
  end;
  close(f);
  for i:=4 downto 1 do //считывание чисел с конца 
  begin
    b:=a[i];
    repeat 
    until(b >= 0); 
    while b > 0 do 
      begin
        if b mod 2 = 0 then 
          s[i]:='0'+s[i] 
        else 
        begin
          s[i]:='1'+s[i]; 
          b:= b - 1; 
        end; 
      b:= b div 2; 
      end;
    if length(s[i])<8 then
     for j:=1 to 8-length(s[i]) do s[i]:='0'+s[i];
  end;
  ss:='';
  for i:=4 downto 1 do ss:=ss+s[i];
  ChisloToBit:=ss;
end;

function BitToChislo(ss: string): real;//функция, которая переводит побитовое представление числа в вещественное число
  var i: integer;
  s1,s2,s3: string;
  s: array [1..4] of string;
  l,eksp,mant: real;
begin
  s1:=ss[1]; s2:=''; s3:='';//разбиение на знак, экспоненту, мантиссу
  for i:=2 to 9 do s2:=s2+ss[i];
  for i:=10 to 32 do s3:=s3+ss[i];
  eksp:=0; mant:=0;
  for i:=1 to 8 do eksp:=eksp+StrToInt(s2[i])*power(2,8-i);//подсчет экспоненты
  for i:=1 to 23 do mant:=mant+StrToInt(s3[i])*power(2,-i);//подсчет мантиссы
  if eksp=255 then 
    if mant=0 then
      if StrToInt(s1)=0 then l:=1/0  //условие на появление + и - бесконечностей
      else l:=-1/0
    else if StrToInt(s1)=0 then l:=-1/0+1/0 //условие на появление + и - NaN
         else l:=-1/0+1/0
  else if eksp=0 then l:=power(-1,StrToInt(s1))*power(2,(eksp-127))*mant //подсчет субнормального числа
       else l:=power(-1,StrToInt(s1))*power(2,(eksp-127))*(1+mant); //подсчет вещественного числа
  BitToChislo:=l;
end;

function ChToFileToCh(str: string): single; //функция, которая переводит побитовое представление числа сначала в файл, а потом в вещественное число.
  var f: file;
  s,ss: string;
  strb: single;
  i,j,ch: integer;
  b: array [1..4] of byte;
begin
  s:=''; ss:='';
 
  for i:=1 to 4 do
  begin
    b[i]:=0;
    for j:=1 to 8 do
      b[i]:=b[i]+round(StrToInt(str[(i-1)*8+j])*power(2,8-j));//переводит побитовое представление числа в числа таблицы ASCII
  end;

  assign(f, 'g.txt');
  rewrite(f);
  for i:=4 downto 1 do
  write(f,b[i]);//запись в файл
  
  reset(f);
  read(f,strb);//чтение из файла
  close(f);
  ChToFileToCh:=strb;
end;

begin
writeln(ChisloToBit(3.405));
writeln(BitToChislo(ChisloToBit(3.405)));
writeln(ChToFileToCh(ChisloToBit(3.405)));
writeln;
writeln('+0 = ',BitToChislo('00000000000000000000000000000000'));
writeln('-0 = ',BitToChislo('10000000000000000000000000000000'));
writeln;
writeln('+infinity = ',BitToChislo('01111111100000000000000000000000'));
writeln('-infinity = ',BitToChislo('11111111100000000000000000000000'));
writeln;
writeln('+NaN = ',BitToChislo('01111111110000000000000000000001'));
writeln('-NaN = ',BitToChislo('11111111110000000000000000000001'));
writeln;
writeln('+subnormal = ',BitToChislo('00000000000000000000000000000001'));
writeln('-subnormal = ',BitToChislo('10000000000000000000000000000001'));
end.