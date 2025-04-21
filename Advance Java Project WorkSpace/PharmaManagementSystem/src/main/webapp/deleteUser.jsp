<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
String usertype = request.getParameter("type");
String id = request.getParameter("id");

Connection con = (Connection) application.getAttribute("mycon");
PreparedStatement ps = null; // declared and initialized to null 

if (usertype.equals("Manufacturer")) {
	ps = con.prepareStatement("delete from manufacturer where m_id=?",
	ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
} 
else if (usertype.equals("Wholesaler")) {
	ps = con.prepareStatement("delete from wholesaler where m_id=?",
	ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
} 
else if (usertype.equals("Distributor")) {
	ps = con.prepareStatement("delete from distributor where m_id=?",
	ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
}

ps.setString(1, id);

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