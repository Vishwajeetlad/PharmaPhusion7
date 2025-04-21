package com.pharma.tests;

import java.time.Duration;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public class SeleniumTest {
    public static void main(String[] args) {

        // Set the system property to point to your ChromeDriver executable.
        System.setProperty("webdriver.chrome.driver",
            "C:\\Users\\vishw\\OneDrive\\Desktop\\Syllabus\\JARS\\chromedriver-win64\\chromedriver.exe");

        WebDriver driver = new ChromeDriver();
        
        // Maximize the browser window to ensure desktop view is activated.
        driver.manage().window().maximize();
        
        // Create an explicit wait with a timeout of 10 seconds.
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));

        try {
            // Open your index.jsp page on the local server.
            driver.get("http://localhost:8081/Pharma_Management_System/index.jsp");
            
            // Wait for the "Login" link to be visible. On the desktop layout it should be visible
            WebElement loginMenu = wait.until(ExpectedConditions.visibilityOfElementLocated(By.linkText("Login")));
            
            // Hover over the Login menu to reveal the dropdown options.
            Actions actions = new Actions(driver);
            actions.moveToElement(loginMenu).perform();

            // Wait for the ADMIN login link in the dropdown to be clickable.
            WebElement adminLoginLink = wait.until(ExpectedConditions.elementToBeClickable(
                By.xpath("//a[@data-target='#adminLoginModal' and contains(text(),'ADMIN')]")));
            adminLoginLink.click();

            // Wait for the admin login modal to become visible by waiting for the email input field.
            WebElement emailField = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("exampleInputEmail1")));
            WebElement passwordField = driver.findElement(By.id("exampleInputPassword1"));

            // Enter the admin credentials.
            emailField.sendKeys("vishwalad7@gmail.com");
            passwordField.sendKeys("v7");

            // Locate and click the SignIn button inside the admin login modal.
            WebElement signInButton = driver.findElement(
                By.xpath("//div[@id='adminLoginModal']//button[contains(text(),'SignIn')]"));
            signInButton.click();

            // Wait until the URL changes to either adminLoginProcess.jsp or adminHome.jsp.
            wait.until(ExpectedConditions.or(
                ExpectedConditions.urlContains("adminLoginProcess.jsp"),
                ExpectedConditions.urlContains("adminHome.jsp")
            ));

            String currentUrl = driver.getCurrentUrl();
            System.out.println("Current URL after login: " + currentUrl);
            if (currentUrl.contains("adminHome.jsp")) {
                System.out.println("Admin login successful; navigated to adminHome.jsp.");
            } else if (currentUrl.contains("adminLoginProcess.jsp")) {
                System.out.println("At adminLoginProcess.jsp. Verify if redirection to adminHome.jsp occurs.");
            } else {
                System.out.println("Unexpected URL after login.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Wait a few seconds to observe the result before closing the browser.
            try { Thread.sleep(3000); } catch (InterruptedException ie) { }
            driver.quit();
        }
    }
}
