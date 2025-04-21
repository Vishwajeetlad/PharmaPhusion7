<%@page import="java.io.InputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.io.File"%>


<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>


<!-- RELATED TO DATABASE MANAGEMENT (CASCADE) -->
<!-- NOTE-> 1]See that CASCADING is a PowerFull method , with great power comes great responsibilty .
			2]CASCADE -> To DATA INTEGRITY , If data deleted/updated in PARENT table , then data reflected into the child table .
			3] Avoid using whenever you want some of the data , and not want to modify remaining of data 
			4] Use of TRIGGERS is must 
			
			5] But here , we have used it because see if MANUFACTURER is deleted , then his/her PRODUCTs must be DELETED , isn't it?
			so used CASCADE HERE ON DELETE/UPDATE
 -->

<%
String mp_id = request.getParameter("mp_id");
String mp_name = request.getParameter("mp_name");
String mp_desc = request.getParameter("mp_desc");
String mp_price = request.getParameter("mp_price");

/* NOTE ---> Java treats forward slash(/) as valid path separators so '\' are replaced by '/' */

String my_loc = "C:/PharmaProject/Images/" + request.getParameter("image");

String m_id = request.getParameter("m_id");

Connection con = (Connection) application.getAttribute("mycon");
PreparedStatement ps = null; // declared and initialized to null 

ps = con.prepareStatement("insert into mproduct values(?,?,?,?,?,?)", ResultSet.TYPE_SCROLL_SENSITIVE,
		ResultSet.CONCUR_UPDATABLE);

ps.setString(1, mp_id);
ps.setString(2, mp_name);
ps.setString(3, mp_desc);
ps.setString(4, mp_price);

ps.setString(6, m_id);

// setting the image taken as a input 

try {
	System.out.println("Inside try of the image processing/handing block");
	File image = new File(my_loc) ;
	//System.out.println("Image : " + my_loc);
	FileInputStream fis = new FileInputStream(image);
	//System.out.println("Image : " + fis);
	ps.setBinaryStream(5, (InputStream) fis, (int) (image.length()));
} catch (Exception e) {
	System.out.println("Some Problem Occured in File uploading Man ! : " + e);
}

int i = 0;
try {
	i = ps.executeUpdate(); // used if modifying the database.... return 1 if success && if want to fetch some data then , use of ResultSet rs.executeQuery() as it returns ResultSet object  
} catch (Exception e) {
	System.out.println("Problem While Executing The Query ! : " + e);
}

if (i > 0) { // means update done! sucess!!!
%>
<!-- go back to User Manufacturer's Home page.... -->
<jsp:forward page="UserManufacturerHome.jsp"></jsp:forward>

<%
} else {
%>
<!-- go back to User Manufacturer's Home page even though failed!!.... -->
<jsp:forward page="UserManufacturerHome.jsp"></jsp:forward>

<%
}
%>

