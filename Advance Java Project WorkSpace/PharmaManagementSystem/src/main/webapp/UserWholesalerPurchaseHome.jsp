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
<link rel="stylesheet" href="fonts/icomoon/style.css">
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

										<li><a href="#">Track</a></li>

									</ul></li>
							</ul>
						</nav>
					</div>

					<div class="icons">

						<a href="cart.html" id="carta"
							class="icons-btn d-inline-block bag mx-4"> <!-- 'carta' means that cartBag icon -->
							<span class="icon-shopping-bag"></span>
							<span class="number" id="cart">0</span> <!-- 'cart' means that cartBag raiseTo wala icon -->
						</a> <a class="btn btn-primary" role="button" href="logout.jsp"> <%=session.getAttribute("uname")%>   <!-- uname -> wholesaler's ID kept in uname -->
							Logout
						</a>
					</div>
				</div>
			</div>
			
		<!-- Navbar Section END -->
		
		<!-- Fetching & Storing m_id received from last web-page's form which was stored in userTypeId-->
        <%
            String userTypeId = request.getParameter("userTypeId"); // Get m_id from last web-page where the value is stored in userrTypeId
            //System.out.println("userTypeId being fetched from the prev form of userWholesalerHome.jsp and that came here-->"+userTypeId ) ;

            if (userTypeId != null && !userTypeId.isEmpty()) {
                session.setAttribute("m_id", userTypeId); // Store in session the m_id if userTypeId is not null 
                //System.out.println("m_id stored in session -->"+session.getAttribute("m_id") ) ;
            } 
            else {
                userTypeId = (String) session.getAttribute("m_id"); // Retrieve from session
            }

        %>
        <!--  MODIFICATION END -->
			
			

			<!-- Establishing a Database Connection.... -->

			<%
			Connection con = (Connection) application.getAttribute("mycon");
			PreparedStatement ps = null; // declared and initialized to null
			ResultSet rs = null;
			/* Sql Query for fetching the manufacturers from the database */
			ps = con.prepareStatement("select m_id from manufacturer", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = ps.executeQuery(); // excuted the query
			%>


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
		//System.out.println("userTypeId -> "+request.getParameter("usertypeId")) ;
		userTypeId = request.getParameter("userTypeId");
		session.setAttribute("m_id", userTypeId); // storing the manufacturer's id as we WILL  need it
		ps = con.prepareStatement("select * from mproduct where m_id=?", ResultSet.TYPE_SCROLL_SENSITIVE,
				ResultSet.CONCUR_UPDATABLE);

		ps.setString(1, userTypeId);
		rs = ps.executeQuery();
		%>


		<!-- ***Manufacturer's Products Section Start*** -->

		<div class="site-section">
			<div class="container">
				<div class="row">

					<div class="title-section text-center col-12">
						<h2 class="text-uppercase">
							Manufacturer
							<%=userTypeId%>'s Products
						</h2>
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

							<a href="shop-single.html"> <span
								id="name<%=rs.getString(1)%>" class="divpr"> <%=rs.getString(2)%>
							</span>
							</a>

						</h3>
						<p class="price">
							<span id="price<%=rs.getString(1)%>" class="divpr"> <!-- SALE Part START -->
								<del>
									$<%=Integer.parseInt(rs.getString(4)) + 100%></del> &mdash; $<%=rs.getString(4)%>
								<%-- 								<%System.out.println(rs.getString(4)); %>--%>
							</span>
						</p>
						<!-- SALE Part END -->


						<!-- ADD TO CART BUTTON Section START -->

						<span id="divpr<%=rs.getString(1)%>" class="divpr">
							<button id="pr<%=rs.getString(1)%>" class="btn btn-primary cart">Add     <!-- class ['cart'] added to ['Add To Cart'] [Button] as a [class]-->
								To Cart</button>
						</span>

						<!-- ADD TO CART BUTTON Section END -->

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
							<a href="shop-single.html"> <span
								id="name<%=rs.getString(1)%>" class="divpr"> <%=rs.getString(2)%>
							</span>
							</a>
						</h3>
						<p class="price">
							$ <span id="price<%=rs.getString(1)%>" class="divpr"> <%=rs.getString(4)%>
							</span>
						</p>

						<!-- ADD TO CART BUTTON Section START -->

						<span id="divpr<%=rs.getString(1)%>" class="divpr">
							<button id="pr<%=rs.getString(1)%>" class="btn btn-primary cart">Add      <!-- class ['cart'] added to ['Add To Cart'] [Button] as a [class]-->
								To Cart</button>
						</span>

						<!-- ADD TO CART BUTTON Section END -->

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

		<!-- ***Manufacturer's Products Section END*** -->
		
		
		



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

	<script>
	
  	document.addEventListener("DOMContentLoaded", function () {
	    let m_id = "<%= session.getAttribute("m_id") %>";  
	    if (m_id && m_id !== "null") {
	        localStorage.setItem("m_id", m_id);  
	        console.log("Stored m_id in localStorage:", m_id);
	    }
	});  
	
	document.addEventListener("DOMContentLoaded", function() {
	
		// when cart is null , setting it to pointer-even(cursor) disabled.
		if (localStorage.getItem('cart') == null) { 
			console.log("Empty Cart");
			var cart = {}; // creating an emepty  
			const element = document.getElementById("carta");  // carta is the cartBag.
			element.classList.add("mydisabled");
			console.log("First Time !");
		} 
		else {
			console.log("Inside else") ;
			cart = JSON.parse(localStorage.getItem('cart'));
		}
		
		updateCart();

		/* $() -> jQuery selector function used to select all HTML element ---> similar to document.querySelectorAll() in JS .

		" .click() " --> jQuery() event listener listens for --> " mouse click "

		 function(){....}  --> anonymous function that executes the inside code when a click happens  */

		/* 
		1.  $('.cart') → Selects all elements with ***"class"*** .cart when the script runs.
		2.click(function() {...}) → Attaches a click event listener to those elements.
		3️. User Clicks → The function inside .click() executes only when a click happens.
		 */
		 
		 /* But above method is not good if dynamically a class is added or deleted */
		 
		 /* so prefer using Event Delegation */
		 //Event delegation (.on()) ensures that dynamically created elements also work.
		 // Using .on() prevents the need for a full page reload!
		 
		 //Instead of directly attaching the click event to elements with the .cart class, this attaches the event to the document and listens for clicks on any .cart button even if they are added dynamically later.


		$(document).on("click",".cart",function() {  // selects the all elements with 'cart' **as** a *****"CLASS"******** 

							var idstr = this.id.toString(); // this  ---> refers to the clicked element  // this.id --> gets the id of clicked element  // toString() -> iykik   prmp_1 , prmp_2 , prmp_3
							//console.log(" Clicked Add to Cart!");
							console.log(" Clicked Id --> " + idstr);
							if (cart[idstr] != undefined) {    // cart{ 'prmp_1' : undefined }
								//console.log("Clicked Add to Cart again and again !") ;
								cart[idstr][0] += 1; // cart{ 'prmp_1' : [ ( old_val + 1 ....) , 'p1' , 100 ] }
							} else {
								// means cart empty 
								//console.log("Comes only for first ADD TO CART Time !") ;
								qty = 1;
								a = idstr.slice(2); // here we have in 'a' as the product id ;  // mp_1
								console.log("Id -> " + a);
								name = document.getElementById('name' + a).innerHTML; // as we have stored namemp1 or namemp3 or namemp4 .....
								
								let priceText = document.getElementById("price" + a).innerHTML;

								// Check if <del> exists (means it's a sale price)
								if (priceText.includes("<del>")) {
								    let textContent = document.getElementById("price" + a).textContent; // Extract only visible text
								    // .textContent -> ignores all HTML tags
								    let priceArr = textContent.match(/\d+/g); // Extract all numbers
								    /* .match(/\d+/g): -> regular expression -> \d+ -> finds all numbers in text
								    	g flag means "global" , so it extracts all numbers */
								    	// priceArr[] = ["200", "100"] ;
								    price = parseInt(priceArr[priceArr.length - 1]); // Get the last number (actual price)
								} else {
								    // Directly parse if it's a simple number
								    price = parseInt(priceText);
								}
								console.log(price) ;

								cart[idstr] = [ qty, name, price ]; // cart{ 'prmp_1' : [ 1 , 'powder' , 100 ] , 'prmp_2' : [ 1 , 'cital' , 80 ] }
							}
							updateCart();   // fucntion called!

		});
		 
		 // function , if clicked on minus sign to reduce the products
		 $('.divpr').on("click","button.minus",function(){
			a = this.id.slice(7) ; //eg -> minusprmp_1 = mp_1
			cart['pr'+a][0] = cart['pr'+a][0] - 1 ;
			cart['pr'+a][0] = Math.max( 0 , cart['pr'+a][0] ) ;   // if value goes beyond 0 , then set to 0 only
			document.getElementById('valpr'+a).innerHTML = cart['pr'+a][0] ;
			updateCart() ;
			
		 });
		 
		 // function , if clicked on plus sign to reduce the products
		 
		 $('.divpr').on("click","button.plus",function(){
			a = this.id.slice(6) ; //eg -> plusprmp_1 = mp_1
			cart['pr'+a][0] = cart['pr'+a][0] + 1 ;
			document.getElementById('valpr'+a).innerHTML = cart['pr'+a][0] ;
			updateCart() ;
			
		 });
		 

			//********************* caution caution used 'cartTotalItems' instead of 'sum' for my understanding *************************
		function updateCart() {
			let cartTotalItems = 0; // instead of 'sum' , i have taken ' cartTotalItems '

			for (item in cart) { // item : prmp_1 , prmp_2 , prmp_3....
				//console.log("itemNo->"+item) ;

				cartTotalItems += cart[item][0]; // calculating all total items kept in cart from all the website to show in that raise to cart bag at the naavbaar
				//console.log( "total items in cart --> "+ cartTotalItems) ;
				//console.log("cartTotalItems : " + cartTotalItems); 
				//console.log("Happening each Time you click - or + ");
				if( cart[item][0] != 0 ){
					//console.log("Inside if cartItems are not zero") ;
					// only the button (innerHTML) is updated instead of whole span beacause , many event listeners might be lost when we replace the damn whole thing
				document.getElementById('div' + item).innerHTML = "<button id = minus" + item + " class='btn btn-primary minus'>-</button>"
						+ "<span id=val"+item+"> "
						+ cart[item][0]
						+ " </span> <button id = plus" + item + " class='btn btn-primary plus'>+</button>";
				}
				else{  							//( cart[item][0] == 0 )  // come back to original "Add To Cart" **Button** if 0 eleemnts are selected
					//console.log("Inside if cartItems are zero") ;
					delete cart[item] ;
					document.getElementById('div' + item).innerHTML = "<button id="+item+" class='btn btn-primary cart'>Add To Cart</button>"
				}
			}

			if (cartTotalItems == 0) {   
				//console.log("cartTotalItems -> " + cartTotalItems); 
				const element = document.getElementById("carta");  <!-- 'carta' means that cartBag icon -->				
				element.classList.add("mydisabled");	  // this is done so that when 'products == 0' then auto disable the button of 'cartBag'	
			}
			else {   
				const element = document.getElementById("carta");
				element.classList.remove("mydisabled");
			}
			
			document.getElementById('cart').innerHTML = cartTotalItems;		<!-- 'cart' means that cartBag *raiseTo* wala icon -->
			//console.log("Updated the bag's raise to ^ !" ); 
			
			// finally making changes into that localStorage after all clicking 
			
			localStorage.setItem('cart', JSON.stringify(cart));

		}
			
	});

			
	</script>

</body>
</html>
