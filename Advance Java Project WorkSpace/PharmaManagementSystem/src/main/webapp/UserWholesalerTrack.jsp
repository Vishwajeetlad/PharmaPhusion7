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
</head>

<body>
	<div class="site-wrap">

		<!-- Navbar Section START -->

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

								<li class="has-children"><a href="#">Manufacturer</a>

									<ul class="dropdown">
										<li><a href="#" data-toggle="modal"
											data-target="#selectManufacturerModal">Select
												Manufacturer</a></li>

										<li><a href="#" data-toggle="modal"
											data-target="#trackOrder">Track</a></li>

									</ul></li>
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

			<!-- Establishing a Database Connection.... -->

			<%
			Connection con = (Connection) application.getAttribute("mycon");
			PreparedStatement ps = null; // declared and initialized to null
			ResultSet rs = null;
			/* Sql Query for fetching the manufacturers from the database */
			ps = con.prepareStatement("select * from manufacturer", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = ps.executeQuery(); // excuted the query
			%>


			<!--********* Start Track Modal *********-->

			<div class="modal fade" id="trackOrder" tabindex="-1"
				aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="exampleModal Label">Track Your
								Order</h5>
							<button type="button" class="close" data-dismiss="modal"
								aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>
						<div class="modal-body">
							<!-- we are taking the Wholesaler's product's id which we are going to track
					disclaimer -> we should verify that the taken wo_id is really taken by current wholesaler or not 
					else -> what will happen for eg( w_1 will take the data from db of the product which is has not ordered)
					Therefore we should verify it , whether the slected wo_id was it's own product or not 
					in short we have to match . That's it. -->

							<form action="UserWholesalerTrack.jsp" method="post">
								<!-- the type's hidden as , it should not be seen . But we are passing two things to next jsp page , those are : { uname(w_id) , Product's track id(wo_id) } -->
								<input type="hidden" name="w_id"
									value="<%=session.getAttribute("uname")%>">
								<div class="form-group">
									<input type="text" name="wo_id" class="form-control"
										id="exampleInputEmaili" aria-describedby="emailHelp"
										placeholder="Enter Track ID">
								</div>
								<button type="submit" class="btn btn-primary">Track</button>
							</form>
						</div>
					</div>
				</div>
			</div>

			<!--********* END Track Modal *********-->




			<!--********* Start Select Manufacturer Modal *********-->

			<div class="modal fade" id="selectManufacturerModal" tabindex="-1"
				aria-labelledby="exampleModalLabel" aria-hidden="true">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<h5 class="modal-title" id="selectManufacturerModal">Select
								Manufacturer</h5>
							<button type="button" class="close" data-dismiss="modal"
								aria-label="Close">
								<span aria-hidden="true">&times;</span>
							</button>
						</div>

						<!-- *** Select Manufacturer Form Start *** -->

						<div class="modal-body">

							<form action="UserWholesalerPurchaseHome.jsp" method="post">

								<!-- choose Manufacturer -->

								<div class="form-group ">
									<select id="user" name="userTypeId" class="form-control">
										<!-- here i have kept the value from the input into name(as selectedManufacturer) -->
										<option selected>Select Manufacturer....</option>
										<%
										if (rs != null) {
											while (rs.next()) {
												// Fetch and display each manufacturer
										%>
										<option><%=(String) rs.getString(1)%></option>
										<%
										}
										} else {
										request.setAttribute("Error", "*Either Manufacturers are short or please give valid credentials");
										%>
										<jsp:forward page="UserWholesalerHome.jsp"></jsp:forward>
										<%
										}
										%>
									</select>
								</div>

								<button type="submit" class="btn btn-primary">Fetch
									Products</button>

							</form>

							<!-- *** Select Manufacturer FORM END *** -->


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
							<!-- *** Error End *** -->

						</div>

						<!-- *** Select Manufacturer Form END *** -->

					</div>
				</div>
			</div>

			<!-- *** Select Manufacturer MODAL END *** -->

		</div>

		<!-- Navbar Section END -->




		<!-- ***Our Popular Products Section Start*** -->

		<div class="site-section">
			<div class="container">
				<div class="row">

					<div class="title-section text-center col-12">
						<h2 class="text-uppercase">Our Popular Products</h2>
					</div>
				</div>


				<div class="row">


					<table class="table table-striped">
						<thead>
							<tr>
								<th scope="col">Sr.</th>
								<th scope="col">ProductId</th>
								<th scope="col">Information</th>
								<th scope="col">Date & Time</th>
							</tr>
						</thead>
						<tbody>

							<!-- Fetching the details of the product's id i.e wo_id and who is requesting the tracking w_id -->
							<!-- here we gonna make the match , means verification/validity whether correct wholesaler is trying to fetch it's ordered products tracking* -->
							<%
							// fetched the w_id . (wholesaler's id)
							String w_id = request.getParameter("w_id"); // as we have stored the w_id which was fetched from the session in UserWholesalerHome.jsp . As it's stored in as <input> we are accessing through the req.getPara() ;
							// fetched the wo_id .(w_product id)
							String wo_id = request.getParameter("wo_id");

							/* ps = con.prepareStatement("select * from mproduct where m_id=?", ResultSet.TYPE_SCROLL_SENSITIVE,
									ResultSet.CONCUR_UPDATABLE); */
							//ps.setString(1, (String) session.getAttribute("uname")); // uname means the wholeSaler which we choosed in last login page
							//rs = ps.executeQuery();

							ps = con.prepareStatement("select * from wholesaler_order where w_id=? and wo_id=?", ResultSet.TYPE_SCROLL_SENSITIVE,
									ResultSet.CONCUR_UPDATABLE);

							ps.setString(1, w_id); // w_id means the wholesaler's id , who is requesting the tracking
							ps.setString(2, wo_id); // wo_id means the product's id which is to be tracked
							rs = ps.executeQuery();

							if (rs.next()) {
								// if and only if valid then it comes back , else no ......
								// once it coems in , means we are ready to fetch the product's details
								ps = con.prepareStatement("select * from wholesaler_order_track where wo_id=?", ResultSet.TYPE_SCROLL_SENSITIVE,
								ResultSet.CONCUR_UPDATABLE);

								ps.setString(1, wo_id); // w_id means the wholesaler's id , who is requesting the tracking
								rs = ps.executeQuery();
								if (rs.next()) {
									// order found
									int i = 1;
									//System.out.println("System Founded!" + rs.getString(2));
									rs.previous();
									while (rs.next()) {
							%>

							<tr>
								<th scope="row"><%=i++%></th>
								<td><%=rs.getString(2)%></td>
								<td><%=rs.getString(3)%></td>
								<td><%=rs.getString(4)%></td>
							</tr>

							<%
							}
							} else {
							System.out.println("System Not Founded!");
							// order not present and not found!
							}
							} else {
							System.out.println("Product Not Found!");
							// order not present and not found!
							}
							%>
							
						</tbody>
					</table>
					
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
