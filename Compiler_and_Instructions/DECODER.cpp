#include <iostream>
#include <fstream>
#include <stdio.h>
#include <string.h>
#include <vector>
using namespace std;
struct Addr
{
	char name[20];//标签名
	int num;//对应的指令位置
	bool type;//false对应16位，true对应26位。
	Addr();
	Addr(char*,int);
};
struct Code
{
	int Line;//指令位置
	char MachineCode[33];//机器码
	Code();
	Code(int,char*);
};
Addr::Addr()
{
	num=-1;
	type=false;
	strcpy(name,"\0");
}
Addr::Addr(char* a,int b)
{
	strcpy(name,a);
	num=b;
}
Code::Code()
{
	Line=-1;
	strcpy(MachineCode,"\0");
}
Code::Code(int a,char* b)
{
	Line=a;
	strcpy(MachineCode,b);
}
int main()
{
	char* RegDecode(char* RegCode);
	void MachineDecode();
	int Efficient(char*);
	MachineDecode();
	return 0;
}
char* RegDecode(char* RegCode)
{
	if(RegCode[1]=='z')
		return "00000";
	else if(RegCode[1]=='r')
		return "11111";
	else if(RegCode[1]=='a')
	{
		if(RegCode[2]=='t')
			return "00001";
		else if(RegCode[2]=='0')
			return "00100";
		else if(RegCode[2]=='1')
			return "00101";
		else if(RegCode[2]=='2')
			return "00110";
		else
			return "00111";
	}
	else if(RegCode[1]=='v')
	{
		if(RegCode[2]=='0')
			return "00010";
		else
			return "00011";
	}
	else if(RegCode[1]=='t')
	{
		if(RegCode[2]=='8')
			return "11000";
		else if(RegCode[2]=='9')
			return "11001";
		else
		{
			int tNum=RegCode[2]-'0';
			switch(tNum)
			{
			case 0: return "01000"; break;
			case 1: return "01001"; break;
			case 2: return "01010"; break;
			case 3: return "01011"; break;
			case 4: return "01100"; break;
			case 5: return "01101"; break;
			case 6: return "01110"; break;
			default: return "01111"; break;
			}
		}
	}
	else if(RegCode[1]=='s')
	{
		if(RegCode[2]=='p')
			return "11101";
		else
		{
			int tNum=RegCode[2]-'0';
			switch(tNum)
			{
			case 0: return "10000"; break;
			case 1: return "10001"; break;
			case 2: return "10010"; break;
			case 3: return "10011"; break;
			case 4: return "10100"; break;
			case 5: return "10101"; break;
			case 6: return "10110"; break;
			default: return "10111"; break;
			}
		}
	}
	else if(RegCode[1]=='k')
	{
		if(RegCode[2]=='0')
			return "11010";
		else
			return "11011";
	}
	else if(RegCode[1]=='g')
		return "11100";
	else
		return "11110";
}
int Efficient(char* Name)
{
	int Eff;
	for(Eff=0;;Eff++)
	{
		if((Name[Eff]>='A'&&Name[Eff]<='Z')||(Name[Eff]>='a'&&Name[Eff]<='z')||Name[Eff]=='$')
				break;
	}
	return Eff;
}
void MachineDecode()
{
	char CodeDetector0[27];
	char CodeDetector1[27];
	char CodeDetector2[27];
	char CodeDetector3[27];
	std::vector<Addr> JumpPos;
	std::vector<Addr> UnknownJumpPos;
	std::vector<Code> Codes;
	bool UnknownTag=false;
	Code flag;
	Addr temp;
	long Imm;
	int Eff;//字符串有效开始位
	int Eff2;//lw，sw指令时使用
	const int LineLength=200;
	ifstream infile("Code.txt",ios::in);
	ofstream outfile("Decode.txt");
	if(!infile||!outfile)
	{
		cerr<<"open error"<<endl;
		return;
	}
	for(int i=0;;i++)
	{
		flag.Line=i;
		infile>>CodeDetector0;
		Eff=Efficient(CodeDetector0);
		if(strcmp(CodeDetector0+Eff,"nop")==0)
		{
			strcpy(flag.MachineCode,"00000000000000000000000000000000");
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"add")==0)
		{
			strcpy(flag.MachineCode,"000000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile.getline(CodeDetector3,LineLength);
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector3));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,"00000100000");
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"addu")==0)
		{
			strcpy(flag.MachineCode,"000000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile.getline(CodeDetector3,LineLength);
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector3));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,"00000100001");
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"sub")==0)
		{
			strcpy(flag.MachineCode,"000000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile.getline(CodeDetector3,LineLength);
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector3));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,"00000100010");
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"subu")==0)
		{
			strcpy(flag.MachineCode,"000000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile.getline(CodeDetector3,LineLength);
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector3));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,"00000100011");
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"addi")==0)
		{
			strcpy(flag.MachineCode,"001000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile>>Imm;
			if(Imm>=0)
			{
				for(int j=15;j>=0;j--)
				{
					CodeDetector3[j]=Imm%2+'0';
					Imm/=2;
				}
			}
			else
			{
				Imm=-Imm;
				bool ReversePos=false;
				for(int j=15;j>=0;j--)
				{
					if(ReversePos)
						CodeDetector3[j]='1'-Imm%2;
					else
					{
						CodeDetector3[j]=Imm%2+'0';
						if(CodeDetector3[j]=='1')
							ReversePos=true;
					}
					Imm/=2;
				}
			}
			CodeDetector3[16]='\0';
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,CodeDetector3);
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"addiu")==0)
		{
			strcpy(flag.MachineCode,"001001");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile>>Imm;
			if(Imm>=0)
			{
				for(int j=15;j>=0;j--)
				{
					CodeDetector3[j]=Imm%2+'0';
					Imm/=2;
				}
			}
			else
			{
				Imm=-Imm;
				bool ReversePos=false;
				for(int j=15;j>=0;j--)
				{
					if(ReversePos)
						CodeDetector3[j]='1'-Imm%2;
					else
					{
						CodeDetector3[j]=Imm%2+'0';
						if(CodeDetector3[j]=='1')
							ReversePos=true;
					}
					Imm/=2;
				}
			}
			CodeDetector3[16]='\0';
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,CodeDetector3);
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"and")==0)
		{
			strcpy(flag.MachineCode,"000000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile.getline(CodeDetector3,LineLength);
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector3));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,"00000100100");
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"or")==0)
		{
			strcpy(flag.MachineCode,"000000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile.getline(CodeDetector3,LineLength);
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector3));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,"00000100101");
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"xor")==0)
		{
			strcpy(flag.MachineCode,"000000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile.getline(CodeDetector3,LineLength);
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector3));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,"00000100110");
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"nor")==0)
		{
			strcpy(flag.MachineCode,"000000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile.getline(CodeDetector3,LineLength);
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector3));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,"00000100111");
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"andi")==0)
		{
			strcpy(flag.MachineCode,"001100");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile>>Imm;
			if(Imm>=0)
			{
				for(int j=15;j>=0;j--)
				{
					CodeDetector3[j]=Imm%2+'0';
					Imm/=2;
				}
			}
			else
			{
				Imm=-Imm;
				bool ReversePos=false;
				for(int j=15;j>=0;j--)
				{
					if(ReversePos)
						CodeDetector3[j]='1'-Imm%2;
					else
					{
						CodeDetector3[j]=Imm%2+'0';
						if(CodeDetector3[j]=='1')
							ReversePos=true;
					}
					Imm/=2;
				}
			}
			CodeDetector3[16]='\0';
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,CodeDetector3);
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"sll")==0)
		{
			strcpy(flag.MachineCode,"00000000000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile>>Imm;
			for(int j=4;j>=0;j--)
			{
				CodeDetector3[j]=Imm%2+'0';
				Imm/=2;
			}
			CodeDetector3[5]='\0';
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,CodeDetector3);
			strcat(flag.MachineCode,"000000");
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"srl")==0)
		{
			strcpy(flag.MachineCode,"00000000000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile>>Imm;
			for(int j=4;j>=0;j--)
			{
				CodeDetector3[j]=Imm%2+'0';
				Imm/=2;
			}
			CodeDetector3[5]='\0';
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,CodeDetector3);
			strcat(flag.MachineCode,"000010");
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"sra")==0)
		{
			strcpy(flag.MachineCode,"00000000000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile>>Imm;
			for(int j=4;j>=0;j--)
			{
				CodeDetector3[j]=Imm%2+'0';
				Imm/=2;
			}
			CodeDetector3[5]='\0';
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,CodeDetector3);
			strcat(flag.MachineCode,"000011");
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"slt")==0)
		{
			strcpy(flag.MachineCode,"000000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile.getline(CodeDetector3,LineLength);
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector3));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,"00000101010");
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"slti")==0)
		{
			strcpy(flag.MachineCode,"001010");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile>>Imm;
			if(Imm>=0)
			{
				for(int j=15;j>=0;j--)
				{
					CodeDetector3[j]=Imm%2+'0';
					Imm/=2;
				}
			}
			else
			{
				Imm=-Imm;
				bool ReversePos=false;
				for(int j=15;j>=0;j--)
				{
					if(ReversePos)
						CodeDetector3[j]='1'-Imm%2;
					else
					{
						CodeDetector3[j]=Imm%2+'0';
						if(CodeDetector3[j]=='1')
							ReversePos=true;
					}
					Imm/=2;
				}
			}
			CodeDetector3[16]='\0';
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,CodeDetector3);
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"sltiu")==0)
		{
			strcpy(flag.MachineCode,"001011");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			infile>>Imm;
			if(Imm>=0)
			{
				for(int j=15;j>=0;j--)
				{
					CodeDetector3[j]=Imm%2+'0';
					Imm/=2;
				}
			}
			else
			{
				Imm=-Imm;
				bool ReversePos=false;
				for(int j=15;j>=0;j--)
				{
					if(ReversePos)
						CodeDetector3[j]='1'-Imm%2;
					else
					{
						CodeDetector3[j]=Imm%2+'0';
						if(CodeDetector3[j]=='1')
							ReversePos=true;
					}
					Imm/=2;
				}
			}
			CodeDetector3[16]='\0';
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,CodeDetector3);
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"lw")==0)
		{
			strcpy(flag.MachineCode,"100011");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile>>Imm;
			Imm*=4;
			infile.getline(CodeDetector2,LineLength);
			Eff2=Efficient(CodeDetector2);
			if(Imm>=0)
			{
				for(int j=15;j>=0;j--)
				{
					CodeDetector3[j]=Imm%2+'0';
					Imm/=2;
				}
			}
			else
			{
				Imm=-Imm;
				bool ReversePos=false;
				for(int j=15;j>=0;j--)
				{
					if(ReversePos)
						CodeDetector3[j]='1'-Imm%2;
					else
					{
						CodeDetector3[j]=Imm%2+'0';
						if(CodeDetector3[j]=='1')
							ReversePos=true;
					}
					Imm/=2;
				}
			}
			CodeDetector3[16]='\0';
			strcat(flag.MachineCode,RegDecode(CodeDetector2+Eff2));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,CodeDetector3);
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"sw")==0)
		{
			strcpy(flag.MachineCode,"101011");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile>>Imm;
			Imm*=4;
			infile.getline(CodeDetector2,LineLength);
			Eff2=Efficient(CodeDetector2);
			if(Imm>=0)
			{
				for(int j=15;j>=0;j--)
				{
					CodeDetector3[j]=Imm%2+'0';
					Imm/=2;
				}
			}
			else
			{
				Imm=-Imm;
				bool ReversePos=false;
				for(int j=15;j>=0;j--)
				{
					if(ReversePos)
						CodeDetector3[j]='1'-Imm%2;
					else
					{
						CodeDetector3[j]=Imm%2+'0';
						if(CodeDetector3[j]=='1')
							ReversePos=true;
					}
					Imm/=2;
				}
			}
			CodeDetector3[16]='\0';
			strcat(flag.MachineCode,RegDecode(CodeDetector2+Eff2));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,CodeDetector3);
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"lui")==0)
		{
			strcpy(flag.MachineCode,"00111100000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile>>Imm;
			if(Imm>=0)
			{
				for(int j=15;j>=0;j--)
				{
					CodeDetector3[j]=Imm%2+'0';
					Imm/=2;
				}
			}
			else
			{
				Imm=-Imm;
				bool ReversePos=false;
				for(int j=15;j>=0;j--)
				{
					if(ReversePos)
						CodeDetector3[j]='1'-Imm%2;
					else
					{
						CodeDetector3[j]=Imm%2+'0';
						if(CodeDetector3[j]=='1')
							ReversePos=true;
					}
					Imm/=2;
				}
			}
			CodeDetector3[16]='\0';
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,CodeDetector3);
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"jr")==0)
		{
			strcpy(flag.MachineCode,"000000");
			infile.getline(CodeDetector1,LineLength);
			Eff=Efficient(CodeDetector1);
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,"000000000000000001000");
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"jalr")==0)
		{
			strcpy(flag.MachineCode,"000000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength);
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,"00000");
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,"00000001001");
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"beq")==0)
		{
			strcpy(flag.MachineCode,"000100");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			infile.getline(CodeDetector3,LineLength);
			for(int j=strlen(CodeDetector3)-1;j>=0;j--)
			{
				if((CodeDetector3[j]>='A'&&CodeDetector3[j]<='Z')||(CodeDetector3[j]>='a'&&CodeDetector3[j]<='z')||(CodeDetector3[j]>='0'&&CodeDetector3[j]<='9'))
					break;
				else
					CodeDetector3[j]='\0';
			}
			for(int j=0;j<JumpPos.size();j++)
			{
				if(strcmp(CodeDetector3,JumpPos[j].name)==0)
				{
					Imm=JumpPos[j].num-i-1;
					if(Imm>=0)
					{
						for(int j=15;j>=0;j--)
						{
							CodeDetector3[j]=Imm%2+'0';
							Imm/=2;
						}
					}
					else
					{
						Imm=-Imm;
						bool ReversePos=false;
						for(int j=15;j>=0;j--)
						{
							if(ReversePos)
								CodeDetector3[j]='1'-Imm%2;
							else
							{
								CodeDetector3[j]=Imm%2+'0';
								if(CodeDetector3[j]=='1')
									ReversePos=true;
							}
							Imm/=2;
						}
					}
					CodeDetector3[16]='\0';
					strcat(flag.MachineCode,CodeDetector3);
					break;
				}
			}
			if(strlen(flag.MachineCode)!=32)
			{
				UnknownTag=true;
				strcpy(temp.name,CodeDetector3);
				temp.num=i;
				temp.type=false;
				UnknownJumpPos.push_back(temp);
			}
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"bne")==0)
		{
			strcpy(flag.MachineCode,"000101");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			infile.getline(CodeDetector2,LineLength,',');
			strcat(flag.MachineCode,RegDecode(CodeDetector2));
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			infile.getline(CodeDetector3,LineLength);
			for(int j=strlen(CodeDetector3)-1;j>=0;j--)
			{
				if((CodeDetector3[j]>='A'&&CodeDetector3[j]<='Z')||(CodeDetector3[j]>='a'&&CodeDetector3[j]<='z')||(CodeDetector3[j]>='0'&&CodeDetector3[j]<='9'))
					break;
				else
					CodeDetector3[j]='\0';
			}
			for(int j=0;j<JumpPos.size();j++)
			{
				if(strcmp(CodeDetector3,JumpPos[j].name)==0)
				{
					Imm=JumpPos[j].num-i-1;
					if(Imm>=0)
					{
						for(int j=15;j>=0;j--)
						{
							CodeDetector3[j]=Imm%2+'0';
							Imm/=2;
						}
					}
					else
					{
						Imm=-Imm;
						bool ReversePos=false;
						for(int j=15;j>=0;j--)
						{
							if(ReversePos)
								CodeDetector3[j]='1'-Imm%2;
							else
							{
								CodeDetector3[j]=Imm%2+'0';
								if(CodeDetector3[j]=='1')
									ReversePos=true;
							}
							Imm/=2;
						}
					}
					CodeDetector3[16]='\0';
					strcat(flag.MachineCode,CodeDetector3);
					break;
				}
			}
			if(strlen(flag.MachineCode)!=32)
			{
				UnknownTag=true;
				strcpy(temp.name,CodeDetector3);
				temp.num=i;
				temp.type=false;
				UnknownJumpPos.push_back(temp);
			}
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"blez")==0)
		{
			strcpy(flag.MachineCode,"010000");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,"00000");
			infile.getline(CodeDetector3,LineLength);
			for(int j=strlen(CodeDetector3)-1;j>=0;j--)
			{
				if((CodeDetector3[j]>='A'&&CodeDetector3[j]<='Z')||(CodeDetector3[j]>='a'&&CodeDetector3[j]<='z')||(CodeDetector3[j]>='0'&&CodeDetector3[j]<='9'))
					break;
				else
					CodeDetector3[j]='\0';
			}
			for(int j=0;j<JumpPos.size();j++)
			{
				if(strcmp(CodeDetector3,JumpPos[j].name)==0)
				{
					Imm=JumpPos[j].num-i-1;
					if(Imm>=0)
					{
						for(int j=15;j>=0;j--)
						{
							CodeDetector3[j]=Imm%2+'0';
							Imm/=2;
						}
					}
					else
					{
						Imm=-Imm;
						bool ReversePos=false;
						for(int j=15;j>=0;j--)
						{
							if(ReversePos)
								CodeDetector3[j]='1'-Imm%2;
							else
							{
								CodeDetector3[j]=Imm%2+'0';
								if(CodeDetector3[j]=='1')
									ReversePos=true;
							}
							Imm/=2;
						}
					}
					CodeDetector3[16]='\0';
					strcat(flag.MachineCode,CodeDetector3);
					break;
				}
			}
			if(strlen(flag.MachineCode)!=32)
			{
				UnknownTag=true;
				strcpy(temp.name,CodeDetector3);
				temp.num=i;
				temp.type=false;
				UnknownJumpPos.push_back(temp);
			}
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"bgtz")==0)
		{
			strcpy(flag.MachineCode,"010001");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,"00000");
			infile.getline(CodeDetector3,LineLength);
			for(int j=strlen(CodeDetector3)-1;j>=0;j--)
			{
				if((CodeDetector3[j]>='A'&&CodeDetector3[j]<='Z')||(CodeDetector3[j]>='a'&&CodeDetector3[j]<='z')||(CodeDetector3[j]>='0'&&CodeDetector3[j]<='9'))
					break;
				else
					CodeDetector3[j]='\0';
			}
			for(int j=0;j<JumpPos.size();j++)
			{
				if(strcmp(CodeDetector3,JumpPos[j].name)==0)
				{
					Imm=JumpPos[j].num-i-1;
					if(Imm>=0)
					{
						for(int j=15;j>=0;j--)
						{
							CodeDetector3[j]=Imm%2+'0';
							Imm/=2;
						}
					}
					else
					{
						Imm=-Imm;
						bool ReversePos=false;
						for(int j=15;j>=0;j--)
						{
							if(ReversePos)
								CodeDetector3[j]='1'-Imm%2;
							else
							{
								CodeDetector3[j]=Imm%2+'0';
								if(CodeDetector3[j]=='1')
									ReversePos=true;
							}
							Imm/=2;
						}
					}
					CodeDetector3[16]='\0';
					strcat(flag.MachineCode,CodeDetector3);
					break;
				}
			}
			if(strlen(flag.MachineCode)!=32)
			{
				UnknownTag=true;
				strcpy(temp.name,CodeDetector3);
				temp.num=i;
				temp.type=false;
				UnknownJumpPos.push_back(temp);
			}
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"bltz")==0)
		{
			strcpy(flag.MachineCode,"010010");
			infile.getline(CodeDetector1,LineLength,',');
			Eff=Efficient(CodeDetector1);
			strcat(flag.MachineCode,RegDecode(CodeDetector1+Eff));
			strcat(flag.MachineCode,"00000");
			infile.getline(CodeDetector3,LineLength);
			for(int j=strlen(CodeDetector3)-1;j>=0;j--)
			{
				if((CodeDetector3[j]>='A'&&CodeDetector3[j]<='Z')||(CodeDetector3[j]>='a'&&CodeDetector3[j]<='z')||(CodeDetector3[j]>='0'&&CodeDetector3[j]<='9'))
					break;
				else
					CodeDetector3[j]='\0';
			}
			for(int j=0;j<JumpPos.size();j++)
			{
				if(strcmp(CodeDetector3,JumpPos[j].name)==0)
				{
					Imm=JumpPos[j].num-i-1;
					if(Imm>=0)
					{
						for(int j=15;j>=0;j--)
						{
							CodeDetector3[j]=Imm%2+'0';
							Imm/=2;
						}
					}
					else
					{
						Imm=-Imm;
						bool ReversePos=false;
						for(int j=15;j>=0;j--)
						{
							if(ReversePos)
								CodeDetector3[j]='1'-Imm%2;
							else
							{
								CodeDetector3[j]=Imm%2+'0';
								if(CodeDetector3[j]=='1')
									ReversePos=true;
							}
							Imm/=2;
						}
					}
					CodeDetector3[16]='\0';
					strcat(flag.MachineCode,CodeDetector3);
					break;
				}
			}
			if(strlen(flag.MachineCode)!=32)
			{
				UnknownTag=true;
				strcpy(temp.name,CodeDetector3);
				temp.num=i;
				temp.type=false;
				UnknownJumpPos.push_back(temp);
			}
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"j")==0)
		{
			strcpy(flag.MachineCode,"000010");
			infile.getline(CodeDetector3,LineLength);
			Eff=Efficient(CodeDetector3);
			for(int j=strlen(CodeDetector3)-1;j>=0;j--)
			{
				if((CodeDetector3[j]>='A'&&CodeDetector3[j]<='Z')||(CodeDetector3[j]>='a'&&CodeDetector3[j]<='z')||(CodeDetector3[j]>='0'&&CodeDetector3[j]<='9'))
					break;
				else
					CodeDetector3[j]='\0';
			}
			for(int j=0;j<JumpPos.size();j++)
			{
				if(strcmp(CodeDetector3+Eff,JumpPos[j].name)==0)
				{
					Imm=JumpPos[j].num;//空出reset，中断和异常
					for(int j=25;j>=0;j--)
					{
						CodeDetector3[j]=Imm%2+'0';
						Imm/=2;
					}
					CodeDetector3[26]='\0';
					strcat(flag.MachineCode,CodeDetector3);
					break;
				}
			}
			if(strlen(flag.MachineCode)!=32)
			{
				UnknownTag=true;
				strcpy(temp.name,CodeDetector3+Eff);
				temp.num=i;
				temp.type=true;
				UnknownJumpPos.push_back(temp);
			}
			Codes.push_back(flag);
		}
		else if(strcmp(CodeDetector0+Eff,"jal")==0)
		{
			strcpy(flag.MachineCode,"000011");
			infile.getline(CodeDetector3,LineLength);
			Eff=Efficient(CodeDetector3);
			for(int j=strlen(CodeDetector3)-1;j>=0;j++)
			{
				if((CodeDetector3[j]>='A'&&CodeDetector3[j]<='Z')||(CodeDetector3[j]>='a'&&CodeDetector3[j]<='z')||(CodeDetector3[j]>='0'&&CodeDetector3[j]<='9'))
					break;
				else
					CodeDetector3[j]='\0';
			}
			for(int j=0;j<JumpPos.size();j++)
			{
				if(strcmp(CodeDetector3+Eff,JumpPos[j].name)==0)
				{
					Imm=JumpPos[j].num;//空出reset，中断和异常
					for(int j=25;j>=0;j--)
					{
						CodeDetector3[j]=Imm%2+'0';
						Imm/=2;
					}
					CodeDetector3[26]='\0';
					strcat(flag.MachineCode,CodeDetector3);
					break;
				}
			}
			if(strlen(flag.MachineCode)!=32)
			{
				UnknownTag=true;
				strcpy(temp.name,CodeDetector3+Eff);
				temp.num=i;
				temp.type=true;
				UnknownJumpPos.push_back(temp);
			}
			Codes.push_back(flag);
		}
		else
		{
			CodeDetector0[strlen(CodeDetector0)-1]='\0';
			strcpy(temp.name,CodeDetector0);
			temp.num=i;
			if(UnknownTag)
			{
				for(int j=0;j<UnknownJumpPos.size();j++)
				{
					if(strcmp(UnknownJumpPos[j].name,temp.name)==0)
					{
						if(!UnknownJumpPos[j].type)
						{
							Imm=i-UnknownJumpPos[j].num-1;
							if(Imm>=0)
							{
								for(int k=15;k>=0;k--)
								{
									CodeDetector3[k]=Imm%2+'0';
									Imm/=2;
								}
							}
							else
							{
								Imm=-Imm;
								bool ReversePos=false;
								for(int k=15;k>=0;k--)
								{
									if(ReversePos)
										CodeDetector3[k]='1'-Imm%2;
									else
									{
										CodeDetector3[k]=Imm%2+'0';
										if(CodeDetector3[k]=='1')
											ReversePos=true;
									}
									Imm/=2;
								}
							}
							CodeDetector3[16]='\0';
						}
						else
						{
							Imm=i;
							for(int j=25;j>=0;j--)
							{
								CodeDetector3[j]=Imm%2+'0';
								Imm/=2;
							}
							CodeDetector3[26]='\0';
						}
						strcat(Codes[UnknownJumpPos[j].num].MachineCode,CodeDetector3);
						UnknownJumpPos.erase(UnknownJumpPos.begin()+j);
						j--;
					}
				}
				if(UnknownJumpPos.size()==0)
					UnknownTag=false;
			}
			JumpPos.push_back(temp);
			i--;
		}
		if(infile.eof())
			break;
	}
	/*for(int i=0;i<Codes.size();i++)
	{
		Imm=0;
		for(int j=0;j<32;j++)
		{
			if(j==31)
			{
				Imm=Imm*2+int(Codes[i].MachineCode[j]-'0');
				outfile<<hex<<Imm<<endl;
			}
			else if(j%4==3)
			{
				Imm=Imm*2+int(Codes[i].MachineCode[j]-'0');
				outfile<<hex<<Imm;
				Imm=0;
			}
			else
				Imm=Imm*2+int(Codes[i].MachineCode[j]-'0');
		}
	}*/
	infile.close();
	infile.open("Code.txt",ios::in);
	char LineDetector[100];
	for(int i=0;i<Codes.size();i++)
	{
		infile.getline(LineDetector,LineLength);
		if(i<=9)
			outfile<<"\t\t"<<i<<": Instruction<=32'b"<<Codes[i].MachineCode<<";\t//"<<LineDetector<<endl;
		else
			outfile<<"\t\t"<<i<<":Instruction<=32'b"<<Codes[i].MachineCode<<";\t//"<<LineDetector<<endl;
	}
	infile.close();
	outfile.close();
}
