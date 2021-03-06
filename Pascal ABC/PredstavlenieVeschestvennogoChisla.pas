function ChisloToBit(st: single): string; //�������, ������� ��������� ����� � ��������� �������������
  var f: file;
  str: byte;
  i,j,b: integer;
  ss: string;
  a: array [1..4] of integer;
  s: array [1..4] of string;
begin
  assign(f, 'f.txt');
  rewrite(f);
  write(f,st); //������ � ���� ����� � ���� ������ ������� ASCII
  close(f);
  i:=1;
  assign(f, 'f.txt'); //���������� �����
  reset(f);
  while not Eof(f) do
  begin
    read(f,str);
    a[i]:=ord(str); //��������� ���� � �� �������� ��� ������� ASCII
    i:=i+1;
  end;
  close(f);
  for i:=4 downto 1 do //�������������� ����� � ����� �������� �����
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
     for j:=1 to 8-length(s[i]) do s[i]:='0'+s[i];//���������� 0 � ������ ������ �����
  end;
  ss:='';
  for i:=4 downto 1 do ss:=ss+s[i];//������ 4 ����� �� 8 ��� � ����� �� 32 ���
  ChisloToBit:=ss;
end;

function BitToChislo(ss: string): single;//�������, ������� ��������� ��������� ������������� ����� � ����� ���� single-precision
  var i: integer;
  s1,s2,s3: string;
  eksp: integer;
  l,mant: real;
begin
  s1:=ss[1]; s2:=''; s3:='';//��������� �� ����, ����������, ��������
  for i:=2 to 9 do s2:=s2+ss[i];
  for i:=10 to 32 do s3:=s3+ss[i];
  eksp:=0; mant:=0;
  for i:=1 to 8 do eksp:=eksp+StrToInt(s2[i])*round(power(2,8-i));//������� ����������
  for i:=1 to 23 do mant:=mant+StrToInt(s3[i])*power(2,-i);//������� ��������
  //�������� ������� � ����������� ������ �����:
  if eksp=255 then
    if mant=0 then
      if StrToInt(s1)=0 then BitToChislo:=1/0  //������� �� ��������� + � - ��������������
      else BitToChislo:=-1/0
    else if StrToInt(s1)=0 then BitToChislo:=0/0 //������� �� ��������� + � - NaN
         else BitToChislo:=-0/0
  else

  if eksp=0 then
    begin
      l:=power(2,(eksp-126))*mant; //������� �������������� �����
      if StrToInt(s1)=0 then BitToChislo:=l 
      else BitToChislo:=(-1)*l
    end
  else 
    begin 
      l:=power(2,(eksp-127))*(1+mant); //������� ������������� �����
      if StrToInt(s1)=0 then BitToChislo:=l 
      else BitToChislo:=(-1)*l; 
    end; 
end;

function ChToFileToCh(str: string): single; //�������������� ���������� ������������� ����� � ����� ���� single-precision � ������� ���������� ������� PascalABC.NET
  var f: file;
  strb: single;
  i,j: integer;
  b: array [1..4] of byte;
begin
  for i:=1 to 4 do
  begin
    b[i]:=0;
    for j:=1 to 8 do
      b[i]:=b[i]+round(StrToInt(str[(i-1)*8+j])*power(2,8-j));//��������� ��������� ������������� ����� � ����� ������� ASCII
  end;

  assign(f, 'g.txt');
  rewrite(f);
  for i:=4 downto 1 do
  write(f,b[i]);//������ � ����
  
  reset(f);
  read(f,strb);//������ �� �����
  close(f);
  ChToFileToCh:=strb;
end;

var N: single;
begin
  N:=3.4;
  writeln(ChisloToBit(N));//�������������� ����� N � ��������� ������������� � ������� �������
  writeln(N,' = ',BitToChislo(ChisloToBit(N)),' (���������� �������� = ',ChToFileToCh(ChisloToBit(N)),')');//��������� �������������� ���������� ������������� ����� N � ����� ���� single-precision � �������������� ���������� ������������� ����� N � ����� ���� single-precision � ������� ���������� �������
  writeln;
  writeln('+0 = ',BitToChislo('00000000000000000000000000000000'),' (���������� �������� = ',ChToFileToCh('00000000000000000000000000000000'),')');
  writeln('-0 = ',BitToChislo('10000000000000000000000000000000'),' (���������� �������� = ',ChToFileToCh('10000000000000000000000000000000'),')');
  writeln;
  writeln('+infinity = ',BitToChislo('01111111100000000000000000000000'),' (���������� �������� = ',ChToFileToCh('01111111100000000000000000000000'),')');
  writeln('-infinity = ',BitToChislo('11111111100000000000000000000000'),' (���������� �������� = ',ChToFileToCh('11111111100000000000000000000000'),')');
  writeln;
  writeln('+NaN = ',BitToChislo('01111111110000000000000000000001'),' (���������� �������� = ',ChToFileToCh('01111111110000000000000000000001'),')');
  writeln('-NaN = ',BitToChislo('11111111110000000000000000000001'),' (���������� �������� = ',ChToFileToCh('11111111110000000000000000000001'),')');
  writeln;
  writeln('+subnormal = ',BitToChislo('00000000000000000000000000000001'),' (���������� �������� = ',ChToFileToCh('00000000000000000000000000000001'),')');
  writeln('-subnormal = ',BitToChislo('10000000000000000000000000000001'),' (���������� �������� = ',ChToFileToCh('10000000000000000000000000000001'),')');
end.