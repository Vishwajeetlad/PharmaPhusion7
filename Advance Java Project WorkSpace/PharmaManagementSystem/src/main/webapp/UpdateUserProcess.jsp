<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
String usertype = request.getParameter("usertype");
String id = request.getParameter("id");
String name = request.getParameter("name");
String password = request.getParameter("password");

Connection con = (Connection) application.getAttribute("mycon");
PreparedStatement ps = null; // declared and initialized to null 

if (usertype.equals("Manufacturer")) {
	ps = con.prepareStatement("update manufacturer set m_name=? , password=? where m_id=?",
	ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
} 
else if (usertype.equals("Wholesaler")) {
	ps = con.prepareStatement("update wholesaler set w_name=? , password=? where w_id=?",
	ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
} 
else if (usertype.equals("Distributor")) {
	ps = con.prepareStatement("update distributor set d_name=? , password=? where d_id=?",
	ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
}

ps.setString(1, name);
ps.setString(2, password);
ps.setString(3, id);

int i = 0;
try {
	i = ps.executeUpdate(); // used if modifying the database.... return 1 if success && if want to fetch some data then , use of ResultSet rs.executeQuery() as it returns ResultSet object  
} catch (Exception e) {
	System.out.println("H2 : " + e);
}

if (i > 0) { // means update done! sucess!!!
%>
<!-- go back to adminHome page.... -->
<jsp:forward page="adminHome.jsp"></jsp:forward>

<%
} else {
%>
<!-- go back to adminHome page.... -->
<jsp:forward page="adminHome.jsp"></jsp:forward>

<%
}
%>