<#import "../agamalab/commons.ftlh" as com>
<@com.main>

<div class="border border-1 rounded-3 bg-white p-5 shadow">

    <#assign exists = (accountExists!false)>
    <h2 class="main-head mb-5">
        <#if exists>
            We need to verify it's you
        <#else>
            <#-- No user is currently associated to <span class="i">${email}</span> -->
            E-mail verification
        </#if>
    </h2>

    <p class="mb-5">
        <#if resent!false>
            We sent another email with a code.
        <#else>
            <#if !exists>
                Before creating an account for you we need to verify your e-mail address.
            </#if>
            Check your inbox - you'll get an email with a code shortly.
        </#if>        
    </p>

    <#if !(matches!true)>
        <p align="center" class="text-danger mb-4">Wrong code entered!</p>
    </#if>

    <form method="post" enctype="application/x-www-form-urlencoded">
        <div class="mb-3 row">
            <label for="passcode" class="col-md-5 col-form-label">Enter the code sent</label>
            <div class="col-md-7">
                <input type="text" class="form-control" id="passcode" name="passcode"
                        pattern="[0-9]+" placeHolder="000000" autocomplete="off" required autofocus>
                <#-- Pressing the enter key on this field triggers submission via the FIRST submit button found in the page -->
            </div>
        </div>
        <div class="mb-4 row">
            <div class="col-md-12 d-flex justify-content-end">
                <input type="submit" class="btn btn-success px-4" value="Continue">
            </div>
        </div>
    </form>

    <form method="post" enctype="application/x-www-form-urlencoded">
        <div class="row">
            <div class="d-flex justify-content-center fs-5">
                Didn't get the e-mail?
                <button type="submit" class="btn btn-link p-0 ps-1" name="resend" value="">resend code</button>
            </div>
        </div>
    </form>
</div>

</@com.main>
