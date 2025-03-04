[#ftl output_format="HTML"]
<!DOCTYPE html>
<html lang="en">
<head></head>
<body>

  
  
  &lt;#import "commons.ftlh" as com&gt;
	&lt;#import "contextual.ftlh" as cont&gt;
	&lt;@com.main&gt;
	<h2 class="main-head mb-5">Welcome Back
	</h2>
	<p align="center" class="fw-bold">Please enter your details to sign in
	</p>
	&lt;#if message??&gt;
	<h3 align="center" id="idil">${message}
	</h3>
	<!--#if-->
	<div class="border border-1 rounded p-5 bg-white shadow col-lg-9">
	  <form method="post" enctype="application/x-www-form-urlencoded">
		<div class="mb-4 row">
		  <label for="username" class="col-md-4 col-lg-12 col-form-label">Enter your e-mail</label>
		</div>
		<div class="mb-4 row">
		  <div class="col-md-12">
			<input type="email" name="email" id="email" placeholder="name@example.com" value="${email!}" required="" autofocus="" class="form-control">
		  </div>
		</div>
		<div class="mb-4 row">
		  <div class="col-md-12 d-flex">
			<input type="submit" value="Continue" class="btn btn-success px-4 flex-fill">
		  </div>
		</div>
		<div class="mb-4 row">
		  <div class="col">
			<hr>
		  </div>
		  <div class="col-auto">OR
		  </div>
		  <div class="col">
			<hr>
		  </div>
		</div>
		&lt;@cont.main /&gt;
	  </form>
	  <form method="post" enctype="application/x-www-form-urlencoded">
		<div class="mb-4 row">
		  <div class="col-md-12 d-flex">
			<button type="submit" name="githubSignIn" value="" class="btn btn-dark px-4 flex-fill">
			  Sign in with GitHub
			</button>
		  </div>
		</div>
	  </form>
	   <form method="post" enctype="application/x-www-form-urlencoded">
		<div class="mb-4 row">
		  <div class="col-md-12 d-flex">
			<button type="submit" name="passkey" value="" class="btn btn-dark px-4 flex-fill">
			  Use Passkey
			</button>
		  </div>
		</div>
	  </form>
	  <form method="POST" enctype="application/x-www-form-urlencoded">
		<div class="mb-3 row">
		  <label class="col-md-6 col-form-label text-end">Don't have an
			account?</label>
		  <div class="col-md-6 d-flex justify-content-start">
			<button type="submit" name="signUp" value="" class="btn btn-secondary">
			  Sign Up Now!
			</button>
		  </div>
		</div>
	  </form>
	</div>
	<!--@com.main-->
  
  
</body>

<script>
	window.onload = (event) => {
	  fillContextData(${
					  (captureLocation!false) ? c}
	  );
	}
  </script>
</html>