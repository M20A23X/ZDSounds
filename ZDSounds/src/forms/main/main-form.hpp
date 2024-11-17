#pragma once

#include "..\..\general\general.hpp"

namespace ZDSounds {

	using namespace System;
	using namespace System::ComponentModel;
	using namespace System::Collections;
	using namespace System::Windows::Forms;
	using namespace System::Data;
	using namespace System::Drawing;

	public ref class MainForm : public System::Windows::Forms::Form
	{
	private:
		System::Windows::Forms::PictureBox^ pictureBoxMain;
		System::Windows::Forms::Timer^ MainTimer;

		System::ComponentModel::IContainer^ components;
		General* general;

	protected:
		~MainForm() {
			delete general;
			delete components;
		}

	public:
		MainForm(void) {
			InitializeComponent();
			this->pictureBoxMain->Image = Image::FromFile(L".\\assets\\main.jpg");
			general = new General();
		}


#pragma region Windows Form Designer generated code

		void InitializeComponent(void) {
			this->components = (gcnew System::ComponentModel::Container());
			this->pictureBoxMain = (gcnew System::Windows::Forms::PictureBox());
			this->MainTimer = (gcnew System::Windows::Forms::Timer(this->components));
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^>(this->pictureBoxMain))->BeginInit();
			this->SuspendLayout();
			// 
			// pictureBoxMain
			// 
			this->pictureBoxMain->Location = System::Drawing::Point(-8, 0);
			this->pictureBoxMain->Name = L"pictureBoxMain";
			this->pictureBoxMain->Size = System::Drawing::Size(425, 126);
			this->pictureBoxMain->TabIndex = 0;
			this->pictureBoxMain->TabStop = false;
			// 
			// MainTimer
			// 
			this->MainTimer->Interval = 20;
			this->MainTimer->Tick += gcnew System::EventHandler(this, &MainForm::MainTimer_Tick);
			// 
			// MainForm
			// 
			this->AutoScaleDimensions = System::Drawing::SizeF(6, 13);
			this->AutoScaleMode = System::Windows::Forms::AutoScaleMode::Font;
			this->BackColor = System::Drawing::SystemColors::ControlLight;
			this->ClientSize = System::Drawing::Size(409, 571);
			this->Controls->Add(this->pictureBoxMain);
			this->Location = System::Drawing::Point(425, 0);
			this->Name = L"MainForm";
			this->ShowIcon = false;
			this->StartPosition = System::Windows::Forms::FormStartPosition::Manual;
			this->Text = L"ZDSounds";
			this->Load += gcnew System::EventHandler(this, &MainForm::MainForm_Load);
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^>(this->pictureBoxMain))->EndInit();
			this->ResumeLayout(false);

		}
#pragma endregion
	private: System::Void MainForm_Load(System::Object^ sender, System::EventArgs^ e) {
		if (!general->GetInstallationState()) {
			this->Text = "Error! The program is not isntalled correctly - please install the program to the root of 'ZDSimulator' dir.";
			return;
		}
		this->MainTimer->Enabled = true;
	}

	private: System::Void MainTimer_Tick(System::Object^ sender, System::EventArgs^ e) {
		general->TickMainTimer();
	}

	};
}
