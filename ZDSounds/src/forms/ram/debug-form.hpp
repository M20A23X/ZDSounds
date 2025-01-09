#pragma once

#include <tuple>

#include "data\locos\base\base.hpp"
#include "data\locos\chs7\chs7.hpp"
#include "data\ram.hpp"


namespace ZDSounds {

#include "utils\utils.hpp"


	using namespace System;
	using namespace System::ComponentModel;
	using namespace System::Collections;
	using namespace System::Windows::Forms;
	using namespace System::Data;
	using namespace System::Drawing;

	public ref class Debug : public System::Windows::Forms::Form {

		RAM* general = nullptr;

	public:
		Debug(void) {
			InitializeComponent();
		}

		Debug(RAM* general) :general{ general } {
			InitializeComponent();
		}

	protected:
		~Debug() {
			if (components) {
				delete components;
			}
		}
	private: System::Windows::Forms::GroupBox^ gbConsist;
	protected:

	private: System::Windows::Forms::Label^ label1;
	private: System::Windows::Forms::Label^ lblConsistType;

	private: System::Windows::Forms::Label^ label5;





	private: System::Windows::Forms::Label^ label11;
	private: System::Windows::Forms::Label^ lblLocoSectionCount;

	private: System::Windows::Forms::Label^ label9;


	private: System::Windows::Forms::Label^ label7;
	private: System::Windows::Forms::Label^ lblConsistLength;

	private: System::Windows::Forms::Label^ label3;
	private: System::Windows::Forms::Label^ lblAxesCount;









	private: System::Windows::Forms::GroupBox^ gbMisc;
















	private: System::Windows::Forms::Label^ label37;
	private: System::Windows::Forms::Label^ lblAtPassingStation;

	private: System::Windows::Forms::GroupBox^ gbOncoming;
	private: System::Windows::Forms::Label^ lblOLocoAxesCount;
	private: System::Windows::Forms::Label^ lblOWagonAxesCount;






	private: System::Windows::Forms::Label^ label23;
	private: System::Windows::Forms::Label^ label24;
	private: System::Windows::Forms::Label^ lblOLocoLength;
	private: System::Windows::Forms::Label^ lblOWagonLenght;


	private: System::Windows::Forms::Label^ label27;
	private: System::Windows::Forms::Label^ label28;
	private: System::Windows::Forms::Label^ label29;
	private: System::Windows::Forms::Label^ lblOLocoSectionCount;


	private: System::Windows::Forms::Label^ label31;
	private: System::Windows::Forms::Label^ lblOLocoType;

	private: System::Windows::Forms::Label^ label33;
	private: System::Windows::Forms::Label^ lblOConsistLength;

	private: System::Windows::Forms::Label^ label35;
	private: System::Windows::Forms::Label^ lblOAxesCount;


	private: System::Windows::Forms::Label^ label39;
	private: System::Windows::Forms::Label^ lblOConsistType;





	private: System::Windows::Forms::Label^ label41;
	private: System::Windows::Forms::Label^ lblOWagonCount;


	private: System::Windows::Forms::Label^ label45;
	private: System::Windows::Forms::Label^ lblOSpeed;

	private: System::Windows::Forms::Label^ label47;
	private: System::Windows::Forms::Label^ lblOOrdinate;

	private: System::Windows::Forms::Label^ label49;
	private: System::Windows::Forms::Label^ lblOOrdinateDelta;

	private: System::Windows::Forms::Label^ label51;
	private: System::Windows::Forms::Label^ lblOOrdinateDiff;

	private: System::Windows::Forms::Label^ label53;
	private: System::Windows::Forms::Label^ lblOTrack;

	private: System::Windows::Forms::Label^ label43;
	private: System::Windows::Forms::Label^ lblOStatus;

	private: System::Windows::Forms::GroupBox^ gbROM;
	private: System::Windows::Forms::Label^ lblLocoAxesCount;
	private: System::Windows::Forms::Label^ lblWagonAxesCount;


	private: System::Windows::Forms::Label^ label19;
	private: System::Windows::Forms::Label^ label20;
	private: System::Windows::Forms::Label^ lblLocoLength;
	private: System::Windows::Forms::Label^ lblWagonLenght;






	private: System::Windows::Forms::Label^ label14;
	private: System::Windows::Forms::Label^ label13;






	private: System::Windows::Forms::GroupBox^ gbRAM;
	private: System::Windows::Forms::GroupBox^ groupBox2;












	private: System::Windows::Forms::Label^ label67;
	private: System::Windows::Forms::Label^ lblPause;



	private: System::Windows::Forms::Label^ label71;
	private: System::Windows::Forms::Label^ lblConnected;

	private: System::Windows::Forms::Label^ label73;


































	private: System::Windows::Forms::GroupBox^ groupBox4;
	private: System::Windows::Forms::Label^ lblRain;


	private: System::Windows::Forms::GroupBox^ groupBox1;








	private: System::Windows::Forms::Label^ label63;
	private: System::Windows::Forms::Label^ lblConsist;

	private: System::Windows::Forms::Label^ label65;
	private: System::Windows::Forms::Label^ lblScenery;

	private: System::Windows::Forms::Label^ label69;
	private: System::Windows::Forms::Label^ lblSWagonCount;

	private: System::Windows::Forms::Label^ label74;
	private: System::Windows::Forms::Label^ lblRoute;

	private: System::Windows::Forms::Label^ label76;
	private: System::Windows::Forms::Label^ lblSLocoType;

	private: System::Windows::Forms::Label^ label78;
	private: System::Windows::Forms::Label^ lblLocoDir;

	private: System::Windows::Forms::Label^ lblWinter;
	private: System::Windows::Forms::Label^ lblDirection;



	private: System::Windows::Forms::Label^ label61;
	private: System::Windows::Forms::Label^ label62;
	private: System::Windows::Forms::GroupBox^ gbLoco;
	private: System::Windows::Forms::Label^ label55;
	private: System::Windows::Forms::Label^ lblWindowL;

	private: System::Windows::Forms::Label^ label57;
	private: System::Windows::Forms::Label^ lblHorn;

	private: System::Windows::Forms::Label^ label80;
	private: System::Windows::Forms::Label^ lblCombined;


	private: System::Windows::Forms::Label^ label82;
	private: System::Windows::Forms::Label^ lblWhistle;

	private: System::Windows::Forms::Label^ label84;
	private: System::Windows::Forms::Label^ lblCoupling;


	private: System::Windows::Forms::Label^ label86;
	private: System::Windows::Forms::Label^ lblBattery1;

	private: System::Windows::Forms::Label^ label88;
	private: System::Windows::Forms::Label^ lblVilignance;

	private: System::Windows::Forms::Label^ label90;
	private: System::Windows::Forms::Label^ lblWhipers;

	private: System::Windows::Forms::Label^ label92;
	private: System::Windows::Forms::Label^ lblVH;

	private: System::Windows::Forms::Label^ label94;
	private: System::Windows::Forms::Label^ lblVHS;


	private: System::Windows::Forms::Label^ lblBattery2;

	private: System::Windows::Forms::Label^ label98;
	private: System::Windows::Forms::Label^ lblhighlights;
	private: System::Windows::Forms::Label^ lblAuxBrakeTank;




	private: System::Windows::Forms::Label^ label102;
	private: System::Windows::Forms::Label^ lblPressureLine;

	private: System::Windows::Forms::Label^ label104;
	private: System::Windows::Forms::Label^ lblBrakeLine;

	private: System::Windows::Forms::Label^ label106;
	private: System::Windows::Forms::Label^ lblBalanceTank;

	private: System::Windows::Forms::Label^ label109;
	private: System::Windows::Forms::Label^ lblWhipersDegree;

	private: System::Windows::Forms::Label^ label111;

	private: System::Windows::Forms::Label^ label113;
	private: System::Windows::Forms::Label^ lbl294;

	private: System::Windows::Forms::Label^ label115;
	private: System::Windows::Forms::Label^ lbl395;

	private: System::Windows::Forms::Label^ label117;
	private: System::Windows::Forms::Label^ lblSlipping;

	private: System::Windows::Forms::Label^ label119;
	private: System::Windows::Forms::Label^ lblReversor;

	private: System::Windows::Forms::Label^ label121;
	private: System::Windows::Forms::Label^ lblEPV;

	private: System::Windows::Forms::Label^ label123;
	private: System::Windows::Forms::Label^ lblAmperageEPB;


	private: System::Windows::Forms::GroupBox^ groupBox3;
	private: System::Windows::Forms::GroupBox^ groupBox5;
	private: System::Windows::Forms::Label^ label100;
	private: System::Windows::Forms::Label^ lblAmperageTE;



	private: System::Windows::Forms::Label^ label127;
	private: System::Windows::Forms::Label^ lblPositionSec1;
	private: System::Windows::Forms::Label^ lblPantFront;







	private: System::Windows::Forms::Label^ lblShunts;



	private: System::Windows::Forms::Label^ label137;
	private: System::Windows::Forms::Label^ lblPantRear;



	private: System::Windows::Forms::Label^ label141;
	private: System::Windows::Forms::Label^ lblLocoVoltage;



	private: System::Windows::Forms::Label^ label145;



	private: System::Windows::Forms::Label^ label149;
	private: System::Windows::Forms::Label^ lblAmperageTEUlt;




	private: System::Windows::Forms::Label^ label153;
	private: System::Windows::Forms::Label^ lblMVsTE;


	private: System::Windows::Forms::Label^ lblMVs;





	private: System::Windows::Forms::Label^ label161;
	private: System::Windows::Forms::GroupBox^ groupBox6;
	private: System::Windows::Forms::Label^ label112;

	private: System::Windows::Forms::Label^ label128;
	private: System::Windows::Forms::Label^ lblCHS7Controller;
	private: System::Windows::Forms::Label^ lblCHS7EPBSensor;


	private: System::Windows::Forms::Label^ label134;
	private: System::Windows::Forms::Label^ lblCHS7PositionSec2;

	private: System::Windows::Forms::Label^ label138;
	private: System::Windows::Forms::Label^ lblCHS7MK1;

	private: System::Windows::Forms::Label^ label142;
	private: System::Windows::Forms::Label^ lblCHS7MainSwitch;

	private: System::Windows::Forms::Label^ lblWindowR;
	private: System::Windows::Forms::Label^ lblCHS7MK2;
	private: System::Windows::Forms::Label^ label2;
	private: System::Windows::Forms::Label^ lblStationCount;
	private: System::Windows::Forms::GroupBox^ groupBox7;
	private: System::Windows::Forms::Label^ lblAcceleration;

	private: System::Windows::Forms::Label^ label6;

	private: System::Windows::Forms::Label^ label10;
	private: System::Windows::Forms::Label^ lblMovingOpposite;

	private: System::Windows::Forms::Label^ label15;
	private: System::Windows::Forms::Label^ lblSpeed;

	private: System::Windows::Forms::Label^ label17;
	private: System::Windows::Forms::Label^ lblOrdinate;

	private: System::Windows::Forms::Label^ label21;
	private: System::Windows::Forms::Label^ lblHeadTrack;



	private: System::Windows::Forms::Label^ label25;
	private: System::Windows::Forms::Label^ lblSpeedFact;

	private: System::Windows::Forms::Label^ label4;
private: System::Windows::Forms::Label^ lblTailTrack;

	private: System::Windows::Forms::Label^ lblWagonCount;
	private: System::Windows::Forms::Label^ lblLocoType;



































































	protected:

	private:
		System::ComponentModel::Container^ components;

#pragma region Windows Form Designer generated code
		void InitializeComponent(void) {
			this->gbConsist = (gcnew System::Windows::Forms::GroupBox());
			this->lblLocoType = (gcnew System::Windows::Forms::Label());
			this->lblLocoAxesCount = (gcnew System::Windows::Forms::Label());
			this->lblWagonAxesCount = (gcnew System::Windows::Forms::Label());
			this->label19 = (gcnew System::Windows::Forms::Label());
			this->label20 = (gcnew System::Windows::Forms::Label());
			this->lblLocoLength = (gcnew System::Windows::Forms::Label());
			this->lblWagonLenght = (gcnew System::Windows::Forms::Label());
			this->label14 = (gcnew System::Windows::Forms::Label());
			this->label13 = (gcnew System::Windows::Forms::Label());
			this->label11 = (gcnew System::Windows::Forms::Label());
			this->lblLocoSectionCount = (gcnew System::Windows::Forms::Label());
			this->label9 = (gcnew System::Windows::Forms::Label());
			this->label7 = (gcnew System::Windows::Forms::Label());
			this->lblConsistLength = (gcnew System::Windows::Forms::Label());
			this->label3 = (gcnew System::Windows::Forms::Label());
			this->lblAxesCount = (gcnew System::Windows::Forms::Label());
			this->label1 = (gcnew System::Windows::Forms::Label());
			this->lblConsistType = (gcnew System::Windows::Forms::Label());
			this->label5 = (gcnew System::Windows::Forms::Label());
			this->lblWagonCount = (gcnew System::Windows::Forms::Label());
			this->gbMisc = (gcnew System::Windows::Forms::GroupBox());
			this->label2 = (gcnew System::Windows::Forms::Label());
			this->lblStationCount = (gcnew System::Windows::Forms::Label());
			this->label37 = (gcnew System::Windows::Forms::Label());
			this->lblAtPassingStation = (gcnew System::Windows::Forms::Label());
			this->gbOncoming = (gcnew System::Windows::Forms::GroupBox());
			this->label43 = (gcnew System::Windows::Forms::Label());
			this->lblOStatus = (gcnew System::Windows::Forms::Label());
			this->label45 = (gcnew System::Windows::Forms::Label());
			this->lblOSpeed = (gcnew System::Windows::Forms::Label());
			this->label47 = (gcnew System::Windows::Forms::Label());
			this->lblOOrdinate = (gcnew System::Windows::Forms::Label());
			this->label49 = (gcnew System::Windows::Forms::Label());
			this->lblOOrdinateDelta = (gcnew System::Windows::Forms::Label());
			this->label51 = (gcnew System::Windows::Forms::Label());
			this->lblOOrdinateDiff = (gcnew System::Windows::Forms::Label());
			this->label53 = (gcnew System::Windows::Forms::Label());
			this->lblOTrack = (gcnew System::Windows::Forms::Label());
			this->lblOLocoAxesCount = (gcnew System::Windows::Forms::Label());
			this->lblOWagonAxesCount = (gcnew System::Windows::Forms::Label());
			this->label23 = (gcnew System::Windows::Forms::Label());
			this->label24 = (gcnew System::Windows::Forms::Label());
			this->lblOLocoLength = (gcnew System::Windows::Forms::Label());
			this->lblOWagonLenght = (gcnew System::Windows::Forms::Label());
			this->label27 = (gcnew System::Windows::Forms::Label());
			this->label28 = (gcnew System::Windows::Forms::Label());
			this->label29 = (gcnew System::Windows::Forms::Label());
			this->lblOLocoSectionCount = (gcnew System::Windows::Forms::Label());
			this->label31 = (gcnew System::Windows::Forms::Label());
			this->lblOLocoType = (gcnew System::Windows::Forms::Label());
			this->label33 = (gcnew System::Windows::Forms::Label());
			this->lblOConsistLength = (gcnew System::Windows::Forms::Label());
			this->label35 = (gcnew System::Windows::Forms::Label());
			this->lblOAxesCount = (gcnew System::Windows::Forms::Label());
			this->label39 = (gcnew System::Windows::Forms::Label());
			this->lblOConsistType = (gcnew System::Windows::Forms::Label());
			this->label41 = (gcnew System::Windows::Forms::Label());
			this->lblOWagonCount = (gcnew System::Windows::Forms::Label());
			this->gbROM = (gcnew System::Windows::Forms::GroupBox());
			this->gbRAM = (gcnew System::Windows::Forms::GroupBox());
			this->groupBox7 = (gcnew System::Windows::Forms::GroupBox());
			this->label4 = (gcnew System::Windows::Forms::Label());
			this->lblTailTrack = (gcnew System::Windows::Forms::Label());
			this->label10 = (gcnew System::Windows::Forms::Label());
			this->lblMovingOpposite = (gcnew System::Windows::Forms::Label());
			this->label15 = (gcnew System::Windows::Forms::Label());
			this->lblSpeed = (gcnew System::Windows::Forms::Label());
			this->label17 = (gcnew System::Windows::Forms::Label());
			this->lblOrdinate = (gcnew System::Windows::Forms::Label());
			this->label21 = (gcnew System::Windows::Forms::Label());
			this->lblHeadTrack = (gcnew System::Windows::Forms::Label());
			this->label25 = (gcnew System::Windows::Forms::Label());
			this->lblSpeedFact = (gcnew System::Windows::Forms::Label());
			this->lblAcceleration = (gcnew System::Windows::Forms::Label());
			this->label6 = (gcnew System::Windows::Forms::Label());
			this->gbLoco = (gcnew System::Windows::Forms::GroupBox());
			this->groupBox6 = (gcnew System::Windows::Forms::GroupBox());
			this->lblCHS7MK2 = (gcnew System::Windows::Forms::Label());
			this->label112 = (gcnew System::Windows::Forms::Label());
			this->label128 = (gcnew System::Windows::Forms::Label());
			this->lblCHS7Controller = (gcnew System::Windows::Forms::Label());
			this->lblCHS7EPBSensor = (gcnew System::Windows::Forms::Label());
			this->label134 = (gcnew System::Windows::Forms::Label());
			this->lblCHS7PositionSec2 = (gcnew System::Windows::Forms::Label());
			this->label138 = (gcnew System::Windows::Forms::Label());
			this->lblCHS7MK1 = (gcnew System::Windows::Forms::Label());
			this->label142 = (gcnew System::Windows::Forms::Label());
			this->lblCHS7MainSwitch = (gcnew System::Windows::Forms::Label());
			this->groupBox5 = (gcnew System::Windows::Forms::GroupBox());
			this->label100 = (gcnew System::Windows::Forms::Label());
			this->lblAmperageTE = (gcnew System::Windows::Forms::Label());
			this->label127 = (gcnew System::Windows::Forms::Label());
			this->lblPositionSec1 = (gcnew System::Windows::Forms::Label());
			this->lblPantFront = (gcnew System::Windows::Forms::Label());
			this->lblShunts = (gcnew System::Windows::Forms::Label());
			this->label137 = (gcnew System::Windows::Forms::Label());
			this->lblPantRear = (gcnew System::Windows::Forms::Label());
			this->label141 = (gcnew System::Windows::Forms::Label());
			this->lblLocoVoltage = (gcnew System::Windows::Forms::Label());
			this->label145 = (gcnew System::Windows::Forms::Label());
			this->label149 = (gcnew System::Windows::Forms::Label());
			this->lblAmperageTEUlt = (gcnew System::Windows::Forms::Label());
			this->label153 = (gcnew System::Windows::Forms::Label());
			this->lblMVsTE = (gcnew System::Windows::Forms::Label());
			this->lblMVs = (gcnew System::Windows::Forms::Label());
			this->label161 = (gcnew System::Windows::Forms::Label());
			this->groupBox3 = (gcnew System::Windows::Forms::GroupBox());
			this->lblWindowR = (gcnew System::Windows::Forms::Label());
			this->label84 = (gcnew System::Windows::Forms::Label());
			this->lblAuxBrakeTank = (gcnew System::Windows::Forms::Label());
			this->lblBattery1 = (gcnew System::Windows::Forms::Label());
			this->label102 = (gcnew System::Windows::Forms::Label());
			this->label86 = (gcnew System::Windows::Forms::Label());
			this->lblPressureLine = (gcnew System::Windows::Forms::Label());
			this->lblCoupling = (gcnew System::Windows::Forms::Label());
			this->label104 = (gcnew System::Windows::Forms::Label());
			this->lblWhistle = (gcnew System::Windows::Forms::Label());
			this->lblBrakeLine = (gcnew System::Windows::Forms::Label());
			this->label82 = (gcnew System::Windows::Forms::Label());
			this->label106 = (gcnew System::Windows::Forms::Label());
			this->lblCombined = (gcnew System::Windows::Forms::Label());
			this->lblBalanceTank = (gcnew System::Windows::Forms::Label());
			this->label80 = (gcnew System::Windows::Forms::Label());
			this->label109 = (gcnew System::Windows::Forms::Label());
			this->lblHorn = (gcnew System::Windows::Forms::Label());
			this->lblWhipersDegree = (gcnew System::Windows::Forms::Label());
			this->label57 = (gcnew System::Windows::Forms::Label());
			this->label111 = (gcnew System::Windows::Forms::Label());
			this->lblWindowL = (gcnew System::Windows::Forms::Label());
			this->label113 = (gcnew System::Windows::Forms::Label());
			this->label55 = (gcnew System::Windows::Forms::Label());
			this->lbl294 = (gcnew System::Windows::Forms::Label());
			this->lblhighlights = (gcnew System::Windows::Forms::Label());
			this->label115 = (gcnew System::Windows::Forms::Label());
			this->label98 = (gcnew System::Windows::Forms::Label());
			this->lbl395 = (gcnew System::Windows::Forms::Label());
			this->lblBattery2 = (gcnew System::Windows::Forms::Label());
			this->label117 = (gcnew System::Windows::Forms::Label());
			this->lblSlipping = (gcnew System::Windows::Forms::Label());
			this->lblVHS = (gcnew System::Windows::Forms::Label());
			this->label119 = (gcnew System::Windows::Forms::Label());
			this->label94 = (gcnew System::Windows::Forms::Label());
			this->lblReversor = (gcnew System::Windows::Forms::Label());
			this->lblVH = (gcnew System::Windows::Forms::Label());
			this->label121 = (gcnew System::Windows::Forms::Label());
			this->label92 = (gcnew System::Windows::Forms::Label());
			this->lblEPV = (gcnew System::Windows::Forms::Label());
			this->lblWhipers = (gcnew System::Windows::Forms::Label());
			this->label123 = (gcnew System::Windows::Forms::Label());
			this->label90 = (gcnew System::Windows::Forms::Label());
			this->lblAmperageEPB = (gcnew System::Windows::Forms::Label());
			this->lblVilignance = (gcnew System::Windows::Forms::Label());
			this->label88 = (gcnew System::Windows::Forms::Label());
			this->groupBox1 = (gcnew System::Windows::Forms::GroupBox());
			this->lblWinter = (gcnew System::Windows::Forms::Label());
			this->lblDirection = (gcnew System::Windows::Forms::Label());
			this->label61 = (gcnew System::Windows::Forms::Label());
			this->label62 = (gcnew System::Windows::Forms::Label());
			this->label63 = (gcnew System::Windows::Forms::Label());
			this->lblConsist = (gcnew System::Windows::Forms::Label());
			this->label65 = (gcnew System::Windows::Forms::Label());
			this->lblScenery = (gcnew System::Windows::Forms::Label());
			this->label69 = (gcnew System::Windows::Forms::Label());
			this->lblSWagonCount = (gcnew System::Windows::Forms::Label());
			this->label74 = (gcnew System::Windows::Forms::Label());
			this->lblRoute = (gcnew System::Windows::Forms::Label());
			this->label76 = (gcnew System::Windows::Forms::Label());
			this->lblSLocoType = (gcnew System::Windows::Forms::Label());
			this->label78 = (gcnew System::Windows::Forms::Label());
			this->lblLocoDir = (gcnew System::Windows::Forms::Label());
			this->groupBox2 = (gcnew System::Windows::Forms::GroupBox());
			this->label67 = (gcnew System::Windows::Forms::Label());
			this->lblPause = (gcnew System::Windows::Forms::Label());
			this->label71 = (gcnew System::Windows::Forms::Label());
			this->lblConnected = (gcnew System::Windows::Forms::Label());
			this->groupBox4 = (gcnew System::Windows::Forms::GroupBox());
			this->lblRain = (gcnew System::Windows::Forms::Label());
			this->label73 = (gcnew System::Windows::Forms::Label());
			this->gbConsist->SuspendLayout();
			this->gbMisc->SuspendLayout();
			this->gbOncoming->SuspendLayout();
			this->gbROM->SuspendLayout();
			this->gbRAM->SuspendLayout();
			this->groupBox7->SuspendLayout();
			this->gbLoco->SuspendLayout();
			this->groupBox6->SuspendLayout();
			this->groupBox5->SuspendLayout();
			this->groupBox3->SuspendLayout();
			this->groupBox1->SuspendLayout();
			this->groupBox2->SuspendLayout();
			this->groupBox4->SuspendLayout();
			this->SuspendLayout();
			// 
			// gbConsist
			// 
			this->gbConsist->Controls->Add(this->lblLocoType);
			this->gbConsist->Controls->Add(this->lblLocoAxesCount);
			this->gbConsist->Controls->Add(this->lblWagonAxesCount);
			this->gbConsist->Controls->Add(this->label19);
			this->gbConsist->Controls->Add(this->label20);
			this->gbConsist->Controls->Add(this->lblLocoLength);
			this->gbConsist->Controls->Add(this->lblWagonLenght);
			this->gbConsist->Controls->Add(this->label14);
			this->gbConsist->Controls->Add(this->label13);
			this->gbConsist->Controls->Add(this->label11);
			this->gbConsist->Controls->Add(this->lblLocoSectionCount);
			this->gbConsist->Controls->Add(this->label9);
			this->gbConsist->Controls->Add(this->label7);
			this->gbConsist->Controls->Add(this->lblConsistLength);
			this->gbConsist->Controls->Add(this->label3);
			this->gbConsist->Controls->Add(this->lblAxesCount);
			this->gbConsist->Controls->Add(this->label1);
			this->gbConsist->Controls->Add(this->lblConsistType);
			this->gbConsist->Controls->Add(this->label5);
			this->gbConsist->Controls->Add(this->lblWagonCount);
			this->gbConsist->Location = System::Drawing::Point(6, 19);
			this->gbConsist->Name = L"gbConsist";
			this->gbConsist->Size = System::Drawing::Size(445, 139);
			this->gbConsist->TabIndex = 0;
			this->gbConsist->TabStop = false;
			this->gbConsist->Text = L"Consist";
			// 
			// lblLocoType
			// 
			this->lblLocoType->AutoSize = true;
			this->lblLocoType->Location = System::Drawing::Point(110, 74);
			this->lblLocoType->Name = L"lblLocoType";
			this->lblLocoType->Size = System::Drawing::Size(10, 13);
			this->lblLocoType->TabIndex = 35;
			this->lblLocoType->Text = L"-";
			// 
			// lblLocoAxesCount
			// 
			this->lblLocoAxesCount->AutoSize = true;
			this->lblLocoAxesCount->Location = System::Drawing::Point(406, 92);
			this->lblLocoAxesCount->Name = L"lblLocoAxesCount";
			this->lblLocoAxesCount->Size = System::Drawing::Size(10, 13);
			this->lblLocoAxesCount->TabIndex = 20;
			this->lblLocoAxesCount->Text = L"-";
			// 
			// lblWagonAxesCount
			// 
			this->lblWagonAxesCount->AutoSize = true;
			this->lblWagonAxesCount->Location = System::Drawing::Point(406, 110);
			this->lblWagonAxesCount->Name = L"lblWagonAxesCount";
			this->lblWagonAxesCount->Size = System::Drawing::Size(10, 13);
			this->lblWagonAxesCount->TabIndex = 19;
			this->lblWagonAxesCount->Text = L"-";
			// 
			// label19
			// 
			this->label19->AutoSize = true;
			this->label19->Location = System::Drawing::Point(303, 110);
			this->label19->Name = L"label19";
			this->label19->Size = System::Drawing::Size(97, 13);
			this->label19->TabIndex = 18;
			this->label19->Text = L"Wagon axes count";
			// 
			// label20
			// 
			this->label20->AutoSize = true;
			this->label20->Location = System::Drawing::Point(303, 92);
			this->label20->Name = L"label20";
			this->label20->Size = System::Drawing::Size(86, 13);
			this->label20->TabIndex = 17;
			this->label20->Text = L"Loco axes count";
			// 
			// lblLocoLength
			// 
			this->lblLocoLength->AutoSize = true;
			this->lblLocoLength->Location = System::Drawing::Point(262, 92);
			this->lblLocoLength->Name = L"lblLocoLength";
			this->lblLocoLength->Size = System::Drawing::Size(10, 13);
			this->lblLocoLength->TabIndex = 16;
			this->lblLocoLength->Text = L"-";
			// 
			// lblWagonLenght
			// 
			this->lblWagonLenght->AutoSize = true;
			this->lblWagonLenght->Location = System::Drawing::Point(262, 110);
			this->lblWagonLenght->Name = L"lblWagonLenght";
			this->lblWagonLenght->Size = System::Drawing::Size(10, 13);
			this->lblWagonLenght->TabIndex = 15;
			this->lblWagonLenght->Text = L"-";
			// 
			// label14
			// 
			this->label14->AutoSize = true;
			this->label14->Location = System::Drawing::Point(157, 110);
			this->label14->Name = L"label14";
			this->label14->Size = System::Drawing::Size(99, 13);
			this->label14->TabIndex = 14;
			this->label14->Text = L"Wagon length (mm)";
			// 
			// label13
			// 
			this->label13->AutoSize = true;
			this->label13->Location = System::Drawing::Point(157, 92);
			this->label13->Name = L"label13";
			this->label13->Size = System::Drawing::Size(88, 13);
			this->label13->TabIndex = 13;
			this->label13->Text = L"Loco length (mm)";
			// 
			// label11
			// 
			this->label11->AutoSize = true;
			this->label11->Location = System::Drawing::Point(6, 110);
			this->label11->Name = L"label11";
			this->label11->Size = System::Drawing::Size(77, 13);
			this->label11->TabIndex = 12;
			this->label11->Text = L"Wagons count";
			// 
			// lblLocoSectionCount
			// 
			this->lblLocoSectionCount->AutoSize = true;
			this->lblLocoSectionCount->Location = System::Drawing::Point(110, 92);
			this->lblLocoSectionCount->Name = L"lblLocoSectionCount";
			this->lblLocoSectionCount->Size = System::Drawing::Size(10, 13);
			this->lblLocoSectionCount->TabIndex = 11;
			this->lblLocoSectionCount->Text = L"-";
			// 
			// label9
			// 
			this->label9->AutoSize = true;
			this->label9->Location = System::Drawing::Point(6, 92);
			this->label9->Name = L"label9";
			this->label9->Size = System::Drawing::Size(98, 13);
			this->label9->TabIndex = 10;
			this->label9->Text = L"Loco section count";
			// 
			// label7
			// 
			this->label7->AutoSize = true;
			this->label7->Location = System::Drawing::Point(6, 38);
			this->label7->Name = L"label7";
			this->label7->Size = System::Drawing::Size(98, 13);
			this->label7->TabIndex = 8;
			this->label7->Text = L"Consist length (mm)";
			// 
			// lblConsistLength
			// 
			this->lblConsistLength->AutoSize = true;
			this->lblConsistLength->Location = System::Drawing::Point(110, 38);
			this->lblConsistLength->Name = L"lblConsistLength";
			this->lblConsistLength->Size = System::Drawing::Size(10, 13);
			this->lblConsistLength->TabIndex = 7;
			this->lblConsistLength->Text = L"-";
			// 
			// label3
			// 
			this->label3->AutoSize = true;
			this->label3->Location = System::Drawing::Point(6, 74);
			this->label3->Name = L"label3";
			this->label3->Size = System::Drawing::Size(54, 13);
			this->label3->TabIndex = 6;
			this->label3->Text = L"Loco type";
			// 
			// lblAxesCount
			// 
			this->lblAxesCount->AutoSize = true;
			this->lblAxesCount->Location = System::Drawing::Point(110, 56);
			this->lblAxesCount->Name = L"lblAxesCount";
			this->lblAxesCount->Size = System::Drawing::Size(10, 13);
			this->lblAxesCount->TabIndex = 5;
			this->lblAxesCount->Text = L"-";
			// 
			// label1
			// 
			this->label1->AutoSize = true;
			this->label1->Location = System::Drawing::Point(6, 20);
			this->label1->Name = L"label1";
			this->label1->Size = System::Drawing::Size(64, 13);
			this->label1->TabIndex = 4;
			this->label1->Text = L"Consist type";
			// 
			// lblConsistType
			// 
			this->lblConsistType->AutoSize = true;
			this->lblConsistType->Location = System::Drawing::Point(110, 20);
			this->lblConsistType->Name = L"lblConsistType";
			this->lblConsistType->Size = System::Drawing::Size(10, 13);
			this->lblConsistType->TabIndex = 3;
			this->lblConsistType->Text = L"-";
			this->lblConsistType->TextAlign = System::Drawing::ContentAlignment::BottomCenter;
			// 
			// label5
			// 
			this->label5->AutoSize = true;
			this->label5->Location = System::Drawing::Point(6, 56);
			this->label5->Name = L"label5";
			this->label5->Size = System::Drawing::Size(60, 13);
			this->label5->TabIndex = 2;
			this->label5->Text = L"Axes count";
			// 
			// lblWagonCount
			// 
			this->lblWagonCount->AutoSize = true;
			this->lblWagonCount->Location = System::Drawing::Point(110, 110);
			this->lblWagonCount->Name = L"lblWagonCount";
			this->lblWagonCount->Size = System::Drawing::Size(10, 13);
			this->lblWagonCount->TabIndex = 1;
			this->lblWagonCount->Text = L"-";
			// 
			// gbMisc
			// 
			this->gbMisc->Controls->Add(this->label2);
			this->gbMisc->Controls->Add(this->lblStationCount);
			this->gbMisc->Controls->Add(this->label37);
			this->gbMisc->Controls->Add(this->lblAtPassingStation);
			this->gbMisc->Location = System::Drawing::Point(6, 435);
			this->gbMisc->Name = L"gbMisc";
			this->gbMisc->Size = System::Drawing::Size(445, 48);
			this->gbMisc->TabIndex = 21;
			this->gbMisc->TabStop = false;
			this->gbMisc->Text = L"Misc";
			// 
			// label2
			// 
			this->label2->AutoSize = true;
			this->label2->Location = System::Drawing::Point(153, 20);
			this->label2->Name = L"label2";
			this->label2->Size = System::Drawing::Size(70, 13);
			this->label2->TabIndex = 6;
			this->label2->Text = L"Station count";
			// 
			// lblStationCount
			// 
			this->lblStationCount->AutoSize = true;
			this->lblStationCount->Location = System::Drawing::Point(262, 20);
			this->lblStationCount->Name = L"lblStationCount";
			this->lblStationCount->Size = System::Drawing::Size(10, 13);
			this->lblStationCount->TabIndex = 5;
			this->lblStationCount->Text = L"-";
			// 
			// label37
			// 
			this->label37->AutoSize = true;
			this->label37->Location = System::Drawing::Point(6, 20);
			this->label37->Name = L"label37";
			this->label37->Size = System::Drawing::Size(98, 13);
			this->label37->TabIndex = 4;
			this->label37->Text = L"At / passing station";
			// 
			// lblAtPassingStation
			// 
			this->lblAtPassingStation->AutoSize = true;
			this->lblAtPassingStation->Location = System::Drawing::Point(115, 20);
			this->lblAtPassingStation->Name = L"lblAtPassingStation";
			this->lblAtPassingStation->Size = System::Drawing::Size(10, 13);
			this->lblAtPassingStation->TabIndex = 3;
			this->lblAtPassingStation->Text = L"-";
			// 
			// gbOncoming
			// 
			this->gbOncoming->Controls->Add(this->label43);
			this->gbOncoming->Controls->Add(this->lblOStatus);
			this->gbOncoming->Controls->Add(this->label45);
			this->gbOncoming->Controls->Add(this->lblOSpeed);
			this->gbOncoming->Controls->Add(this->label47);
			this->gbOncoming->Controls->Add(this->lblOOrdinate);
			this->gbOncoming->Controls->Add(this->label49);
			this->gbOncoming->Controls->Add(this->lblOOrdinateDelta);
			this->gbOncoming->Controls->Add(this->label51);
			this->gbOncoming->Controls->Add(this->lblOOrdinateDiff);
			this->gbOncoming->Controls->Add(this->label53);
			this->gbOncoming->Controls->Add(this->lblOTrack);
			this->gbOncoming->Controls->Add(this->lblOLocoAxesCount);
			this->gbOncoming->Controls->Add(this->lblOWagonAxesCount);
			this->gbOncoming->Controls->Add(this->label23);
			this->gbOncoming->Controls->Add(this->label24);
			this->gbOncoming->Controls->Add(this->lblOLocoLength);
			this->gbOncoming->Controls->Add(this->lblOWagonLenght);
			this->gbOncoming->Controls->Add(this->label27);
			this->gbOncoming->Controls->Add(this->label28);
			this->gbOncoming->Controls->Add(this->label29);
			this->gbOncoming->Controls->Add(this->lblOLocoSectionCount);
			this->gbOncoming->Controls->Add(this->label31);
			this->gbOncoming->Controls->Add(this->lblOLocoType);
			this->gbOncoming->Controls->Add(this->label33);
			this->gbOncoming->Controls->Add(this->lblOConsistLength);
			this->gbOncoming->Controls->Add(this->label35);
			this->gbOncoming->Controls->Add(this->lblOAxesCount);
			this->gbOncoming->Controls->Add(this->label39);
			this->gbOncoming->Controls->Add(this->lblOConsistType);
			this->gbOncoming->Controls->Add(this->label41);
			this->gbOncoming->Controls->Add(this->lblOWagonCount);
			this->gbOncoming->Location = System::Drawing::Point(6, 164);
			this->gbOncoming->Name = L"gbOncoming";
			this->gbOncoming->Size = System::Drawing::Size(445, 265);
			this->gbOncoming->TabIndex = 21;
			this->gbOncoming->TabStop = false;
			this->gbOncoming->Text = L"Oncoming";
			// 
			// label43
			// 
			this->label43->AutoSize = true;
			this->label43->Location = System::Drawing::Point(6, 233);
			this->label43->Name = L"label43";
			this->label43->Size = System::Drawing::Size(37, 13);
			this->label43->TabIndex = 34;
			this->label43->Text = L"Status";
			// 
			// lblOStatus
			// 
			this->lblOStatus->AutoSize = true;
			this->lblOStatus->Location = System::Drawing::Point(110, 233);
			this->lblOStatus->Name = L"lblOStatus";
			this->lblOStatus->Size = System::Drawing::Size(10, 13);
			this->lblOStatus->TabIndex = 33;
			this->lblOStatus->Text = L"-";
			// 
			// label45
			// 
			this->label45->AutoSize = true;
			this->label45->Location = System::Drawing::Point(6, 215);
			this->label45->Name = L"label45";
			this->label45->Size = System::Drawing::Size(35, 13);
			this->label45->TabIndex = 32;
			this->label45->Text = L"Track";
			// 
			// lblOSpeed
			// 
			this->lblOSpeed->AutoSize = true;
			this->lblOSpeed->Location = System::Drawing::Point(110, 197);
			this->lblOSpeed->Name = L"lblOSpeed";
			this->lblOSpeed->Size = System::Drawing::Size(10, 13);
			this->lblOSpeed->TabIndex = 31;
			this->lblOSpeed->Text = L"-";
			// 
			// label47
			// 
			this->label47->AutoSize = true;
			this->label47->Location = System::Drawing::Point(6, 197);
			this->label47->Name = L"label47";
			this->label47->Size = System::Drawing::Size(65, 13);
			this->label47->TabIndex = 30;
			this->label47->Text = L"Speed (m/s)";
			// 
			// lblOOrdinate
			// 
			this->lblOOrdinate->AutoSize = true;
			this->lblOOrdinate->Location = System::Drawing::Point(110, 179);
			this->lblOOrdinate->Name = L"lblOOrdinate";
			this->lblOOrdinate->Size = System::Drawing::Size(10, 13);
			this->lblOOrdinate->TabIndex = 29;
			this->lblOOrdinate->Text = L"-";
			// 
			// label49
			// 
			this->label49->AutoSize = true;
			this->label49->Location = System::Drawing::Point(6, 143);
			this->label49->Name = L"label49";
			this->label49->Size = System::Drawing::Size(100, 13);
			this->label49->TabIndex = 28;
			this->label49->Text = L"Ordinate delta (m/s)";
			// 
			// lblOOrdinateDelta
			// 
			this->lblOOrdinateDelta->AutoSize = true;
			this->lblOOrdinateDelta->Location = System::Drawing::Point(110, 143);
			this->lblOOrdinateDelta->Name = L"lblOOrdinateDelta";
			this->lblOOrdinateDelta->Size = System::Drawing::Size(10, 13);
			this->lblOOrdinateDelta->TabIndex = 27;
			this->lblOOrdinateDelta->Text = L"-";
			// 
			// label51
			// 
			this->label51->AutoSize = true;
			this->label51->Location = System::Drawing::Point(6, 179);
			this->label51->Name = L"label51";
			this->label51->Size = System::Drawing::Size(47, 13);
			this->label51->TabIndex = 26;
			this->label51->Text = L"Ordinate";
			// 
			// lblOOrdinateDiff
			// 
			this->lblOOrdinateDiff->AutoSize = true;
			this->lblOOrdinateDiff->Location = System::Drawing::Point(110, 161);
			this->lblOOrdinateDiff->Name = L"lblOOrdinateDiff";
			this->lblOOrdinateDiff->Size = System::Drawing::Size(10, 13);
			this->lblOOrdinateDiff->TabIndex = 25;
			this->lblOOrdinateDiff->Text = L"-";
			// 
			// label53
			// 
			this->label53->AutoSize = true;
			this->label53->Location = System::Drawing::Point(6, 161);
			this->label53->Name = L"label53";
			this->label53->Size = System::Drawing::Size(81, 13);
			this->label53->TabIndex = 24;
			this->label53->Text = L"Ordinate diff (m)";
			// 
			// lblOTrack
			// 
			this->lblOTrack->AutoSize = true;
			this->lblOTrack->Location = System::Drawing::Point(110, 215);
			this->lblOTrack->Name = L"lblOTrack";
			this->lblOTrack->Size = System::Drawing::Size(10, 13);
			this->lblOTrack->TabIndex = 23;
			this->lblOTrack->Text = L"-";
			// 
			// lblOLocoAxesCount
			// 
			this->lblOLocoAxesCount->AutoSize = true;
			this->lblOLocoAxesCount->Location = System::Drawing::Point(406, 92);
			this->lblOLocoAxesCount->Name = L"lblOLocoAxesCount";
			this->lblOLocoAxesCount->Size = System::Drawing::Size(10, 13);
			this->lblOLocoAxesCount->TabIndex = 20;
			this->lblOLocoAxesCount->Text = L"-";
			// 
			// lblOWagonAxesCount
			// 
			this->lblOWagonAxesCount->AutoSize = true;
			this->lblOWagonAxesCount->Location = System::Drawing::Point(406, 110);
			this->lblOWagonAxesCount->Name = L"lblOWagonAxesCount";
			this->lblOWagonAxesCount->Size = System::Drawing::Size(10, 13);
			this->lblOWagonAxesCount->TabIndex = 19;
			this->lblOWagonAxesCount->Text = L"-";
			// 
			// label23
			// 
			this->label23->AutoSize = true;
			this->label23->Location = System::Drawing::Point(303, 110);
			this->label23->Name = L"label23";
			this->label23->Size = System::Drawing::Size(97, 13);
			this->label23->TabIndex = 18;
			this->label23->Text = L"Wagon axes count";
			// 
			// label24
			// 
			this->label24->AutoSize = true;
			this->label24->Location = System::Drawing::Point(303, 92);
			this->label24->Name = L"label24";
			this->label24->Size = System::Drawing::Size(86, 13);
			this->label24->TabIndex = 17;
			this->label24->Text = L"Loco axes count";
			// 
			// lblOLocoLength
			// 
			this->lblOLocoLength->AutoSize = true;
			this->lblOLocoLength->Location = System::Drawing::Point(262, 92);
			this->lblOLocoLength->Name = L"lblOLocoLength";
			this->lblOLocoLength->Size = System::Drawing::Size(10, 13);
			this->lblOLocoLength->TabIndex = 16;
			this->lblOLocoLength->Text = L"-";
			// 
			// lblOWagonLenght
			// 
			this->lblOWagonLenght->AutoSize = true;
			this->lblOWagonLenght->Location = System::Drawing::Point(262, 110);
			this->lblOWagonLenght->Name = L"lblOWagonLenght";
			this->lblOWagonLenght->Size = System::Drawing::Size(10, 13);
			this->lblOWagonLenght->TabIndex = 15;
			this->lblOWagonLenght->Text = L"-";
			// 
			// label27
			// 
			this->label27->AutoSize = true;
			this->label27->Location = System::Drawing::Point(157, 110);
			this->label27->Name = L"label27";
			this->label27->Size = System::Drawing::Size(99, 13);
			this->label27->TabIndex = 14;
			this->label27->Text = L"Wagon length (mm)";
			// 
			// label28
			// 
			this->label28->AutoSize = true;
			this->label28->Location = System::Drawing::Point(157, 92);
			this->label28->Name = L"label28";
			this->label28->Size = System::Drawing::Size(88, 13);
			this->label28->TabIndex = 13;
			this->label28->Text = L"Loco length (mm)";
			// 
			// label29
			// 
			this->label29->AutoSize = true;
			this->label29->Location = System::Drawing::Point(6, 110);
			this->label29->Name = L"label29";
			this->label29->Size = System::Drawing::Size(72, 13);
			this->label29->TabIndex = 12;
			this->label29->Text = L"Wagon count";
			// 
			// lblOLocoSectionCount
			// 
			this->lblOLocoSectionCount->AutoSize = true;
			this->lblOLocoSectionCount->Location = System::Drawing::Point(110, 92);
			this->lblOLocoSectionCount->Name = L"lblOLocoSectionCount";
			this->lblOLocoSectionCount->Size = System::Drawing::Size(10, 13);
			this->lblOLocoSectionCount->TabIndex = 11;
			this->lblOLocoSectionCount->Text = L"-";
			// 
			// label31
			// 
			this->label31->AutoSize = true;
			this->label31->Location = System::Drawing::Point(6, 92);
			this->label31->Name = L"label31";
			this->label31->Size = System::Drawing::Size(98, 13);
			this->label31->TabIndex = 10;
			this->label31->Text = L"Loco section count";
			// 
			// lblOLocoType
			// 
			this->lblOLocoType->AutoSize = true;
			this->lblOLocoType->Location = System::Drawing::Point(110, 74);
			this->lblOLocoType->Name = L"lblOLocoType";
			this->lblOLocoType->Size = System::Drawing::Size(10, 13);
			this->lblOLocoType->TabIndex = 9;
			this->lblOLocoType->Text = L"-";
			// 
			// label33
			// 
			this->label33->AutoSize = true;
			this->label33->Location = System::Drawing::Point(6, 38);
			this->label33->Name = L"label33";
			this->label33->Size = System::Drawing::Size(98, 13);
			this->label33->TabIndex = 8;
			this->label33->Text = L"Consist length (mm)";
			// 
			// lblOConsistLength
			// 
			this->lblOConsistLength->AutoSize = true;
			this->lblOConsistLength->Location = System::Drawing::Point(110, 38);
			this->lblOConsistLength->Name = L"lblOConsistLength";
			this->lblOConsistLength->Size = System::Drawing::Size(10, 13);
			this->lblOConsistLength->TabIndex = 7;
			this->lblOConsistLength->Text = L"-";
			// 
			// label35
			// 
			this->label35->AutoSize = true;
			this->label35->Location = System::Drawing::Point(6, 74);
			this->label35->Name = L"label35";
			this->label35->Size = System::Drawing::Size(54, 13);
			this->label35->TabIndex = 6;
			this->label35->Text = L"Loco type";
			// 
			// lblOAxesCount
			// 
			this->lblOAxesCount->AutoSize = true;
			this->lblOAxesCount->Location = System::Drawing::Point(110, 56);
			this->lblOAxesCount->Name = L"lblOAxesCount";
			this->lblOAxesCount->Size = System::Drawing::Size(10, 13);
			this->lblOAxesCount->TabIndex = 5;
			this->lblOAxesCount->Text = L"-";
			// 
			// label39
			// 
			this->label39->AutoSize = true;
			this->label39->Location = System::Drawing::Point(6, 20);
			this->label39->Name = L"label39";
			this->label39->Size = System::Drawing::Size(64, 13);
			this->label39->TabIndex = 4;
			this->label39->Text = L"Consist type";
			// 
			// lblOConsistType
			// 
			this->lblOConsistType->AutoSize = true;
			this->lblOConsistType->Location = System::Drawing::Point(110, 20);
			this->lblOConsistType->Name = L"lblOConsistType";
			this->lblOConsistType->Size = System::Drawing::Size(10, 13);
			this->lblOConsistType->TabIndex = 3;
			this->lblOConsistType->Text = L"-";
			// 
			// label41
			// 
			this->label41->AutoSize = true;
			this->label41->Location = System::Drawing::Point(6, 56);
			this->label41->Name = L"label41";
			this->label41->Size = System::Drawing::Size(60, 13);
			this->label41->TabIndex = 2;
			this->label41->Text = L"Axes count";
			// 
			// lblOWagonCount
			// 
			this->lblOWagonCount->AutoSize = true;
			this->lblOWagonCount->Location = System::Drawing::Point(110, 110);
			this->lblOWagonCount->Name = L"lblOWagonCount";
			this->lblOWagonCount->Size = System::Drawing::Size(10, 13);
			this->lblOWagonCount->TabIndex = 1;
			this->lblOWagonCount->Text = L"-";
			// 
			// gbROM
			// 
			this->gbROM->Controls->Add(this->gbConsist);
			this->gbROM->Controls->Add(this->gbOncoming);
			this->gbROM->Controls->Add(this->gbMisc);
			this->gbROM->Location = System::Drawing::Point(12, 12);
			this->gbROM->Name = L"gbROM";
			this->gbROM->Size = System::Drawing::Size(457, 489);
			this->gbROM->TabIndex = 21;
			this->gbROM->TabStop = false;
			this->gbROM->Text = L"ROM";
			// 
			// gbRAM
			// 
			this->gbRAM->Controls->Add(this->groupBox7);
			this->gbRAM->Controls->Add(this->gbLoco);
			this->gbRAM->Controls->Add(this->groupBox1);
			this->gbRAM->Controls->Add(this->groupBox2);
			this->gbRAM->Controls->Add(this->groupBox4);
			this->gbRAM->Location = System::Drawing::Point(475, 12);
			this->gbRAM->Name = L"gbRAM";
			this->gbRAM->Size = System::Drawing::Size(934, 489);
			this->gbRAM->TabIndex = 22;
			this->gbRAM->TabStop = false;
			this->gbRAM->Text = L"RAM";
			// 
			// groupBox7
			// 
			this->groupBox7->Controls->Add(this->label4);
			this->groupBox7->Controls->Add(this->lblTailTrack);
			this->groupBox7->Controls->Add(this->label10);
			this->groupBox7->Controls->Add(this->lblMovingOpposite);
			this->groupBox7->Controls->Add(this->label15);
			this->groupBox7->Controls->Add(this->lblSpeed);
			this->groupBox7->Controls->Add(this->label17);
			this->groupBox7->Controls->Add(this->lblOrdinate);
			this->groupBox7->Controls->Add(this->label21);
			this->groupBox7->Controls->Add(this->lblHeadTrack);
			this->groupBox7->Controls->Add(this->label25);
			this->groupBox7->Controls->Add(this->lblSpeedFact);
			this->groupBox7->Controls->Add(this->lblAcceleration);
			this->groupBox7->Controls->Add(this->label6);
			this->groupBox7->Location = System::Drawing::Point(6, 222);
			this->groupBox7->Name = L"groupBox7";
			this->groupBox7->Size = System::Drawing::Size(445, 151);
			this->groupBox7->TabIndex = 22;
			this->groupBox7->TabStop = false;
			this->groupBox7->Text = L"SVT";
			// 
			// label4
			// 
			this->label4->AutoSize = true;
			this->label4->Location = System::Drawing::Point(6, 128);
			this->label4->Name = L"label4";
			this->label4->Size = System::Drawing::Size(51, 13);
			this->label4->TabIndex = 27;
			this->label4->Text = L"Tail track";
			// 
			// lblTailTrack
			// 
			this->lblTailTrack->AutoSize = true;
			this->lblTailTrack->Location = System::Drawing::Point(110, 128);
			this->lblTailTrack->Name = L"lblTailTrack";
			this->lblTailTrack->Size = System::Drawing::Size(10, 13);
			this->lblTailTrack->TabIndex = 26;
			this->lblTailTrack->Text = L"-";
			// 
			// label10
			// 
			this->label10->AutoSize = true;
			this->label10->Location = System::Drawing::Point(6, 110);
			this->label10->Name = L"label10";
			this->label10->Size = System::Drawing::Size(59, 13);
			this->label10->TabIndex = 25;
			this->label10->Text = L"Speed fact";
			// 
			// lblMovingOpposite
			// 
			this->lblMovingOpposite->AutoSize = true;
			this->lblMovingOpposite->Location = System::Drawing::Point(110, 56);
			this->lblMovingOpposite->Name = L"lblMovingOpposite";
			this->lblMovingOpposite->Size = System::Drawing::Size(10, 13);
			this->lblMovingOpposite->TabIndex = 24;
			this->lblMovingOpposite->Text = L"-";
			// 
			// label15
			// 
			this->label15->AutoSize = true;
			this->label15->Location = System::Drawing::Point(6, 56);
			this->label15->Name = L"label15";
			this->label15->Size = System::Drawing::Size(85, 13);
			this->label15->TabIndex = 23;
			this->label15->Text = L"Moving opposite";
			// 
			// lblSpeed
			// 
			this->lblSpeed->AutoSize = true;
			this->lblSpeed->Location = System::Drawing::Point(110, 92);
			this->lblSpeed->Name = L"lblSpeed";
			this->lblSpeed->Size = System::Drawing::Size(10, 13);
			this->lblSpeed->TabIndex = 22;
			this->lblSpeed->Text = L"-";
			// 
			// label17
			// 
			this->label17->AutoSize = true;
			this->label17->Location = System::Drawing::Point(6, 92);
			this->label17->Name = L"label17";
			this->label17->Size = System::Drawing::Size(38, 13);
			this->label17->TabIndex = 21;
			this->label17->Text = L"Speed";
			// 
			// lblOrdinate
			// 
			this->lblOrdinate->AutoSize = true;
			this->lblOrdinate->Location = System::Drawing::Point(110, 74);
			this->lblOrdinate->Name = L"lblOrdinate";
			this->lblOrdinate->Size = System::Drawing::Size(10, 13);
			this->lblOrdinate->TabIndex = 20;
			this->lblOrdinate->Text = L"-";
			// 
			// label21
			// 
			this->label21->AutoSize = true;
			this->label21->Location = System::Drawing::Point(6, 38);
			this->label21->Name = L"label21";
			this->label21->Size = System::Drawing::Size(60, 13);
			this->label21->TabIndex = 19;
			this->label21->Text = L"Head track";
			// 
			// lblHeadTrack
			// 
			this->lblHeadTrack->AutoSize = true;
			this->lblHeadTrack->Location = System::Drawing::Point(110, 38);
			this->lblHeadTrack->Name = L"lblHeadTrack";
			this->lblHeadTrack->Size = System::Drawing::Size(10, 13);
			this->lblHeadTrack->TabIndex = 18;
			this->lblHeadTrack->Text = L"-";
			// 
			// label25
			// 
			this->label25->AutoSize = true;
			this->label25->Location = System::Drawing::Point(6, 74);
			this->label25->Name = L"label25";
			this->label25->Size = System::Drawing::Size(47, 13);
			this->label25->TabIndex = 17;
			this->label25->Text = L"Ordinate";
			// 
			// lblSpeedFact
			// 
			this->lblSpeedFact->AutoSize = true;
			this->lblSpeedFact->Location = System::Drawing::Point(110, 110);
			this->lblSpeedFact->Name = L"lblSpeedFact";
			this->lblSpeedFact->Size = System::Drawing::Size(10, 13);
			this->lblSpeedFact->TabIndex = 16;
			this->lblSpeedFact->Text = L"-";
			// 
			// lblAcceleration
			// 
			this->lblAcceleration->AutoSize = true;
			this->lblAcceleration->Location = System::Drawing::Point(109, 20);
			this->lblAcceleration->Name = L"lblAcceleration";
			this->lblAcceleration->Size = System::Drawing::Size(10, 13);
			this->lblAcceleration->TabIndex = 3;
			this->lblAcceleration->Text = L"-";
			// 
			// label6
			// 
			this->label6->AutoSize = true;
			this->label6->Location = System::Drawing::Point(6, 20);
			this->label6->Name = L"label6";
			this->label6->Size = System::Drawing::Size(66, 13);
			this->label6->TabIndex = 2;
			this->label6->Text = L"Acceleration";
			// 
			// gbLoco
			// 
			this->gbLoco->Controls->Add(this->groupBox6);
			this->gbLoco->Controls->Add(this->groupBox5);
			this->gbLoco->Controls->Add(this->groupBox3);
			this->gbLoco->Location = System::Drawing::Point(457, 19);
			this->gbLoco->Name = L"gbLoco";
			this->gbLoco->Size = System::Drawing::Size(471, 464);
			this->gbLoco->TabIndex = 23;
			this->gbLoco->TabStop = false;
			this->gbLoco->Text = L"Loco";
			// 
			// groupBox6
			// 
			this->groupBox6->Controls->Add(this->lblCHS7MK2);
			this->groupBox6->Controls->Add(this->label112);
			this->groupBox6->Controls->Add(this->label128);
			this->groupBox6->Controls->Add(this->lblCHS7Controller);
			this->groupBox6->Controls->Add(this->lblCHS7EPBSensor);
			this->groupBox6->Controls->Add(this->label134);
			this->groupBox6->Controls->Add(this->lblCHS7PositionSec2);
			this->groupBox6->Controls->Add(this->label138);
			this->groupBox6->Controls->Add(this->lblCHS7MK1);
			this->groupBox6->Controls->Add(this->label142);
			this->groupBox6->Controls->Add(this->lblCHS7MainSwitch);
			this->groupBox6->Location = System::Drawing::Point(316, 19);
			this->groupBox6->Name = L"groupBox6";
			this->groupBox6->Size = System::Drawing::Size(149, 439);
			this->groupBox6->TabIndex = 61;
			this->groupBox6->TabStop = false;
			this->groupBox6->Text = L"CHS 7";
			// 
			// lblCHS7MK2
			// 
			this->lblCHS7MK2->AutoSize = true;
			this->lblCHS7MK2->Location = System::Drawing::Point(126, 70);
			this->lblCHS7MK2->Name = L"lblCHS7MK2";
			this->lblCHS7MK2->Size = System::Drawing::Size(10, 13);
			this->lblCHS7MK2->TabIndex = 33;
			this->lblCHS7MK2->Text = L"-";
			// 
			// label112
			// 
			this->label112->AutoSize = true;
			this->label112->Location = System::Drawing::Point(6, 16);
			this->label112->Name = L"label112";
			this->label112->Size = System::Drawing::Size(51, 13);
			this->label112->TabIndex = 16;
			this->label112->Text = L"Controller";
			// 
			// label128
			// 
			this->label128->AutoSize = true;
			this->label128->Location = System::Drawing::Point(6, 52);
			this->label128->Name = L"label128";
			this->label128->Size = System::Drawing::Size(64, 13);
			this->label128->TabIndex = 14;
			this->label128->Text = L"EPB Sensor";
			// 
			// lblCHS7Controller
			// 
			this->lblCHS7Controller->AutoSize = true;
			this->lblCHS7Controller->Location = System::Drawing::Point(110, 16);
			this->lblCHS7Controller->Name = L"lblCHS7Controller";
			this->lblCHS7Controller->Size = System::Drawing::Size(10, 13);
			this->lblCHS7Controller->TabIndex = 15;
			this->lblCHS7Controller->Text = L"-";
			// 
			// lblCHS7EPBSensor
			// 
			this->lblCHS7EPBSensor->AutoSize = true;
			this->lblCHS7EPBSensor->Location = System::Drawing::Point(110, 52);
			this->lblCHS7EPBSensor->Name = L"lblCHS7EPBSensor";
			this->lblCHS7EPBSensor->Size = System::Drawing::Size(10, 13);
			this->lblCHS7EPBSensor->TabIndex = 17;
			this->lblCHS7EPBSensor->Text = L"-";
			// 
			// label134
			// 
			this->label134->AutoSize = true;
			this->label134->Location = System::Drawing::Point(6, 70);
			this->label134->Name = L"label134";
			this->label134->Size = System::Drawing::Size(84, 13);
			this->label134->TabIndex = 18;
			this->label134->Text = L"MKs active (1,2)";
			// 
			// lblCHS7PositionSec2
			// 
			this->lblCHS7PositionSec2->AutoSize = true;
			this->lblCHS7PositionSec2->Location = System::Drawing::Point(110, 34);
			this->lblCHS7PositionSec2->Name = L"lblCHS7PositionSec2";
			this->lblCHS7PositionSec2->Size = System::Drawing::Size(10, 13);
			this->lblCHS7PositionSec2->TabIndex = 19;
			this->lblCHS7PositionSec2->Text = L"-";
			// 
			// label138
			// 
			this->label138->AutoSize = true;
			this->label138->Location = System::Drawing::Point(6, 34);
			this->label138->Name = L"label138";
			this->label138->Size = System::Drawing::Size(90, 13);
			this->label138->TabIndex = 20;
			this->label138->Text = L"Position section 2";
			// 
			// lblCHS7MK1
			// 
			this->lblCHS7MK1->AutoSize = true;
			this->lblCHS7MK1->Location = System::Drawing::Point(110, 70);
			this->lblCHS7MK1->Name = L"lblCHS7MK1";
			this->lblCHS7MK1->Size = System::Drawing::Size(10, 13);
			this->lblCHS7MK1->TabIndex = 21;
			this->lblCHS7MK1->Text = L"-";
			// 
			// label142
			// 
			this->label142->AutoSize = true;
			this->label142->Location = System::Drawing::Point(6, 88);
			this->label142->Name = L"label142";
			this->label142->Size = System::Drawing::Size(63, 13);
			this->label142->TabIndex = 22;
			this->label142->Text = L"Main switch";
			// 
			// lblCHS7MainSwitch
			// 
			this->lblCHS7MainSwitch->AutoSize = true;
			this->lblCHS7MainSwitch->Location = System::Drawing::Point(110, 88);
			this->lblCHS7MainSwitch->Name = L"lblCHS7MainSwitch";
			this->lblCHS7MainSwitch->Size = System::Drawing::Size(10, 13);
			this->lblCHS7MainSwitch->TabIndex = 23;
			this->lblCHS7MainSwitch->Text = L"-";
			// 
			// groupBox5
			// 
			this->groupBox5->Controls->Add(this->label100);
			this->groupBox5->Controls->Add(this->lblAmperageTE);
			this->groupBox5->Controls->Add(this->label127);
			this->groupBox5->Controls->Add(this->lblPositionSec1);
			this->groupBox5->Controls->Add(this->lblPantFront);
			this->groupBox5->Controls->Add(this->lblShunts);
			this->groupBox5->Controls->Add(this->label137);
			this->groupBox5->Controls->Add(this->lblPantRear);
			this->groupBox5->Controls->Add(this->label141);
			this->groupBox5->Controls->Add(this->lblLocoVoltage);
			this->groupBox5->Controls->Add(this->label145);
			this->groupBox5->Controls->Add(this->label149);
			this->groupBox5->Controls->Add(this->lblAmperageTEUlt);
			this->groupBox5->Controls->Add(this->label153);
			this->groupBox5->Controls->Add(this->lblMVsTE);
			this->groupBox5->Controls->Add(this->lblMVs);
			this->groupBox5->Controls->Add(this->label161);
			this->groupBox5->Location = System::Drawing::Point(161, 19);
			this->groupBox5->Name = L"groupBox5";
			this->groupBox5->Size = System::Drawing::Size(149, 439);
			this->groupBox5->TabIndex = 60;
			this->groupBox5->TabStop = false;
			this->groupBox5->Text = L"Electric Common";
			// 
			// label100
			// 
			this->label100->AutoSize = true;
			this->label100->Location = System::Drawing::Point(6, 16);
			this->label100->Name = L"label100";
			this->label100->Size = System::Drawing::Size(90, 13);
			this->label100->TabIndex = 16;
			this->label100->Text = L"Position section 1";
			// 
			// lblAmperageTE
			// 
			this->lblAmperageTE->AutoSize = true;
			this->lblAmperageTE->Location = System::Drawing::Point(110, 88);
			this->lblAmperageTE->Name = L"lblAmperageTE";
			this->lblAmperageTE->Size = System::Drawing::Size(10, 13);
			this->lblAmperageTE->TabIndex = 13;
			this->lblAmperageTE->Text = L"-";
			// 
			// label127
			// 
			this->label127->AutoSize = true;
			this->label127->Location = System::Drawing::Point(6, 52);
			this->label127->Name = L"label127";
			this->label127->Size = System::Drawing::Size(95, 13);
			this->label127->TabIndex = 14;
			this->label127->Text = L"Pantographs (F/R)";
			// 
			// lblPositionSec1
			// 
			this->lblPositionSec1->AutoSize = true;
			this->lblPositionSec1->Location = System::Drawing::Point(110, 16);
			this->lblPositionSec1->Name = L"lblPositionSec1";
			this->lblPositionSec1->Size = System::Drawing::Size(10, 13);
			this->lblPositionSec1->TabIndex = 15;
			this->lblPositionSec1->Text = L"-";
			// 
			// lblPantFront
			// 
			this->lblPantFront->AutoSize = true;
			this->lblPantFront->Location = System::Drawing::Point(110, 52);
			this->lblPantFront->Name = L"lblPantFront";
			this->lblPantFront->Size = System::Drawing::Size(10, 13);
			this->lblPantFront->TabIndex = 17;
			this->lblPantFront->Text = L"-";
			// 
			// lblShunts
			// 
			this->lblShunts->AutoSize = true;
			this->lblShunts->Location = System::Drawing::Point(110, 34);
			this->lblShunts->Name = L"lblShunts";
			this->lblShunts->Size = System::Drawing::Size(10, 13);
			this->lblShunts->TabIndex = 19;
			this->lblShunts->Text = L"-";
			// 
			// label137
			// 
			this->label137->AutoSize = true;
			this->label137->Location = System::Drawing::Point(6, 34);
			this->label137->Name = L"label137";
			this->label137->Size = System::Drawing::Size(40, 13);
			this->label137->TabIndex = 20;
			this->label137->Text = L"Shunts";
			// 
			// lblPantRear
			// 
			this->lblPantRear->AutoSize = true;
			this->lblPantRear->Location = System::Drawing::Point(126, 52);
			this->lblPantRear->Name = L"lblPantRear";
			this->lblPantRear->Size = System::Drawing::Size(10, 13);
			this->lblPantRear->TabIndex = 21;
			this->lblPantRear->Text = L"-";
			// 
			// label141
			// 
			this->label141->AutoSize = true;
			this->label141->Location = System::Drawing::Point(6, 70);
			this->label141->Name = L"label141";
			this->label141->Size = System::Drawing::Size(66, 13);
			this->label141->TabIndex = 22;
			this->label141->Text = L"Voltage loco";
			// 
			// lblLocoVoltage
			// 
			this->lblLocoVoltage->AutoSize = true;
			this->lblLocoVoltage->Location = System::Drawing::Point(110, 70);
			this->lblLocoVoltage->Name = L"lblLocoVoltage";
			this->lblLocoVoltage->Size = System::Drawing::Size(10, 13);
			this->lblLocoVoltage->TabIndex = 23;
			this->lblLocoVoltage->Text = L"-";
			// 
			// label145
			// 
			this->label145->AutoSize = true;
			this->label145->Location = System::Drawing::Point(6, 88);
			this->label145->Name = L"label145";
			this->label145->Size = System::Drawing::Size(69, 13);
			this->label145->TabIndex = 24;
			this->label145->Text = L"Amperate TE";
			// 
			// label149
			// 
			this->label149->AutoSize = true;
			this->label149->Location = System::Drawing::Point(6, 142);
			this->label149->Name = L"label149";
			this->label149->Size = System::Drawing::Size(77, 13);
			this->label149->TabIndex = 26;
			this->label149->Text = L"MVs TE active";
			// 
			// lblAmperageTEUlt
			// 
			this->lblAmperageTEUlt->AutoSize = true;
			this->lblAmperageTEUlt->Location = System::Drawing::Point(110, 106);
			this->lblAmperageTEUlt->Name = L"lblAmperageTEUlt";
			this->lblAmperageTEUlt->Size = System::Drawing::Size(10, 13);
			this->lblAmperageTEUlt->TabIndex = 27;
			this->lblAmperageTEUlt->Text = L"-";
			// 
			// label153
			// 
			this->label153->AutoSize = true;
			this->label153->Location = System::Drawing::Point(6, 106);
			this->label153->Name = L"label153";
			this->label153->Size = System::Drawing::Size(97, 13);
			this->label153->TabIndex = 28;
			this->label153->Text = L"Amperage TE (Ult.)";
			// 
			// lblMVsTE
			// 
			this->lblMVsTE->AutoSize = true;
			this->lblMVsTE->Location = System::Drawing::Point(110, 142);
			this->lblMVsTE->Name = L"lblMVsTE";
			this->lblMVsTE->Size = System::Drawing::Size(10, 13);
			this->lblMVsTE->TabIndex = 29;
			this->lblMVsTE->Text = L"-";
			// 
			// lblMVs
			// 
			this->lblMVs->AutoSize = true;
			this->lblMVs->Location = System::Drawing::Point(110, 124);
			this->lblMVs->Name = L"lblMVs";
			this->lblMVs->Size = System::Drawing::Size(10, 13);
			this->lblMVs->TabIndex = 31;
			this->lblMVs->Text = L"-";
			// 
			// label161
			// 
			this->label161->AutoSize = true;
			this->label161->Location = System::Drawing::Point(6, 124);
			this->label161->Name = L"label161";
			this->label161->Size = System::Drawing::Size(61, 13);
			this->label161->TabIndex = 32;
			this->label161->Text = L"MVs Active";
			// 
			// groupBox3
			// 
			this->groupBox3->Controls->Add(this->lblWindowR);
			this->groupBox3->Controls->Add(this->label84);
			this->groupBox3->Controls->Add(this->lblAuxBrakeTank);
			this->groupBox3->Controls->Add(this->lblBattery1);
			this->groupBox3->Controls->Add(this->label102);
			this->groupBox3->Controls->Add(this->label86);
			this->groupBox3->Controls->Add(this->lblPressureLine);
			this->groupBox3->Controls->Add(this->lblCoupling);
			this->groupBox3->Controls->Add(this->label104);
			this->groupBox3->Controls->Add(this->lblWhistle);
			this->groupBox3->Controls->Add(this->lblBrakeLine);
			this->groupBox3->Controls->Add(this->label82);
			this->groupBox3->Controls->Add(this->label106);
			this->groupBox3->Controls->Add(this->lblCombined);
			this->groupBox3->Controls->Add(this->lblBalanceTank);
			this->groupBox3->Controls->Add(this->label80);
			this->groupBox3->Controls->Add(this->label109);
			this->groupBox3->Controls->Add(this->lblHorn);
			this->groupBox3->Controls->Add(this->lblWhipersDegree);
			this->groupBox3->Controls->Add(this->label57);
			this->groupBox3->Controls->Add(this->label111);
			this->groupBox3->Controls->Add(this->lblWindowL);
			this->groupBox3->Controls->Add(this->label113);
			this->groupBox3->Controls->Add(this->label55);
			this->groupBox3->Controls->Add(this->lbl294);
			this->groupBox3->Controls->Add(this->lblhighlights);
			this->groupBox3->Controls->Add(this->label115);
			this->groupBox3->Controls->Add(this->label98);
			this->groupBox3->Controls->Add(this->lbl395);
			this->groupBox3->Controls->Add(this->lblBattery2);
			this->groupBox3->Controls->Add(this->label117);
			this->groupBox3->Controls->Add(this->lblSlipping);
			this->groupBox3->Controls->Add(this->lblVHS);
			this->groupBox3->Controls->Add(this->label119);
			this->groupBox3->Controls->Add(this->label94);
			this->groupBox3->Controls->Add(this->lblReversor);
			this->groupBox3->Controls->Add(this->lblVH);
			this->groupBox3->Controls->Add(this->label121);
			this->groupBox3->Controls->Add(this->label92);
			this->groupBox3->Controls->Add(this->lblEPV);
			this->groupBox3->Controls->Add(this->lblWhipers);
			this->groupBox3->Controls->Add(this->label123);
			this->groupBox3->Controls->Add(this->label90);
			this->groupBox3->Controls->Add(this->lblAmperageEPB);
			this->groupBox3->Controls->Add(this->lblVilignance);
			this->groupBox3->Controls->Add(this->label88);
			this->groupBox3->Location = System::Drawing::Point(6, 19);
			this->groupBox3->Name = L"groupBox3";
			this->groupBox3->Size = System::Drawing::Size(149, 439);
			this->groupBox3->TabIndex = 9;
			this->groupBox3->TabStop = false;
			this->groupBox3->Text = L"Common";
			// 
			// lblWindowR
			// 
			this->lblWindowR->AutoSize = true;
			this->lblWindowR->Location = System::Drawing::Point(126, 88);
			this->lblWindowR->Name = L"lblWindowR";
			this->lblWindowR->Size = System::Drawing::Size(10, 13);
			this->lblWindowR->TabIndex = 60;
			this->lblWindowR->Text = L"-";
			// 
			// label84
			// 
			this->label84->AutoSize = true;
			this->label84->Location = System::Drawing::Point(6, 16);
			this->label84->Name = L"label84";
			this->label84->Size = System::Drawing::Size(48, 13);
			this->label84->TabIndex = 16;
			this->label84->Text = L"Coupling";
			// 
			// lblAuxBrakeTank
			// 
			this->lblAuxBrakeTank->AutoSize = true;
			this->lblAuxBrakeTank->Location = System::Drawing::Point(110, 393);
			this->lblAuxBrakeTank->Name = L"lblAuxBrakeTank";
			this->lblAuxBrakeTank->Size = System::Drawing::Size(10, 13);
			this->lblAuxBrakeTank->TabIndex = 59;
			this->lblAuxBrakeTank->Text = L"-";
			// 
			// lblBattery1
			// 
			this->lblBattery1->AutoSize = true;
			this->lblBattery1->Location = System::Drawing::Point(110, 106);
			this->lblBattery1->Name = L"lblBattery1";
			this->lblBattery1->Size = System::Drawing::Size(10, 13);
			this->lblBattery1->TabIndex = 13;
			this->lblBattery1->Text = L"-";
			// 
			// label102
			// 
			this->label102->AutoSize = true;
			this->label102->Location = System::Drawing::Point(6, 393);
			this->label102->Name = L"label102";
			this->label102->Size = System::Drawing::Size(79, 13);
			this->label102->TabIndex = 58;
			this->label102->Text = L"Aux brake tank";
			// 
			// label86
			// 
			this->label86->AutoSize = true;
			this->label86->Location = System::Drawing::Point(6, 52);
			this->label86->Name = L"label86";
			this->label86->Size = System::Drawing::Size(42, 13);
			this->label86->TabIndex = 14;
			this->label86->Text = L"Whistle";
			// 
			// lblPressureLine
			// 
			this->lblPressureLine->AutoSize = true;
			this->lblPressureLine->Location = System::Drawing::Point(110, 375);
			this->lblPressureLine->Name = L"lblPressureLine";
			this->lblPressureLine->Size = System::Drawing::Size(10, 13);
			this->lblPressureLine->TabIndex = 57;
			this->lblPressureLine->Text = L"-";
			// 
			// lblCoupling
			// 
			this->lblCoupling->AutoSize = true;
			this->lblCoupling->Location = System::Drawing::Point(110, 16);
			this->lblCoupling->Name = L"lblCoupling";
			this->lblCoupling->Size = System::Drawing::Size(10, 13);
			this->lblCoupling->TabIndex = 15;
			this->lblCoupling->Text = L"-";
			// 
			// label104
			// 
			this->label104->AutoSize = true;
			this->label104->Location = System::Drawing::Point(6, 339);
			this->label104->Name = L"label104";
			this->label104->Size = System::Drawing::Size(54, 13);
			this->label104->TabIndex = 56;
			this->label104->Text = L"Brake line";
			// 
			// lblWhistle
			// 
			this->lblWhistle->AutoSize = true;
			this->lblWhistle->Location = System::Drawing::Point(110, 52);
			this->lblWhistle->Name = L"lblWhistle";
			this->lblWhistle->Size = System::Drawing::Size(10, 13);
			this->lblWhistle->TabIndex = 17;
			this->lblWhistle->Text = L"-";
			// 
			// lblBrakeLine
			// 
			this->lblBrakeLine->AutoSize = true;
			this->lblBrakeLine->Location = System::Drawing::Point(110, 339);
			this->lblBrakeLine->Name = L"lblBrakeLine";
			this->lblBrakeLine->Size = System::Drawing::Size(10, 13);
			this->lblBrakeLine->TabIndex = 55;
			this->lblBrakeLine->Text = L"-";
			// 
			// label82
			// 
			this->label82->AutoSize = true;
			this->label82->Location = System::Drawing::Point(6, 70);
			this->label82->Name = L"label82";
			this->label82->Size = System::Drawing::Size(30, 13);
			this->label82->TabIndex = 18;
			this->label82->Text = L"Horn";
			// 
			// label106
			// 
			this->label106->AutoSize = true;
			this->label106->Location = System::Drawing::Point(6, 375);
			this->label106->Name = L"label106";
			this->label106->Size = System::Drawing::Size(67, 13);
			this->label106->TabIndex = 54;
			this->label106->Text = L"Pressure line";
			// 
			// lblCombined
			// 
			this->lblCombined->AutoSize = true;
			this->lblCombined->Location = System::Drawing::Point(110, 34);
			this->lblCombined->Name = L"lblCombined";
			this->lblCombined->Size = System::Drawing::Size(10, 13);
			this->lblCombined->TabIndex = 19;
			this->lblCombined->Text = L"-";
			// 
			// lblBalanceTank
			// 
			this->lblBalanceTank->AutoSize = true;
			this->lblBalanceTank->Location = System::Drawing::Point(110, 357);
			this->lblBalanceTank->Name = L"lblBalanceTank";
			this->lblBalanceTank->Size = System::Drawing::Size(10, 13);
			this->lblBalanceTank->TabIndex = 53;
			this->lblBalanceTank->Text = L"-";
			// 
			// label80
			// 
			this->label80->AutoSize = true;
			this->label80->Location = System::Drawing::Point(6, 34);
			this->label80->Name = L"label80";
			this->label80->Size = System::Drawing::Size(93, 13);
			this->label80->TabIndex = 20;
			this->label80->Text = L"Combined opened";
			// 
			// label109
			// 
			this->label109->AutoSize = true;
			this->label109->Location = System::Drawing::Point(6, 321);
			this->label109->Name = L"label109";
			this->label109->Size = System::Drawing::Size(82, 13);
			this->label109->TabIndex = 52;
			this->label109->Text = L"Whipers degree";
			// 
			// lblHorn
			// 
			this->lblHorn->AutoSize = true;
			this->lblHorn->Location = System::Drawing::Point(110, 70);
			this->lblHorn->Name = L"lblHorn";
			this->lblHorn->Size = System::Drawing::Size(10, 13);
			this->lblHorn->TabIndex = 21;
			this->lblHorn->Text = L"-";
			// 
			// lblWhipersDegree
			// 
			this->lblWhipersDegree->AutoSize = true;
			this->lblWhipersDegree->Location = System::Drawing::Point(110, 321);
			this->lblWhipersDegree->Name = L"lblWhipersDegree";
			this->lblWhipersDegree->Size = System::Drawing::Size(10, 13);
			this->lblWhipersDegree->TabIndex = 51;
			this->lblWhipersDegree->Text = L"-";
			// 
			// label57
			// 
			this->label57->AutoSize = true;
			this->label57->Location = System::Drawing::Point(6, 88);
			this->label57->Name = L"label57";
			this->label57->Size = System::Drawing::Size(77, 13);
			this->label57->TabIndex = 22;
			this->label57->Text = L"Windows (L,R)";
			// 
			// label111
			// 
			this->label111->AutoSize = true;
			this->label111->Location = System::Drawing::Point(6, 357);
			this->label111->Name = L"label111";
			this->label111->Size = System::Drawing::Size(70, 13);
			this->label111->TabIndex = 50;
			this->label111->Text = L"Balance tank";
			// 
			// lblWindowL
			// 
			this->lblWindowL->AutoSize = true;
			this->lblWindowL->Location = System::Drawing::Point(110, 88);
			this->lblWindowL->Name = L"lblWindowL";
			this->lblWindowL->Size = System::Drawing::Size(10, 13);
			this->lblWindowL->TabIndex = 23;
			this->lblWindowL->Text = L"-";
			// 
			// label113
			// 
			this->label113->AutoSize = true;
			this->label113->Location = System::Drawing::Point(6, 303);
			this->label113->Name = L"label113";
			this->label113->Size = System::Drawing::Size(79, 13);
			this->label113->TabIndex = 48;
			this->label113->Text = L"Amperage EPB";
			// 
			// label55
			// 
			this->label55->AutoSize = true;
			this->label55->Location = System::Drawing::Point(6, 106);
			this->label55->Name = L"label55";
			this->label55->Size = System::Drawing::Size(101, 13);
			this->label55->TabIndex = 24;
			this->label55->Text = L"Battery Charge (1,2)";
			// 
			// lbl294
			// 
			this->lbl294->AutoSize = true;
			this->lbl294->Location = System::Drawing::Point(110, 285);
			this->lbl294->Name = L"lbl294";
			this->lbl294->Size = System::Drawing::Size(10, 13);
			this->lbl294->TabIndex = 47;
			this->lbl294->Text = L"-";
			// 
			// lblhighlights
			// 
			this->lblhighlights->AutoSize = true;
			this->lblhighlights->Location = System::Drawing::Point(110, 195);
			this->lblhighlights->Name = L"lblhighlights";
			this->lblhighlights->Size = System::Drawing::Size(10, 13);
			this->lblhighlights->TabIndex = 25;
			this->lblhighlights->Text = L"-";
			// 
			// label115
			// 
			this->label115->AutoSize = true;
			this->label115->Location = System::Drawing::Point(6, 285);
			this->label115->Name = L"label115";
			this->label115->Size = System::Drawing::Size(25, 13);
			this->label115->TabIndex = 46;
			this->label115->Text = L"254";
			// 
			// label98
			// 
			this->label98->AutoSize = true;
			this->label98->Location = System::Drawing::Point(6, 141);
			this->label98->Name = L"label98";
			this->label98->Size = System::Drawing::Size(57, 13);
			this->label98->TabIndex = 26;
			this->label98->Text = L"VHS press";
			// 
			// lbl395
			// 
			this->lbl395->AutoSize = true;
			this->lbl395->Location = System::Drawing::Point(110, 267);
			this->lbl395->Name = L"lbl395";
			this->lbl395->Size = System::Drawing::Size(10, 13);
			this->lbl395->TabIndex = 45;
			this->lbl395->Text = L"-";
			// 
			// lblBattery2
			// 
			this->lblBattery2->AutoSize = true;
			this->lblBattery2->Location = System::Drawing::Point(126, 106);
			this->lblBattery2->Name = L"lblBattery2";
			this->lblBattery2->Size = System::Drawing::Size(10, 13);
			this->lblBattery2->TabIndex = 27;
			this->lblBattery2->Text = L"-";
			// 
			// label117
			// 
			this->label117->AutoSize = true;
			this->label117->Location = System::Drawing::Point(6, 231);
			this->label117->Name = L"label117";
			this->label117->Size = System::Drawing::Size(44, 13);
			this->label117->TabIndex = 44;
			this->label117->Text = L"Slipping";
			// 
			// lblSlipping
			// 
			this->lblSlipping->AutoSize = true;
			this->lblSlipping->Location = System::Drawing::Point(110, 231);
			this->lblSlipping->Name = L"lblSlipping";
			this->lblSlipping->Size = System::Drawing::Size(10, 13);
			this->lblSlipping->TabIndex = 43;
			this->lblSlipping->Text = L"-";
			// 
			// lblVHS
			// 
			this->lblVHS->AutoSize = true;
			this->lblVHS->Location = System::Drawing::Point(110, 141);
			this->lblVHS->Name = L"lblVHS";
			this->lblVHS->Size = System::Drawing::Size(10, 13);
			this->lblVHS->TabIndex = 29;
			this->lblVHS->Text = L"-";
			// 
			// label119
			// 
			this->label119->AutoSize = true;
			this->label119->Location = System::Drawing::Point(6, 267);
			this->label119->Name = L"label119";
			this->label119->Size = System::Drawing::Size(25, 13);
			this->label119->TabIndex = 42;
			this->label119->Text = L"395";
			// 
			// label94
			// 
			this->label94->AutoSize = true;
			this->label94->Location = System::Drawing::Point(6, 159);
			this->label94->Name = L"label94";
			this->label94->Size = System::Drawing::Size(78, 13);
			this->label94->TabIndex = 30;
			this->label94->Text = L"Whipers active";
			// 
			// lblReversor
			// 
			this->lblReversor->AutoSize = true;
			this->lblReversor->Location = System::Drawing::Point(110, 249);
			this->lblReversor->Name = L"lblReversor";
			this->lblReversor->Size = System::Drawing::Size(10, 13);
			this->lblReversor->TabIndex = 41;
			this->lblReversor->Text = L"-";
			// 
			// lblVH
			// 
			this->lblVH->AutoSize = true;
			this->lblVH->Location = System::Drawing::Point(110, 123);
			this->lblVH->Name = L"lblVH";
			this->lblVH->Size = System::Drawing::Size(10, 13);
			this->lblVH->TabIndex = 31;
			this->lblVH->Text = L"-";
			// 
			// label121
			// 
			this->label121->AutoSize = true;
			this->label121->Location = System::Drawing::Point(6, 213);
			this->label121->Name = L"label121";
			this->label121->Size = System::Drawing::Size(60, 13);
			this->label121->TabIndex = 40;
			this->label121->Text = L"EPV active";
			// 
			// label92
			// 
			this->label92->AutoSize = true;
			this->label92->Location = System::Drawing::Point(6, 123);
			this->label92->Name = L"label92";
			this->label92->Size = System::Drawing::Size(50, 13);
			this->label92->TabIndex = 32;
			this->label92->Text = L"VH press";
			// 
			// lblEPV
			// 
			this->lblEPV->AutoSize = true;
			this->lblEPV->Location = System::Drawing::Point(110, 213);
			this->lblEPV->Name = L"lblEPV";
			this->lblEPV->Size = System::Drawing::Size(10, 13);
			this->lblEPV->TabIndex = 39;
			this->lblEPV->Text = L"-";
			// 
			// lblWhipers
			// 
			this->lblWhipers->AutoSize = true;
			this->lblWhipers->Location = System::Drawing::Point(110, 159);
			this->lblWhipers->Name = L"lblWhipers";
			this->lblWhipers->Size = System::Drawing::Size(10, 13);
			this->lblWhipers->TabIndex = 33;
			this->lblWhipers->Text = L"-";
			// 
			// label123
			// 
			this->label123->AutoSize = true;
			this->label123->Location = System::Drawing::Point(6, 249);
			this->label123->Name = L"label123";
			this->label123->Size = System::Drawing::Size(50, 13);
			this->label123->TabIndex = 38;
			this->label123->Text = L"Reversor";
			// 
			// label90
			// 
			this->label90->AutoSize = true;
			this->label90->Location = System::Drawing::Point(6, 177);
			this->label90->Name = L"label90";
			this->label90->Size = System::Drawing::Size(91, 13);
			this->label90->TabIndex = 34;
			this->label90->Text = L"Villignance check";
			// 
			// lblAmperageEPB
			// 
			this->lblAmperageEPB->AutoSize = true;
			this->lblAmperageEPB->Location = System::Drawing::Point(110, 303);
			this->lblAmperageEPB->Name = L"lblAmperageEPB";
			this->lblAmperageEPB->Size = System::Drawing::Size(10, 13);
			this->lblAmperageEPB->TabIndex = 37;
			this->lblAmperageEPB->Text = L"-";
			// 
			// lblVilignance
			// 
			this->lblVilignance->AccessibleDescription = L"";
			this->lblVilignance->AutoSize = true;
			this->lblVilignance->Location = System::Drawing::Point(110, 177);
			this->lblVilignance->Name = L"lblVilignance";
			this->lblVilignance->Size = System::Drawing::Size(10, 13);
			this->lblVilignance->TabIndex = 35;
			this->lblVilignance->Text = L"-";
			// 
			// label88
			// 
			this->label88->AutoSize = true;
			this->label88->Location = System::Drawing::Point(6, 195);
			this->label88->Name = L"label88";
			this->label88->Size = System::Drawing::Size(85, 13);
			this->label88->TabIndex = 36;
			this->label88->Text = L"Highlights active";
			// 
			// groupBox1
			// 
			this->groupBox1->Controls->Add(this->lblWinter);
			this->groupBox1->Controls->Add(this->lblDirection);
			this->groupBox1->Controls->Add(this->label61);
			this->groupBox1->Controls->Add(this->label62);
			this->groupBox1->Controls->Add(this->label63);
			this->groupBox1->Controls->Add(this->lblConsist);
			this->groupBox1->Controls->Add(this->label65);
			this->groupBox1->Controls->Add(this->lblScenery);
			this->groupBox1->Controls->Add(this->label69);
			this->groupBox1->Controls->Add(this->lblSWagonCount);
			this->groupBox1->Controls->Add(this->label74);
			this->groupBox1->Controls->Add(this->lblRoute);
			this->groupBox1->Controls->Add(this->label76);
			this->groupBox1->Controls->Add(this->lblSLocoType);
			this->groupBox1->Controls->Add(this->label78);
			this->groupBox1->Controls->Add(this->lblLocoDir);
			this->groupBox1->Location = System::Drawing::Point(6, 75);
			this->groupBox1->Name = L"groupBox1";
			this->groupBox1->Size = System::Drawing::Size(445, 139);
			this->groupBox1->TabIndex = 22;
			this->groupBox1->TabStop = false;
			this->groupBox1->Text = L"Virtual settings.ini";
			// 
			// lblWinter
			// 
			this->lblWinter->AutoSize = true;
			this->lblWinter->Location = System::Drawing::Point(407, 18);
			this->lblWinter->Name = L"lblWinter";
			this->lblWinter->Size = System::Drawing::Size(10, 13);
			this->lblWinter->TabIndex = 16;
			this->lblWinter->Text = L"-";
			// 
			// lblDirection
			// 
			this->lblDirection->AutoSize = true;
			this->lblDirection->Location = System::Drawing::Point(110, 56);
			this->lblDirection->Name = L"lblDirection";
			this->lblDirection->Size = System::Drawing::Size(10, 13);
			this->lblDirection->TabIndex = 15;
			this->lblDirection->Text = L"-";
			// 
			// label61
			// 
			this->label61->AutoSize = true;
			this->label61->Location = System::Drawing::Point(5, 56);
			this->label61->Name = L"label61";
			this->label61->Size = System::Drawing::Size(49, 13);
			this->label61->TabIndex = 14;
			this->label61->Text = L"Direction";
			// 
			// label62
			// 
			this->label62->AutoSize = true;
			this->label62->Location = System::Drawing::Point(302, 18);
			this->label62->Name = L"label62";
			this->label62->Size = System::Drawing::Size(38, 13);
			this->label62->TabIndex = 13;
			this->label62->Text = L"Winter";
			// 
			// label63
			// 
			this->label63->AutoSize = true;
			this->label63->Location = System::Drawing::Point(6, 110);
			this->label63->Name = L"label63";
			this->label63->Size = System::Drawing::Size(71, 13);
			this->label63->TabIndex = 12;
			this->label63->Text = L"Loco work dir";
			// 
			// lblConsist
			// 
			this->lblConsist->AutoSize = true;
			this->lblConsist->Location = System::Drawing::Point(110, 38);
			this->lblConsist->Name = L"lblConsist";
			this->lblConsist->Size = System::Drawing::Size(10, 13);
			this->lblConsist->TabIndex = 11;
			this->lblConsist->Text = L"-";
			// 
			// label65
			// 
			this->label65->AutoSize = true;
			this->label65->Location = System::Drawing::Point(6, 38);
			this->label65->Name = L"label65";
			this->label65->Size = System::Drawing::Size(70, 13);
			this->label65->TabIndex = 10;
			this->label65->Text = L"Consist name";
			// 
			// lblScenery
			// 
			this->lblScenery->AutoSize = true;
			this->lblScenery->Location = System::Drawing::Point(110, 92);
			this->lblScenery->Name = L"lblScenery";
			this->lblScenery->Size = System::Drawing::Size(10, 13);
			this->lblScenery->TabIndex = 9;
			this->lblScenery->Text = L"-";
			// 
			// label69
			// 
			this->label69->AutoSize = true;
			this->label69->Location = System::Drawing::Point(157, 18);
			this->label69->Name = L"label69";
			this->label69->Size = System::Drawing::Size(72, 13);
			this->label69->TabIndex = 8;
			this->label69->Text = L"Wagon count";
			// 
			// lblSWagonCount
			// 
			this->lblSWagonCount->AutoSize = true;
			this->lblSWagonCount->Location = System::Drawing::Point(261, 18);
			this->lblSWagonCount->Name = L"lblSWagonCount";
			this->lblSWagonCount->Size = System::Drawing::Size(10, 13);
			this->lblSWagonCount->TabIndex = 7;
			this->lblSWagonCount->Text = L"-";
			// 
			// label74
			// 
			this->label74->AutoSize = true;
			this->label74->Location = System::Drawing::Point(6, 92);
			this->label74->Name = L"label74";
			this->label74->Size = System::Drawing::Size(75, 13);
			this->label74->TabIndex = 6;
			this->label74->Text = L"Scenery name";
			// 
			// lblRoute
			// 
			this->lblRoute->AutoSize = true;
			this->lblRoute->Location = System::Drawing::Point(110, 74);
			this->lblRoute->Name = L"lblRoute";
			this->lblRoute->Size = System::Drawing::Size(10, 13);
			this->lblRoute->TabIndex = 5;
			this->lblRoute->Text = L"-";
			// 
			// label76
			// 
			this->label76->AutoSize = true;
			this->label76->Location = System::Drawing::Point(6, 20);
			this->label76->Name = L"label76";
			this->label76->Size = System::Drawing::Size(54, 13);
			this->label76->TabIndex = 4;
			this->label76->Text = L"Loco type";
			// 
			// lblSLocoType
			// 
			this->lblSLocoType->AutoSize = true;
			this->lblSLocoType->Location = System::Drawing::Point(110, 20);
			this->lblSLocoType->Name = L"lblSLocoType";
			this->lblSLocoType->Size = System::Drawing::Size(10, 13);
			this->lblSLocoType->TabIndex = 3;
			this->lblSLocoType->Text = L"-";
			// 
			// label78
			// 
			this->label78->AutoSize = true;
			this->label78->Location = System::Drawing::Point(6, 74);
			this->label78->Name = L"label78";
			this->label78->Size = System::Drawing::Size(65, 13);
			this->label78->TabIndex = 2;
			this->label78->Text = L"Route name";
			// 
			// lblLocoDir
			// 
			this->lblLocoDir->AutoSize = true;
			this->lblLocoDir->Location = System::Drawing::Point(110, 110);
			this->lblLocoDir->Name = L"lblLocoDir";
			this->lblLocoDir->Size = System::Drawing::Size(10, 13);
			this->lblLocoDir->TabIndex = 1;
			this->lblLocoDir->Text = L"-";
			// 
			// groupBox2
			// 
			this->groupBox2->Controls->Add(this->label67);
			this->groupBox2->Controls->Add(this->lblPause);
			this->groupBox2->Controls->Add(this->label71);
			this->groupBox2->Controls->Add(this->lblConnected);
			this->groupBox2->Location = System::Drawing::Point(6, 19);
			this->groupBox2->Name = L"groupBox2";
			this->groupBox2->Size = System::Drawing::Size(445, 51);
			this->groupBox2->TabIndex = 0;
			this->groupBox2->TabStop = false;
			this->groupBox2->Text = L"General";
			// 
			// label67
			// 
			this->label67->AutoSize = true;
			this->label67->Location = System::Drawing::Point(157, 20);
			this->label67->Name = L"label67";
			this->label67->Size = System::Drawing::Size(37, 13);
			this->label67->TabIndex = 8;
			this->label67->Text = L"Pause";
			// 
			// lblPause
			// 
			this->lblPause->AutoSize = true;
			this->lblPause->Location = System::Drawing::Point(266, 20);
			this->lblPause->Name = L"lblPause";
			this->lblPause->Size = System::Drawing::Size(10, 13);
			this->lblPause->TabIndex = 7;
			this->lblPause->Text = L"-";
			// 
			// label71
			// 
			this->label71->AutoSize = true;
			this->label71->Location = System::Drawing::Point(6, 20);
			this->label71->Name = L"label71";
			this->label71->Size = System::Drawing::Size(100, 13);
			this->label71->TabIndex = 4;
			this->label71->Text = L"Connected to game";
			// 
			// lblConnected
			// 
			this->lblConnected->AutoSize = true;
			this->lblConnected->Location = System::Drawing::Point(110, 20);
			this->lblConnected->Name = L"lblConnected";
			this->lblConnected->Size = System::Drawing::Size(10, 13);
			this->lblConnected->TabIndex = 3;
			this->lblConnected->Text = L"-";
			// 
			// groupBox4
			// 
			this->groupBox4->Controls->Add(this->lblRain);
			this->groupBox4->Controls->Add(this->label73);
			this->groupBox4->Location = System::Drawing::Point(0, 435);
			this->groupBox4->Name = L"groupBox4";
			this->groupBox4->Size = System::Drawing::Size(445, 48);
			this->groupBox4->TabIndex = 21;
			this->groupBox4->TabStop = false;
			this->groupBox4->Text = L"Misc";
			// 
			// lblRain
			// 
			this->lblRain->AutoSize = true;
			this->lblRain->Location = System::Drawing::Point(115, 20);
			this->lblRain->Name = L"lblRain";
			this->lblRain->Size = System::Drawing::Size(10, 13);
			this->lblRain->TabIndex = 3;
			this->lblRain->Text = L"-";
			// 
			// label73
			// 
			this->label73->AutoSize = true;
			this->label73->Location = System::Drawing::Point(6, 20);
			this->label73->Name = L"label73";
			this->label73->Size = System::Drawing::Size(29, 13);
			this->label73->TabIndex = 2;
			this->label73->Text = L"Rain";
			// 
			// Debug
			// 
			this->AutoScaleDimensions = System::Drawing::SizeF(6, 13);
			this->AutoScaleMode = System::Windows::Forms::AutoScaleMode::Font;
			this->ClientSize = System::Drawing::Size(1421, 571);
			this->Controls->Add(this->gbRAM);
			this->Controls->Add(this->gbROM);
			this->Name = L"Debug";
			this->Text = L"Debug";
			this->Load += gcnew System::EventHandler(this, &Debug::Debug_Load);
			this->gbConsist->ResumeLayout(false);
			this->gbConsist->PerformLayout();
			this->gbMisc->ResumeLayout(false);
			this->gbMisc->PerformLayout();
			this->gbOncoming->ResumeLayout(false);
			this->gbOncoming->PerformLayout();
			this->gbROM->ResumeLayout(false);
			this->gbRAM->ResumeLayout(false);
			this->groupBox7->ResumeLayout(false);
			this->groupBox7->PerformLayout();
			this->gbLoco->ResumeLayout(false);
			this->groupBox6->ResumeLayout(false);
			this->groupBox6->PerformLayout();
			this->groupBox5->ResumeLayout(false);
			this->groupBox5->PerformLayout();
			this->groupBox3->ResumeLayout(false);
			this->groupBox3->PerformLayout();
			this->groupBox1->ResumeLayout(false);
			this->groupBox1->PerformLayout();
			this->groupBox2->ResumeLayout(false);
			this->groupBox2->PerformLayout();
			this->groupBox4->ResumeLayout(false);
			this->groupBox4->PerformLayout();
			this->ResumeLayout(false);

		}
#pragma endregion
	private: System::Void Debug_Load(System::Object^ sender, System::EventArgs^ e) {
	}

	public: System::Void Debug::UpdateValues() {
		const RAM::RAMValues values = this->general->GetRAMValues();

		// ROM
		// Consist
		const ROM::Consist* consist = values.consist;
		this->lblConsistType->Text = gcnew System::String(to_wstring(consist->type).c_str());
		this->lblConsistLength->Text = gcnew System::String(to_wstring(consist->length).c_str());
		this->lblAxesCount->Text = gcnew System::String(to_wstring(consist->axesCount).c_str());
		this->lblLocoType->Text = gcnew System::String(consist->locoType.c_str());

		this->lblLocoSectionCount->Text = gcnew System::String(to_wstring(consist->sectionCount).c_str());
		this->lblLocoLength->Text = gcnew System::String(to_wstring(consist->locoUnit.length).c_str());
		this->lblLocoAxesCount->Text = gcnew System::String(to_wstring(consist->locoUnit.axesArr.size()).c_str());

		this->lblWagonCount->Text = gcnew System::String(to_wstring(consist->wagonCount).c_str());
		this->lblWagonLenght->Text = gcnew System::String(to_wstring(consist->wagonUnit.length).c_str());
		this->lblWagonAxesCount->Text = gcnew System::String(to_wstring(values.stations->stationsArr.size()).c_str());

		// Oncoming
		const ROM::Oncoming* oncoming = values.oncoming;
		const ROM::Consist oncomingConsist = oncoming->consist;
		this->lblOConsistType->Text = gcnew System::String(to_wstring(oncomingConsist.type).c_str());
		this->lblOConsistLength->Text = gcnew System::String(to_wstring(oncomingConsist.length).c_str());
		this->lblOAxesCount->Text = gcnew System::String(to_wstring(oncomingConsist.axesCount).c_str());
		this->lblLocoType->Text = gcnew System::String(oncomingConsist.locoType.c_str());

		this->lblOLocoSectionCount->Text = gcnew System::String(to_wstring(oncomingConsist.sectionCount).c_str());
		this->lblOLocoLength->Text = gcnew System::String(to_wstring(oncomingConsist.locoUnit.length).c_str());
		this->lblOLocoAxesCount->Text = gcnew System::String(to_wstring(oncomingConsist.locoUnit.axesArr.size()).c_str());

		this->lblOWagonCount->Text = gcnew System::String(to_wstring(oncomingConsist.wagonCount).c_str());
		this->lblOWagonLenght->Text = gcnew System::String(to_wstring(oncomingConsist.wagonUnit.length).c_str());
		this->lblOWagonAxesCount->Text = gcnew System::String(to_wstring(oncomingConsist.wagonUnit.axesArr.size()).c_str());

		this->lblOOrdinateDelta->Text = gcnew System::String(to_wstring(oncoming->ordinateDelta).c_str());
		this->lblOOrdinateDiff->Text = gcnew System::String(to_wstring(oncoming->ordinateDiff).c_str());
		this->lblOOrdinate->Text = gcnew System::String(to_wstring(oncoming->ordinate).c_str());
		this->lblOSpeed->Text = gcnew System::String(to_wstring(oncoming->speed).c_str());
		this->lblOTrack->Text = gcnew System::String(to_wstring(oncoming->track.current).c_str());
		this->lblOStatus->Text = gcnew System::String(to_wstring(oncoming->status).c_str());

		// Misc
		this->lblAtPassingStation->Text = gcnew System::String(to_wstring(values.stations->isOnStation).c_str());
		this->lblStationCount->Text = gcnew System::String(to_wstring(values.stations->stationsArr.size()).c_str());


		// RAM
		// General
		this->lblConnected->Text = gcnew System::String(to_wstring(values.isConnectedToMemory).c_str());
		this->lblPause->Text = gcnew System::String(to_wstring(values.isGameOnPause).c_str());

		// Virtual settings.ini
		this->lblSLocoType->Text = gcnew System::String(values.settingsIni->locoType.c_str());
		this->lblSWagonCount->Text = gcnew System::String(to_wstring(values.settingsIni->wagonCount).c_str());
		this->lblWinter->Text = gcnew System::String(to_wstring(values.settingsIni->isWinter).c_str());
		this->lblConsist->Text = gcnew System::String(values.settingsIni->consistName.c_str());
		this->lblRoute->Text = gcnew System::String(values.settingsIni->routeName.c_str());
		this->lblScenery->Text = gcnew System::String(values.settingsIni->sceneryName.c_str());
		this->lblLocoDir->Text = gcnew System::String(values.settingsIni->locoWorkDir.c_str());

		// SVT
		const RAM::SVT* svt = values.svt;
		this->lblAcceleration->Text = gcnew System::String(to_wstring(svt->acceleration).c_str());
		this->lblHeadTrack->Text = gcnew System::String(to_wstring(svt->headTrack.current).c_str());
		this->lblMovingOpposite->Text = gcnew System::String(to_wstring(svt->isMovingOpposite).c_str());
		this->lblOrdinate->Text = gcnew System::String(to_wstring(svt->ordinate).c_str());
		this->lblSpeed->Text = gcnew System::String(to_wstring(svt->speed).c_str());
		this->lblSpeedFact->Text = gcnew System::String(to_wstring(svt->speedFact).c_str());
		this->lblTailTrack->Text = gcnew System::String(to_wstring(svt->tailTrack).c_str());

		// Misc
		this->lblRain->Text = gcnew System::String(to_wstring(values.isRain).c_str());


		// Loco
		// Common
		const CHS7* loco = (CHS7*)values.locoPtr;
		this->lblCoupling->Text = gcnew System::String(to_wstring(loco->isCoupling).c_str());
		this->lblCombined->Text = gcnew System::String(to_wstring(loco->isCombinedOpened).c_str());
		this->lblWhistle->Text = gcnew System::String(to_wstring(loco->isWhistleActive).c_str());
		this->lblHorn->Text = gcnew System::String(to_wstring(loco->isHornActive).c_str());
		this->lblWindowL->Text = gcnew System::String(to_wstring(loco->windowsOpenState[0].current).c_str());
		this->lblWindowR->Text = gcnew System::String(to_wstring(loco->windowsOpenState[1].current).c_str());
		this->lblBattery1->Text = gcnew System::String(to_wstring(loco->batteryChargeState[0].current).c_str());
		this->lblBattery2->Text = gcnew System::String(to_wstring(loco->batteryChargeState[1].current).c_str());
		this->lblVH->Text = gcnew System::String(to_wstring(loco->isVHPress.current).c_str());
		this->lblVHS->Text = gcnew System::String(to_wstring(loco->isVHSPress.current).c_str());
		this->lblWhipers->Text = gcnew System::String(to_wstring(loco->isWipersActive.current).c_str());
		this->lblVilignance->Text = gcnew System::String(to_wstring(loco->isVilignanceCheck.current).c_str());
		this->lblhighlights->Text = gcnew System::String(to_wstring(loco->isHighlightsActive.current).c_str());
		this->lblEPV->Text = gcnew System::String(to_wstring(loco->isEPVActive.current).c_str());
		this->lblSlipping->Text = gcnew System::String(to_wstring(loco->isSlipping.current).c_str());
		this->lblReversor->Text = gcnew System::String(to_wstring(loco->reversorState).c_str());
		this->lbl395->Text = gcnew System::String(to_wstring(loco->crane395State.current).c_str());
		this->lbl294->Text = gcnew System::String(to_wstring(loco->crane254State.current).c_str());
		this->lblAmperageEPB->Text = gcnew System::String(to_wstring(loco->amperageEPB).c_str());
		this->lblWhipersDegree->Text = gcnew System::String(to_wstring(loco->wipersDegree).c_str());
		this->lblBrakeLine->Text = gcnew System::String(to_wstring(loco->brakeLinePressure).c_str());
		this->lblBalanceTank->Text = gcnew System::String(to_wstring(loco->balanceTankPressure).c_str());
		this->lblPressureLine->Text = gcnew System::String(to_wstring(loco->pressureLine.current).c_str());
		this->lblAuxBrakeTank->Text = gcnew System::String(to_wstring(loco->auxBrakeTankPressure).c_str());

		// Electric Common
		this->lblPositionSec1->Text = gcnew System::String(to_wstring(loco->positionSection0).c_str());
		this->lblShunts->Text = gcnew System::String(to_wstring(loco->shunts).c_str());
		this->lblPantFront->Text = gcnew System::String(to_wstring(loco->pantographs[0]).c_str());
		this->lblPantRear->Text = gcnew System::String(to_wstring(loco->pantographs[1]).c_str());
		this->lblLocoVoltage->Text = gcnew System::String(to_wstring(loco->voltageLoco).c_str());
		this->lblAmperageTE->Text = gcnew System::String(to_wstring(loco->amperageTE).c_str());
		this->lblAmperageTEUlt->Text = gcnew System::String(to_wstring(loco->amperageUltimateTE).c_str());
		this->lblMVs->Text = gcnew System::String(to_wstring(loco->areMVsActive).c_str());
		this->lblMVsTE->Text = gcnew System::String(to_wstring(loco->isMVsTEActive).c_str());

		// CHS 7
		this->lblCHS7Controller->Text = gcnew System::String(to_wstring(loco->kr21State).c_str());
		this->lblCHS7PositionSec2->Text = gcnew System::String(to_wstring(loco->positionSection1).c_str());
		this->lblCHS7EPBSensor->Text = gcnew System::String(to_wstring(loco->epbSensorPressure).c_str());
		this->lblCHS7MK1->Text = gcnew System::String(to_wstring(loco->areMKsActive[0]).c_str());
		this->lblCHS7MK2->Text = gcnew System::String(to_wstring(loco->areMKsActive[1]).c_str());
		this->lblCHS7MainSwitch->Text = gcnew System::String(to_wstring(loco->isMainSwitchActive.current).c_str());
	}
};
}
