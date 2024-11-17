#include "pch.h"
#include "forms\main\main-form.hpp"

using namespace System;
using namespace System::Windows::Forms;

[STAThread]
int main() {
	Application::EnableVisualStyles();
	Application::SetCompatibleTextRenderingDefault(false);
	Application::Run(gcnew ZDSounds::MainForm());
	return 0;
}