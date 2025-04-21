<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
    <!-- this page is after clicking on logOut . There fore invalidate/end the session and stored elements into it (here it's uname)  -->

<% 
session.invalidate();
%>
<!-- after invalidating , forward to index.jsp (directly to home page) -->

<jsp:forward page="index.jsp"></jsp:forward>
