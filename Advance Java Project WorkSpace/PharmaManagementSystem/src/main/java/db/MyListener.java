package db;

import java.sql.Connection;
import java.sql.DriverManager;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class MyListener implements ServletContextListener {

	@Override
	public void contextInitialized(ServletContextEvent event) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			System.out.println("Driver Loading Success!");

			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmacyproject", "root", "");
			System.out.println("Authentication Success!");

			// storing connection object as an attribute into the ServletCOntext
			ServletContext ctx = event.getServletContext();
			ctx.setAttribute("mycon", con);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
	}

}

// Note ---> ServletContext

//ServletContext stores global data that needs to be accessed by multiple servlets or parts of the web application. For example, a database connection, or configuration settings (like file paths, environment variables).
