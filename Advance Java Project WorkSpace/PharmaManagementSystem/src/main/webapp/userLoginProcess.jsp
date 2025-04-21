<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	String usertype = request.getParameter("usertype") ;   // ***fetching the User's Type***
	String id = request.getParameter("id") ; 
	String name = request.getParameter("name") ; 
	String password = request.getParameter("userPass") ; 
	
	
	Connection con = (Connection) application.getAttribute("mycon") ;	
	PreparedStatement ps = null ; // declared and initialized to null 
	
	if( usertype.equals("Manufacturer") ){
		ps = con.prepareStatement("select * from manufacturer where m_id=? and password=?",ResultSet.TYPE_SCROLL_SENSITIVE , ResultSet.CONCUR_UPDATABLE) ;
		//System.out.println("Success! UserType-->"+usertype+id+password) ;

	}
	else if( usertype.equals("Wholesaler") ){
		ps = con.prepareStatement("select * from wholesaler where w_id=? and password=?",ResultSet.TYPE_SCROLL_SENSITIVE , ResultSet.CONCUR_UPDATABLE) ;
		//System.out.println("Success! UserType-->"+usertype+id+password) ;

	}
	else if( usertype.equals("Distributor") ){
		ps = con.prepareStatement("select * from distributor where d_id=? and password=?",ResultSet.TYPE_SCROLL_SENSITIVE , ResultSet.CONCUR_UPDATABLE) ;	
		//System.out.println("Success! UserType-->"+usertype+id+password) ;

	}

	
	ps.setString(1, id) ;
	ps.setString(2, password) ;
	//System.out.println("Prepared SQL: " + ps.toString());

	
	ResultSet rs = ps.executeQuery() ;
	//System.out.println("Rows returned: " + rs.getRow());

	
    if (rs.next()) {  // If query runs successfully... set the id into the session name -> 'uname'
		//System.out.println("Success! inside if()") ;

        session.setAttribute("uname", id);
        session.setAttribute("role", usertype) ;  // pudhe eka thikani i have used role to compare some string so i have stored userType in role
        session.setAttribute("usertype", usertype);
        
        if (usertype.equals("Manufacturer")) {
%>
            <jsp:forward page="UserManufacturerHome.jsp"></jsp:forward>
<%
        }
        else if (usertype.equals("Wholesaler")) {
%>
            <jsp:forward page="UserWholesalerHome.jsp"></jsp:forward>
<%
        }
        else {  /* (usertype.equals("Distributor")) */
%>
            <jsp:forward page="UserDistributorHome.jsp"></jsp:forward>
<%
        }
    }
    else { // If not authenticated, then forward back to the index page to log in again
		//System.out.println("Failed! inside else()") ;
        request.setAttribute("Error", "*Invalid! Please check username and password.F**ked Up!");
        session.setAttribute("Loginmsg", "Please sign in first!");
%>
        <jsp:forward page="index.jsp"></jsp:forward>
<%
    }
%>
