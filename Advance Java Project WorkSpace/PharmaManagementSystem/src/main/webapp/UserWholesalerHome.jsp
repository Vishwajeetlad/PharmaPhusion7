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




		<!-- Manufacturers's Product Displaying Section START -->

		<%
		ps = con.prepareStatement("select * from mproduct where m_id=?", ResultSet.TYPE_SCROLL_SENSITIVE,
				ResultSet.CONCUR_UPDATABLE);

		ps.setString(1, (String) session.getAttribute("uname")); // uname means the wholeSaler which we choosed in last login page
		rs = ps.executeQuery();
		%>


		<!-- ***Our Popular Products Section Start*** -->

		<div class="site-section">
			<div class="container">
				<div class="row">

					<div class="title-section text-center col-12">
						<h2 class="text-uppercase">Our Popular Products</h2>
					</div>
				</div>


				<div class="row">

					<!-- Fetching the data from the database and trying to display that .... START -->

					<!-- This will print only 1 product (i have written it separately but , i wanted to show that sale one!! baby! , else i was able to write it in while() itself -->
					<%
					if (rs.next()) {

						Blob image = null;
						byte[] imgData = null;
						image = rs.getBlob(5);
						imgData = image.getBytes(1, (int) image.length());
						String encode = Base64.getEncoder().encodeToString(imgData);
						request.setAttribute("imgBase", encode);
					%>
					<div class="col-sm-6 col-lg-4 text-center item mb-4">
						<span class="tag">Sale</span> <a href="shop-single.html"> <img
							src="data:image/jpeg;base64,${imgBase}" class="img-fluid rounded"
							style="width: 200px; height: 200px; object-fit: cover;"
							alt="Image"></a>
						<h3 class="text-dark">
							<a href="shop-single.html"><%=rs.getString(2)%></a>
						</h3>
						<p class="price">
							<!-- SALE Part START -->
							<!-- See you can apply this SALE function to any of the product manually take this .... -->
							<del>
								$<%=Integer.parseInt(rs.getString(4)) + 100%></del>
							&mdash; $<%=rs.getString(4)%>
						</p>
						<!-- SALE Part END -->
					</div>
					<%
					}

					while (rs.next()) {
					Blob image = null;
					byte[] imgData = null;
					image = rs.getBlob(5);
					imgData = image.getBytes(1, (int) image.length());
					String encode = Base64.getEncoder().encodeToString(imgData);
					request.setAttribute("imgBase", encode);
					%>
					<div class="col-sm-6 col-lg-4 text-center item mb-4">
						<a href="shop-single.html"> <img
							src="data:image/jpeg;base64,${imgBase}" alt="Image"
							class="img-fluid rounded"
							style="width: 200px; height: 200px; object-fit: contain;"></a>
						<h3 class="text-dark">
							<a href="shop-single.html"><%=rs.getString(2)%></a>
						</h3>
						<p class="price">
							$<%=rs.getString(4)%></p>
					</div>
					<%
					}
					%>
				</div>
				<!-- Fetching the data from the database and trying to display that .... END -->


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
