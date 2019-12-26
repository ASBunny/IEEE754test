using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace Представление_числа
{
    class Program
    {
        public static void IsLittleBig ()// проверка на little endian
            //или big endian
        {
            if (BitConverter.IsLittleEndian)
            {
                Console.WriteLine("little-endian");
            }
            else
            {
                Console.WriteLine("most likely big-endian");
            }
        }
        public static void BinaryWriting ( float a) //запись числа в файл
        {
            BinaryWriter writer = new BinaryWriter(File.Open("test.txt"
                , FileMode.OpenOrCreate));
            writer.Write(a);
            writer.Close();
        }
        public static string BinaryReading () //чтение байтов из файла
        {
            //Я обошлась без определения файла пользователем,
            //надеясь, что пока не надо экспериментривать с самим файлом
            string str = "", str1 = "";
            FileStream f = new FileStream("test.txt"
                , FileMode.Open, FileAccess.Read, FileShare.Read);
            BinaryReader reader = new BinaryReader(f);
            while (reader.PeekChar() > -1)
            {
                byte input = reader.ReadByte();//Чтение очередного байта
                str = Convert.ToString(input, 2).PadLeft(8, '0'); //запись байта в строку
               // Console.WriteLine(input);
                //Console.WriteLine(str);
                str1 = str + str1;// сборка конечной строки в правильном порядке слева направо
            }
            reader.Close();
            Console.WriteLine("binary form " + str1);
            return str1;// На выходе имеется строка из 32 символов {0,1}
        }
        public static int Build (string str1) //сборка числа
        {
            string b = str1.Substring(1, 8);//В строковую переменную записывается с 1 по 8 символы
            // Из этого будет собираться экспонента
            string m = str1.Substring(9); //В строковую переменную записываются все символы,
            // начиная с 9 до конца. Это будет мантисса
            int sign = 0;//То, что будет определять знак
            int bi = 0; //Это будет экспонента
            float ma = 0;
            float[] PowerOfTwo = new float[24];
            for (int i = 0; i < 24; i++ )
            {
                PowerOfTwo[i] = Convert.ToSingle(Math.Pow(2,i));
            }
            if (str1[0] == '0')//Если нулевой символ 0, то +
            {
                sign = 1;
            }
            else
                sign = -1;

            for (int i = 0; i < 8; i++)// Собирается экспанента
            {
                if (b[i] == '1')
                    bi += Convert.ToInt32(Math.Pow(2, 7 - i));
            }
            if (bi > 0 && bi < 255) 
                m = m.Insert(0, "1");//для нормальных чисел в мантиссу добавляется 1
            else
                if (bi == 0 && m == "00000000000000000000000")
                {
                    if (sign == 0)
                    {
                        Console.WriteLine("+0");
                        return 0;
                    }
                    else
                    {
                        Console.WriteLine("-0");
                        return 0;
                    }
                }
                else if (bi == 0 && m != "00000000000000000000000")
                {
                    m = m.Insert(0, "0");// для субнормальных в мантиссу добавляется 0
                    Console.WriteLine("this is a subnormal number \n");
                }
                else
                {//Далее определяются бесконечности и NaN'ы

                    if (sign == 1 && m == "00000000000000000000000")
                    {
                        Console.WriteLine("+INF");
                        return 0;
                    }
                    if (sign == -1 && m == "00000000000000000000000")
                    {
                        Console.WriteLine("-INF");
                        return 0;
                    }
                    else
                    {
                        Console.WriteLine("NaN");
                        return 0;
                    }
                }

            for (int i = 0; i < 23; i++) //Собственно, сборка числа
            {
                if (m[i] == '1')
                    ma += PowerOfTwo[23 - i];
            }
            ma = ma / PowerOfTwo[23];
            if (bi == 0)
            {
                bi = bi - 126;//специальная степень для субнормальных чисел
            }
            else 
                bi = bi - 127;

            float bi1 = Convert.ToSingle(Math.Pow(2,bi));
            Console.WriteLine(sign * bi1 * ma);

            return 0;
        }
        public static float StrToSingle (string str)
        {

            int num = Convert.ToInt32(str,2);
            byte[] n = BitConverter.GetBytes(num);
            return BitConverter.ToSingle(n, 0);
        }
        static void Main(string[] args)
        {
            float NegInf = -0.1f/0.0f;//бесконечность
            float ZeroZero = 0.0f / 0.0f;//неопределеность 0/0
            float a = 3.4f;//не нуждается в комментарии 
            float InfInf = (-0.1f / 0.0f) / (0.1f / 0.0f);//неопределенность 00/00
            float NegZero = -1f / (0.1f / 0.0f);//ноль со знаком
            string nan;
            Console.WriteLine("Enter 1 if you want to work with numbers\n Enter 2 if you want to work with the string\n");
            string inp = Console.ReadLine();
            string ans;
            float ret;
            float res;
            if (Convert.ToInt32(inp) == 1)
            {
                Console.WriteLine("3.4");
                BinaryWriting(a);
                ans = BinaryReading();
                Build(ans);
                res = StrToSingle(ans);
                Console.WriteLine("standard " + res);
                Console.WriteLine("\n");

                Console.WriteLine("Negative Infinity");
                BinaryWriting(NegInf);
                ans = BinaryReading();
                Build(ans);
                res = StrToSingle(ans);
                Console.WriteLine("standard " + res);
                Console.WriteLine("\n");

                Console.WriteLine("Zero divided by zero");
                BinaryWriting(ZeroZero);
                ans = BinaryReading();
                Build(ans);
                res = StrToSingle(ans);
                Console.WriteLine("standard " + res);
                Console.WriteLine("\n");

                Console.WriteLine("Negative zero");
                BinaryWriting(NegZero);
                ans = BinaryReading();
                Build(ans);
                res = StrToSingle(ans);
                Console.WriteLine("standard " + res);
                Console.WriteLine("\n");

                Console.WriteLine("Infinity divided by infinity");
                BinaryWriting(InfInf);
                ans = BinaryReading();
                Build(ans);
                res = StrToSingle(ans);
                Console.WriteLine("standard " + res);
                Console.WriteLine("\n");

            }

            else
            {
                Console.WriteLine("Enter the string \n");
                 nan = Console.ReadLine();
                Build(nan);
                res = StrToSingle(nan);
                Console.WriteLine("standard " + res);
            }
            Console.ReadKey();
        }
    }
}
