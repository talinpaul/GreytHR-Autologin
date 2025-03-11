# GreytHR-Autologin

_GreytHR-Autologin_ is a Python-based automation tool designed to streamline the sign-in process for the GreytHR portal. By leveraging Selenium WebDriver, this script automates the login procedure, enhancing efficiency for users who regularly access the platform.

## **Features**

* **Automated Login:** Seamlessly logs into the GreytHR portal using provided credentials.​
* **Attendance Marking:** Automates the process of marking attendance, ensuring timely records.​
* **Task Scheduler Integration:** Compatible with Windows Task Scheduler for automated, scheduled executions.​

## **Prerequisites**

Before setting up GreytHR-Autologin, ensure you have the following installed:

* Python: Version 3.6 or higher.​
* pip: Python package installer.​
* Mozilla Firefox: Web browser used by Selenium WebDriver.​
* GeckoDriver: WebDriver for Firefox.​

## **Setup Instructions**

1. **Clone the Repository:**
    ```bash
    $ git clone https://github.com/talinpaul/GreytHR-Autologin.git
    $ cd GreytHR-Autologin
    ```
1. **Run the Installation Script:**
    The `install.ps1` script automates the setup process, including creating a virtual environment and installing dependencies.
    ```
    $ .\install.ps1
    ```
    ​This script performs the following actions:​
    * Checks for Python installation.​
    * Ensures the venv module is available.​
    * Creates and activates a virtual environment.​
    * Upgrades pip to the latest version.​
    * Installs required dependencies from `requirements.txt`.​

1. **Configure Environment Variables:**
    * Create a `.env` file in the project root directory.​ Use the `.env.sample` file as a reference.
    * Add your GreytHR credentials:​
    ```ini
    USERNAME=your_username
    PASSWORD=your_password
    ```
    _​Ensure this file is added to `.gitignore` to protect sensitive information._

1. **Run the Script:**
    You can execute the automation script using the provided `run.ps1` script, which handles activating the virtual environment and running the main Python script.
    ```bash
    $ .\run.ps1
    ```

    Alternatively, you can manually activate the virtual environment and run the script:
    ```bash
    $ .\env\Scripts\Activate.ps1
    $ python .\src\main.py
    ```
1. **Automating with Windows Task Scheduler:**
    To run the script automatically at specified times

    1. Create a Batch File:
        * Create a `startup-script.cmd` file with the following content:​
            ```bash
            $ @echo off
            $ cd /d "C:\path\to\GreytHR-Autologin"
            $ env\Scripts\activate.bat
            $ python src\main.py
            ```
    1. Set Up Task Scheduler:
        * Open Task Scheduler and create a new task.​
        * In the "Actions" tab, set the action to start the startup-script.cmd file.​
        * Configure the trigger to your desired schedule.​

## License

This project is licensed under the Apache-2.0 License.

---
​**Note:** _This project is intended for educational and personal use. Ensure compliance with your organization's policies before automating interactions with internal systems._
