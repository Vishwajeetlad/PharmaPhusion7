<%@page import="org.json.JSONArray"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.Base64"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">

<head>
<title>Pharma &mdash; Colorlib Template</title>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">

<link
	href="https://fonts.googleapis.com/css?family=Rubik:400,700|Crimson+Text:400,400i"
	rel="stylesheet">
<link rel="styslesheet" href="fonts/icomoon/style.css">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/magnific-popup.css">
<link rel="stylesheet" href="css/jquery-ui.css">
<link rel="stylesheet" href="css/owl.carousel.min.css">
<link rel="stylesheet" href="css/owl.theme.default.min.css">
<link rel="stylesheet" href="css/aos.css">
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/mycss.css">
</head>

<body>
	<div class="site-wrap">
		<!-- Navbar Section -->
		<div class="site-navbar py-2">
			<div class="search-wrap">
				<div class="container">
					<a href="#" class="search-close js-search-close"><span
						class="icon-close2"></span></a>
					<form action="#" method="post">
						<input type="text" class="form-control"
							placeholder="Search keyword and hit enter...">
					</form>
				</div>
			</div>

			<div class="container">
				<div class="d-flex align-items-center justify-content-between">
					<div class="logo">
						<div class="site-logo">
							<a href="index.jsp" class="js-logo-clone">Pharma</a>
						</div>
					</div>

					<div class="main-nav d-none d-lg-block">
						<nav class="site-navigation text-right text-md-center"
							role="navigation">
							<ul class="site-menu js-clone-nav d-none d-lg-block">
								<li class="active"><a href="index.jsp">Home</a></li>
								<li><a href="#" data-toggle="modal"
									data-target="#addProductModal">AddProduct</a></li>
								<li><a href="UserManufacturerOrder.jsp">Order</a></li>
							</ul>
						</nav>
					</div>

					<div class="icons">
						<a class="btn btn-primary" role="button" href="logout.jsp"> <%=session.getAttribute("uname")%>
							Logout
						</a>
					</div>
				</div>
			</div>
		</div>

		<!--********* Start Add Product Modal *********-->

		<div class="modal fade" id="addProductModal" tabindex="-1"
			aria-labelledby="exampleModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="exampleModalLabel">Add Product
							Details</h5>
						<button type="button" class="close" data-dismiss="modal"
							aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">

						<!-- *** Product details form Start *** -->

						<form action="addManufacturerProductProcess.jsp" method="post">
							<div class="form-group">
								<input type="text" class="form-control" name="mp_id"
									placeholder="Enter Unique Product ID">
							</div>
							<div class="form-group">
								<input type="text" class="form-control" name="mp_name"
									placeholder="Enter Product Name">
							</div>
							<div class="form-group">
								<textarea class="form-control p-4" name="mp_desc" rows="4"
									cols="50" placeholder="Enter Complaint Information"></textarea>
							</div>
							<div class="form-group">
								<input type="text" class="form-control" name="mp_price"
									placeholder="Enter Product Price">
							</div>
							<div class="form-group">
								<input type="file" class="form-control" name="image"
									placeholder="Give Product Image">
							</div>
							<div class="form-group">
								<input type="text" class="form-control" name="m_id"
									value="<%=session.getAttribute("uname")%>" readonly>
							</div>
							<button type="submit" class="btn btn-primary">SAVE</button>
						</form>

						<!-- *** Product details FORM END *** -->



						<!-- *** For error *** -->

						<div class="modal-footer">
							<%
							if (request.getAttribute("Error") != null) {
							%>
							<font size="2" color="red"><%=request.getAttribute("Error")%></font>
							<%
							}
							%>
						</div>

						<!-- *** For error *** -->

					</div>
				</div>
			</div>
		</div>

		<!--********* END Add Product Modal *********-->



		<!-- Here fetching all the rows of the particular manufaturer which has been logged in , so that we can further perform operations on it -->

		<%
		Connection con = (Connection) application.getAttribute("mycon");
		PreparedStatement ps = null; // declared and initialized to null 

		ps = con.prepareStatement("select * from wholesaler_order where m_id=?", ResultSet.TYPE_SCROLL_SENSITIVE,
				ResultSet.CONCUR_UPDATABLE);

		ps.setString(1, (String) session.getAttribute("uname"));
		ResultSet rs = ps.executeQuery();
		%>


		<!-- ***Our Popular Products Section Start*** -->

		<div class="site-section">
			<div class="container">
				<div class="row">

					<div class="title-section text-center col-12">
						<h2 class="text-uppercase">Order Status</h2>
					</div>
				</div>


				<div class="row">
					<!-- Shree Hari Vitthala! -->

					<table class="table">
						<thead>
							<tr>

								<th style="font-weight: bold; color: black;" scope="col">Sr.</th>
								<th style="font-weight: bold; color: black;" scope="col">Order Id</th>
								<th style="font-weight: bold; color: black;" scope="col">Company Name</th>
								<th style="font-weight: bold; color: black;" scope="col">Address</th>
								<th style="font-weight: bold; color: black;" scope="col">Email</th>
								<th style="font-weight: bold; color: black;" scope="col">Products</th>
								<th style="font-weight: bold; color: black;" scope="col">WholeSaler's Id</th>
								<th style="font-weight: bold; color: black;" scope="col">Actions</th>

								<%
								if (rs.next()) {
									int i = 1;

									rs.previous();

									while (rs.next()) {
								%>
							
							<tr>
								<%--<td><%=i++%></td>--%>	
								<td style="font-weight: bold; color: black;"><%=i++%></td>
								<td><%=rs.getString(1)%></td>
								<td><%=rs.getString(5)%></td>
								<td><%=rs.getString(6)%></td>
								<td><%=rs.getString(9)%></td>
								<td>
									<%
									String s = rs.getString(12);
									//System.out.println(s) ;
									//{"prmp_2":[6," Cital\n\t\t\t\t\t\t\t",80],"prmp_5":[2," Bio Derma\n\t\t\t\t\t\t\t",700],"prmp_3":[1," Honitus\n\t\t\t\t\t\t\t",200],"prmp_4":[1," Septilin\n\t\t\t\t\t\t\t",100]}

									JSONObject data = new JSONObject(s);
									Iterator<String> it = data.keys(); // prmp_2 , prmp_4 , prmp_5 ,.....
									int qty;
									int price;
									String name;
									int j = 1 ;

									while (it.hasNext()) {
										JSONArray values = data.getJSONArray(it.next()); //it.next() return the keys... and data.getJSONArray(it.next()) fetches that particular array element , just like arr[1] , arr[2] ...
										// values ---> [ 6," Cital\n\t\t\t\t\t\t\t",80]
										//[ 0,           1            , 2]
										qty = values.getInt(0);
										name = values.getString(1);
										price = values.getInt(2);
									%> 
										<%--Item_<%=j++ %><br>--%>	
										<span class="text-dark">Product_<%=j++ %></span><br>
																
										Qty : <%=qty%> , 
									Name : <%=name%> , 
									 Price : <%=price%> <br> <%
 									}
 									%>
								</td>
								<td><%=rs.getString(14)%></td>
								
								<td>
								<% if( rs.getString(15).equals("0") ){ %>
								<!-- here we are sending the wo_id to next page to make the status of that particular id from 0 -> 1 -->
								<a type="button" href="userManufacturerAccept_WOrder.jsp?wo_id=<%=rs.getString(1) %>" class=" btn btn-danger btn-sm" >Accept</a>
								<%}
								else{
								%>
								<span class="text-sucess text-dark">Accepted</span>
								<%} %>
								</td>
								
							</tr>

							<%
							}

							} else {

							}
							%>
							</tr>
						</thead>
					</table>


				</div>


				<div class="row mt-5">
					<div class="col-12 text-center">
						<a href="shop.html" class="btn btn-primary px-4 py-3">View All
							Products</a>
					</div>
				</div>
			</div>
		</div>

		<!-- ***Products Section END*** -->


		<!-- New Products Section Start -->
		<div class="site-section bg-light">
			<div class="container">
				<div class="row">
					<div class="title-section text-center col-12">
						<h2 class="text-uppercase">New Products</h2>
					</div>
				</div>
				<div class="row">
					<div class="col-md-12 block-3 products-wrap">
						<div class="nonloop-block-3 owl-carousel">
							<!-- Add your new product blocks here -->
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--*** New Products Section End **** -->

	</div>


	<!-- JavaScript Libraries -->
	<script src="js/jquery-3.3.1.min.js"></script>
	<script src="js/jquery-ui.js"></script>
	<script src="js/popper.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script src="js/owl.carousel.min.js"></script>
	<script src="js/jquery.magnific-popup.min.js"></script>
	<script src="js/aos.js"></script>
	<script src="js/main.js"></script>
</body>
</html>
