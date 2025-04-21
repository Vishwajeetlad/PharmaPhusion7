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
								<li><a href="UserManufacturerOrder.jsp">Orders</a></li>
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



		<%
		Connection con = (Connection) application.getAttribute("mycon");
		PreparedStatement ps = null; // declared and initialized to null 

		ps = con.prepareStatement("select * from mproduct where m_id=?", ResultSet.TYPE_SCROLL_SENSITIVE,
				ResultSet.CONCUR_UPDATABLE);

		ps.setString(1, (String) session.getAttribute("uname"));
		ResultSet rs = ps.executeQuery();
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
