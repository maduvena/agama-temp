<#import "commons.ftlh" as com>
<#import "contextual.ftlh" as cont>
<@com.main>

    <h2 class="main-head mb-5">Welcome Back</h2>
    
    <p align="center" class="fw-bold">Please enter your details to sign in</p>
    <#if message??>
        <h3 style="color:#f00" align="center">${message}</h3>
    </#if>
    <div class="border border-1 rounded p-5 bg-white shadow col-lg-9">
    
        <form method="post" enctype="application/x-www-form-urlencoded">
    
            <div class="mb-4 row">
                <label for="username" class="col-md-4 col-lg-12 col-form-label">Enter your e-mail</label>
            </div>
            <div class="mb-4 row">
                <div class="col-md-12">
                    <input type="email" class="form-control" name="email" id="email"
                        placeHolder="name@example.com" value="${email!}" required autofocus>
                </div>
            </div>
            <div class="mb-4 row">
                <div class="col-md-12 d-flex">
                    <input type="submit" class="btn btn-success px-4 flex-fill" value="Continue">
                </div>
            </div>
            <div class="mb-4 row">
                <div class="col">
                    <hr>
                </div>
                <div class="col-auto">OR</div>
                <div class="col">
                    <hr>
                </div>
            </div>
            <@cont.main />
        </form>
    
        <form method="post" enctype="application/x-www-form-urlencoded">
            <div class="mb-4 row">
                <div class="col-md-12 d-flex">
                    <button type="submit" class="btn btn-dark px-4 flex-fill" name="githubSignIn" value="">
                        Sign in with GitHub
                    </button>
                </div>
            </div>
        </form>
        <form method="POST" enctype="application/x-www-form-urlencoded">
            <div class="mb-3 row">
                <label class="col-md-6 col-form-label text-end">Don't have an
                    account?</label>
                <div class="col-md-6 d-flex justify-content-start">
                    <button type="submit" class="btn btn-secondary" name="signUp" value="">
                        Sign Up Now!
                    </button>
                </div>
            </div>
        </form>
    </div>
    
    <script>
        window.onload = (event) => {
            fillContextData(${(captureLocation!false) ? c});
        }
    </script>
</@com.main>
