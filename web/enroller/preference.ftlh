<#import "../agamalab/commons.ftlh" as com>
<@com.main>

<script>
    function hideAlert() {
        let alert = document.getElementById("alert")
        if (alert) {
            alert.remove();
        }
    }
    window.onload = (event) => {
        setTimeout(hideAlert, 3000)
    }
</script>

<@com.nojs />

<div class="border border-1 rounded-3 bg-white p-5 mb-3 shadow">

    <#if message??>
        <div align="center" class="py-3 alert alert-success" id="alert" role="alert">${message}</div>
    </#if>
    
    <h2 class="main-head mb-5">If you wish, choose a preferred method</h2>

    <p class="mb-4">This will be the credential you will be asked to present at login. 
        Your other credentials will act as alternatives</p>

    <form method="post" enctype="application/x-www-form-urlencoded">
        <#list methods as m>        
            <div class="mb-3 ps-3 fs-5">
                <input type="radio" name="pref" id="${m?counter}" value="${m}">
                <label class="link-secondary" for="${m?counter}">                    
                    <#if m == "io.jans.casa.authn.otp">
                        One-time verification code
                    <#elseif m == "io.jans.casa.authn.passphrase">
                        Your passphrase
                    <#elseif m == "io.jans.casa.authn.fido2">
                        Your fido device
                    </#if>
                </label>
            </div>
        </#list>
        <div align="center" class="pt-3 mb-4">
            <input type="submit" class="btn btn-success px-4" value="Continue">
        </div>        
    </form>
</div>

</@com.main>
