<%-- <%@page import="bean.Product"%>      <!-- importing a Product class from package bean -->
 --%>  <%@page import="java.sql.*"%> 
  <%@page import="java.io.InputStream"%> 
  <%@page import="java.io.FileInputStream"%> 
  <%@page import="java.io.File"%> 
  <%@page import="org.json.JSONArray"%> 
  <%@page import="org.json.JSONException"%> 
  <%@page import="org.json.JSONObject"%> 
  
<%--   <%@page import="com.sun.xml.internal.bind.CycleRecoverable.Context"%> 
 --%>
 <%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
 
 
 <%
 
 		String id = request.getParameter("wo_id") ;   // we are storing the "wo_id" as "id"
 
 Connection con = (Connection) application.getAttribute("mycon");
	PreparedStatement ps = null , ps1 , ps2 ; // ps = declared , and ps1 and ps2 are declared but not initialized

	ps = con.prepareStatement("update wholesaler_order set status=? where wo_id=?", ResultSet.TYPE_SCROLL_SENSITIVE,
			ResultSet.CONCUR_UPDATABLE);

	ps.setString(1,"1");  // setting the status from to 0 -> 1 as we have clicked accept from prev page .
	ps.setString(2, id) ;   // this is the id of the wholesaler's product
/* 	ResultSet rs = null ;
 */ 
	
	// here we are inserting the wholesaler_order_track from "order placed" -> "Order Dispatched" .
	ps1 = con.prepareStatement("insert into wholesaler_order_track(wo_id,status) values(?,?)", ResultSet.TYPE_SCROLL_SENSITIVE,
			ResultSet.CONCUR_UPDATABLE);
	ps1.setString(1, id) ;
	ps1.setString(2,"Your Order Ready To Dispatch!") ;
	
	int i = 0 ;
	
	try{
		i = ps.executeUpdate() ;
		i = ps1.executeUpdate() ;
	}
	catch(Exception e){
		System.out.println("Error while updating the status into the database(sql)") ;
	}

	
	if( i > 0 ){  // query executed successfully!
		
		// still product is not defined.... that class.
		try{
			List<Product> products = new ArrayList<>() ;
			ResultSet rs = null ;
			// fetching all the products of manufacturer from the mproduct 
			ps = con.prepareStatement("select * from mproduct)", ResultSet.TYPE_SCROLL_SENSITIVE,
					ResultSet.CONCUR_UPDATABLE);
					
					rs = ps.executeQuery() ;   // rs -> contains all mproducts
					while( rs.next() ){
						Product product = new Product() ;
						product.setName(rs.getString(2)) ;
						product.setDesc(rs.getString(3)) ;
						product.setPrice(rs.getString(4)) ;
						product.setImage(rs.getBlob(5)) ;
						products.add(product) ;
					}
			
					System.out.println("Products fetched from mproduct table : "+products) ;
					
		}
	catch(Exception e){
		
	}
		
	}
	
 %>
  
  
  