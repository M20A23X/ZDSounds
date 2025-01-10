#pragma once

#include "general\general.hpp"

#include "forms\ram\debug-form.hpp"


namespace ZDSounds {

#include "exceptions\exception.hpp"

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
	private: System::Windows::Forms::MenuStrip^ msMain;



	private: System::Windows::Forms::ToolStripMenuItem^ tsm;

	private: System::Windows::Forms::ToolStripMenuItem^ debugToolStripMenuItem;

		   General* general;

		   Debug^ debugForm = nullptr;

	protected:
		~MainForm() {
			delete general;
			delete components;
		}

	public:
		MainForm(void) {
			try {
				InitializeComponent();
				this->pictureBoxMain->Image = Image::FromFile(L".\\zdsounds\\assets\\main.jpg");
				general = new General();
			}
			catch (const Exception& exc) {
				MessageBox::Show(exc.getStringMessage(), "Application Error", MessageBoxButtons::OK, MessageBoxIcon::Exclamation);
			}
		}


#pragma region Windows Form Designer generated code

		void InitializeComponent(void) {
			this->components = (gcnew System::ComponentModel::Container());
			this->pictureBoxMain = (gcnew System::Windows::Forms::PictureBox());
			this->MainTimer = (gcnew System::Windows::Forms::Timer(this->components));
			this->msMain = (gcnew System::Windows::Forms::MenuStrip());
			this->tsm = (gcnew System::Windows::Forms::ToolStripMenuItem());
			this->debugToolStripMenuItem = (gcnew System::Windows::Forms::ToolStripMenuItem());
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^>(this->pictureBoxMain))->BeginInit();
			this->msMain->SuspendLayout();
			this->SuspendLayout();
			// 
			// pictureBoxMain
			// 
			this->pictureBoxMain->Location = System::Drawing::Point(-8, 44);
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
			// msMain
			// 
			this->msMain->Items->AddRange(gcnew cli::array< System::Windows::Forms::ToolStripItem^  >(1) { this->tsm });
			this->msMain->Location = System::Drawing::Point(0, 0);
			this->msMain->Name = L"msMain";
			this->msMain->Size = System::Drawing::Size(409, 24);
			this->msMain->TabIndex = 1;
			this->msMain->Text = L"menuStrip1";
			// 
			// tsm
			// 
			this->tsm->DropDownItems->AddRange(gcnew cli::array< System::Windows::Forms::ToolStripItem^  >(1) { this->debugToolStripMenuItem });
			this->tsm->Name = L"tsm";
			this->tsm->Size = System::Drawing::Size(54, 20);
			this->tsm->Text = L"Debug";
			// 
			// debugToolStripMenuItem
			// 
			this->debugToolStripMenuItem->Name = L"debugToolStripMenuItem";
			this->debugToolStripMenuItem->Size = System::Drawing::Size(180, 22);
			this->debugToolStripMenuItem->Text = L"Form";
			this->debugToolStripMenuItem->Click += gcnew System::EventHandler(this, &MainForm::tsmDebugForm_Click);
			// 
			// MainForm
			// 
			this->AutoScaleDimensions = System::Drawing::SizeF(6, 13);
			this->AutoScaleMode = System::Windows::Forms::AutoScaleMode::Font;
			this->BackColor = System::Drawing::SystemColors::ControlLight;
			this->ClientSize = System::Drawing::Size(409, 571);
			this->Controls->Add(this->pictureBoxMain);
			this->Controls->Add(this->msMain);
			this->Location = System::Drawing::Point(425, 0);
			this->MainMenuStrip = this->msMain;
			this->Name = L"MainForm";
			this->ShowIcon = false;
			this->StartPosition = System::Windows::Forms::FormStartPosition::Manual;
			this->Text = L"ZDSounds";
			this->Load += gcnew System::EventHandler(this, &MainForm::MainForm_Load);
			(cli::safe_cast<System::ComponentModel::ISupportInitialize^>(this->pictureBoxMain))->EndInit();
			this->msMain->ResumeLayout(false);
			this->msMain->PerformLayout();
			this->ResumeLayout(false);
			this->PerformLayout();

		}
#pragma endregion
	private: System::Void MainForm_Load(System::Object^ sender, System::EventArgs^ e) {
		if (!general->GetInstallationState()) {
			String^ message = L"Error! The program is not installed correctly - please install the program to the root of 'ZDSimulator' dir.";
			MessageBox::Show(message, "Application Error", MessageBoxButtons::OK, MessageBoxIcon::Exclamation);
			Application::Exit();
		}

		this->MainTimer->Enabled = true;
	}

	private: System::Void MainTimer_Tick(System::Object^ sender, System::EventArgs^ e) {
		try {
			this->general->TickMainTimer();
			if (this->debugForm != nullptr && this->general->GetInitializedState())
				this->debugForm->UpdateValues();
		}
		catch (const Exception& exc) {
			MessageBox::Show(L"Can't update debug values! " + exc.getStringMessage(), "Application Error", MessageBoxButtons::OK, MessageBoxIcon::Exclamation);
		}
	}

	private: System::Void tsmDebugForm_Click(System::Object^ sender, System::EventArgs^ e) {
		this->debugForm = gcnew Debug(this->general->GetRAM());
		debugForm->Show();
	}
	};
}
