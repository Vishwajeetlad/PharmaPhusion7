<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
/*  request.getParameter --->
	It is used to retrieve the value of form fields (like <input>, <select>, etc.) submitted via an HTTP request.
*/
	String userEmail = request.getParameter("userEmail") ;
	String password = request.getParameter("userPass") ;
	
	Connection con = (Connection)application.getAttribute("mycon") ;
	
	PreparedStatement ps = con.prepareStatement("select * from admin where email=? and password=?",ResultSet.TYPE_SCROLL_SENSITIVE , ResultSet.CONCUR_UPDATABLE) ;
	System.out.println("Connection Succes! ") ;
	
	ps.setString(1, userEmail) ;
	ps.setString(2, password) ;
	
	ResultSet rs = ps.executeQuery() ;
	
	System.out.println("Rs Succes! ") ;

	if( rs.next() ){  // if query runs successfully... set the email into the session name -> 'uname'
		System.out.println("Rs Succes! Inside if ") ;

		session.setAttribute("uname", userEmail) ;
		session.setAttribute("role", "admin") ;
%>
		<jsp:forward page="adminHome.jsp" ></jsp:forward>	<!-- and also forward to admin's home page -->
<% 
	}
	else{ // if not authenticated then forward back , to index page to login in again....
		System.out.println("Rs Fail! ") ;

		request.setAttribute("Error", "*Invalid ! Please Check UserName and Password Correct Details") ;
		session.setAttribute("Loginmsg", "Please signIn first!") ;
%>

		<jsp:forward page="index.jsp"></jsp:forward>
<% 
	}

%>
    