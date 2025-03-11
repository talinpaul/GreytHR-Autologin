import requests
from selenium import webdriver
from selenium.webdriver import FirefoxOptions
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import argparse
import getpass
import time

# ========== CONFIGURATION ========== #
DEBUG = True
LOGIN_URL = "https://softility.greythr.com"
POST_LOGIN_URL = "https://softility.greythr.com/v3/portal/ess/home"
SIGNIN_URL = "https://softility.greythr.com/v3/api/attendance/mark-attendance?action=Signin"

# =================================== #

# ========== ARGUMENT PARSING ========== #
parser = argparse.ArgumentParser(description='Automate workplace sign-in')
parser.add_argument('--username', required=True, help='Your work username/email')
parser.add_argument('--password', help='Your password (optional in command line)')
args = parser.parse_args()

if not args.password:
    args.password = getpass.getpass("Enter your password: ")

# ======================================= #

# Initialize browser
options = FirefoxOptions()
# options.add_argument("-headless")  # Uncomment if you want headless mode
driver = webdriver.Firefox(options=options)

# ========== DEBUG FUNCTIONS ========== #
def debug_print(message):
    if DEBUG:
        print(f"[DEBUG] {message}")
# ===================================== #

try:
    # Step 1: Load login page
    debug_print("Navigating to login page")
    driver.get(LOGIN_URL)
    
    # Step 2: Fill credentials
    debug_print("Attempting credential input")
    wait = WebDriverWait(driver, 30)

    # Using more reliable element locators
    username_field = wait.until(EC.presence_of_element_located(
        (By.CSS_SELECTOR, "input[name='username']")
    ))
    username_field.send_keys(args.username)

    password_field = wait.until(EC.presence_of_element_located(
        (By.CSS_SELECTOR, "input[name='password']")
    ))
    password_field.send_keys(args.password)

    # Step 3: Click login button with retry logic
    debug_print("Looking for login button")
    login_button = wait.until(EC.element_to_be_clickable(
        (By.XPATH, "//button[contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz'), 'log in')]")
    ))
    
    # Single click with proper wait after
    login_button.click()
    debug_print("Login button clicked")

    # Step 4: Wait for authentication complete
    debug_print("Waiting for post-login redirect")
    wait.until(EC.url_to_be(POST_LOGIN_URL))
    debug_print("Successfully reached post-login page")

    # Step 5: Extract required cookies and headers from Selenium
    debug_print("Extracting session cookies and headers")

    session_cookies = driver.get_cookies()
    cookies_dict = {cookie['name']: cookie['value'] for cookie in session_cookies}

    # Extract CSRF token from cookies or page
    csrf_token = cookies_dict.get("CSRF-TOKEN", "")

    if not csrf_token:
        # Try extracting CSRF token from page (if present)
        debug_print("Attempting to extract CSRF token from page")
        csrf_elements = driver.find_elements(By.NAME, "csrf-token")
        if csrf_elements:
            csrf_token = csrf_elements[0].get_attribute("content")
    
    debug_print(f"Extracted CSRF-TOKEN: {csrf_token}")

    # Step 6: Send Web Request for Sign In
    debug_print("Sending sign-in request via API")

    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:135.0) Gecko/20100101 Firefox/135.0",
        "Accept": "application/json",
        "X-Requested-With": "XMLHttpRequest",
        "Content-Type": "application/json",
        "Origin": "https://softility.greythr.com",
        "Referer": "https://softility.greythr.com/v3/portal/ess/home",
        "CSRF-TOKEN": csrf_token,  # Ensure CSRF token is included
    }

    session = requests.Session()
    session.cookies.update(cookies_dict)  # Use session cookies from Selenium

    response = session.post(SIGNIN_URL, headers=headers, json={})

    debug_print(f"Sign-in request status: {response.status_code}")
    debug_print(f"Sign-in response: {response.text}")

    if response.status_code == 200:
        debug_print("✅ Successfully signed in via API!")
    else:
        debug_print("⚠️ Failed to sign in via API!")

except Exception as e:
    print(f"CRITICAL ERROR: {str(e)}")
    print(f"Current URL: {driver.current_url}")
    print(f"Page title: {driver.title}")
    with open("page_source.html", "w", encoding="utf-8") as f:
        f.write(driver.page_source)
    print("Page source saved to page_source.html")

finally:
    debug_print("Cleaning up")
    driver.quit()
