<#import "commons.ftlh" as com>
<#import "contextual.ftlh" as cont>
<@com.main>
<#assign captcha=(recaptcha.enabled!false)>
<#if captcha>

    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    <script>
        var robot = true
        
        function doSubmit() {            
            if (!robot) {
                document.forms[0].requestSubmit()
            }
        }

        //Apparently this function only gets invoked just once
        function onSubmit(token) {
            console.log("Captcha passed")
            robot = false
            //Calling doSubmit explicitly won't trigger the form submit... weird :-/
            setTimeout(doSubmit, 100)
        }
    </script>

</#if>

<div class="col-lg-10">

    <div class="border border-1 rounded-3 bg-white p-5 shadow">

        <#if captcha>
            <noscript>
                <p align="center" class="text-danger mb-4">Javascript is disabled.
                    Please enable Javascript and refresh this page!</p>
            </noscript>
        </#if>

        <h2 class="main-head mb-5">Please complete your profile data:</h2>

        <#if message??>
            <p align="center" class="text-danger mb-4">${message}</p>
        </#if>

        <form method="post" enctype="application/x-www-form-urlencoded">
            <div class="mb-3 row">
                <label for="givenName" class="col-md-3 col-form-label required">First name</label>
                <div class="col-md-9">
                    <input type="text" class="form-control" name="givenName" id="givenName"
                        placeHolder="Joan" value="${name!}" required autofocus>
                </div>
            </div>
            <div class="mb-3 row">
                <label for="sn" class="col-md-3 col-form-label required">Last name</label>
                <div class="col-md-9">
                    <input type="text" class="form-control" name="sn" id="sn" placeHolder="Jett" required>
                </div>
            </div>

            <#if !(email??)>
                <div class="mb-3 row">
                    <label for="email" class="col-md-3 col-form-label required">E-mail</label>
                    <div class="col-md-9">
                        <input type="email" class="form-control" name="email" id="email"
                            placeHolder="name@example.com" required>
                    </div>
                </div>
            </#if>

            <div class="mb-3 row">
                <label for="o" class="col-md-3 col-form-label">Company</label>
                <div class="col-md-9">
                    <input type="text" class="form-control" name="o" id="o">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="c" class="col-md-3 col-form-label">Country</label>
                <div class="col-md-9 pt-2">
                    <@com.countries selectName="c" />
                </div>
            </div>
            <div class="mb-3 row">
                <label for="jansTitle" class="col-md-3 col-form-label">Job title</label>
                <div class="col-md-9">
                    <input type="text" class="form-control" name="jansTitle" id="jansTitle">
                </div>
            </div>
            <div class="mb-3 row">
                <label for="jansRole" class="col-md-3 col-form-label">I am an</label>
                <div class="col-md-9 pt-2">
                    <select class="form-select" name="jansRole" id="jansRole">
                        <option value="Developer">Developer</option>
                        <option value="Business Analyst">Business Analyst</option>
                        <option value="DevOps Engineer">DevOps Engineer</option>
                        <option value="Identity Architect">Identity Architect</option>
                        <option value="Cybersecurity Engineer">Cybersecurity Engineer</option>
                        <option value="Student/Researcher">Student/Researcher</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
            </div>
            <div class="mb-4 row">
                <label for="jansProfileURL" class="col-md-3 col-form-label">LinkedIn URL</label>
                <div class="col-md-9">
                    <input type="URL" class="form-control" name="jansProfileURL" id="jansProfileURL"
                        autocomplete="off">
                </div>
            </div>
            <div class="mb-4 row">
                <div class="col-md-12 d-flex justify-content-end">
                    <#if captcha>
                        <button onClick="javascript:doSubmit()" data-sitekey="${recaptcha.site_key}"
                            data-callback="onSubmit"
                            class="g-recaptcha btn btn-success px-4">Continue</button>
                        <#else>
                            <input type="submit" class="btn btn-success px-4" value="Continue">
                    </#if>
                </div>
            </div>

            <@cont.main />
        </form>
        <form method="post" enctype="application/x-www-form-urlencoded">
            <div class="row">
                <label class="col-md-6 col-form-label text-end">Already have an account?</label>
                <div class="col-md-6 d-flex justify-content-start">
                    <button class="btn btn-secondary px-4" type="submit" name="signIn" value="">
                        Sign in now!
                    </button>
                </div>
        </form>
    </div>
</div>

<script>
    window.onload = (event) => {
        fillContextData(${(captureLocation!false)?c})
    }
</script>

</@com.main>
