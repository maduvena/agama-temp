<#import "../agamalab/commons.ftlh" as com>
<@com.main>

<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/js/all.min.js" 
        integrity="sha512-2bMhOkE/ACz21dJT8zBOMgMecNxx0d37NND803ExktKiKdSzdwn+L7i9fdccw/3V06gM/DBWKbYmQvKMdAA9Nw=="
        crossorigin="anonymous" referrerpolicy="no-referrer" async>
</script>

<script>
    function select(m) {
        document.getElementById("method").value = m;
        document.forms[0].submit();
    }
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

<style>
    a {
        text-decoration: none;
    }
    .icon {
        width:3.5rem;
    }
</style>

<@com.nojs />

<div class="border border-1 rounded-3 bg-white p-5 shadow">

    <#assign msg = (notification.message!)>
    <#if notification.isError>
        <div align="center" class="py-3 alert alert-danger" id="alert" role="alert">
            <#if msg?length gt 0>
                ${msg}
            <#else>
                There was a problem adding that credential. Try another option from the below list.
            </#if>
        </div>
    <#elseif msg?length gt 0>
        <div align="center" class="py-3 alert alert-success" id="alert" role="alert">${msg}</div>
    </#if>    

    <h2 class="main-head mb-5">Secure your account by adding multiple authentication credentials</h2>

    <p class="mb-4">
        <#if ncreds==0>
            You are required to enroll <b>${minRequired} credentials</b>.
            Choose from the options below to add them.
        <#else>
            <#assign remain = (minRequired - ncreds)>
            You have to add <b>${remain} more</b> credential<#if remain gt 1>s</#if>.
            Choose from the options below:       
        </#if>
    </p>
    
    <form method="post" enctype="application/x-www-form-urlencoded" class="ps-3">
        <#list methods as m>
            <a href="javascript:select('${m}')" class="link-secondary d-flex align-items-center fs-5">
                <#if m == "io.jans.casa.authn.otp">

                    <div class="fs-1 link-success icon">
                        <i class="fas fa-qrcode"></i>
                    </div>
                    <p class="m-0 ps-2">
                        Use a mobile app like Google Authenticator to get one-time verification codes in your phone
                    </p>
                <#elseif m == "io.jans.casa.authn.passphrase">
                    <div class="fs-1 link-success icon">
                        <i class="fa-solid fa-asterisk"></i>
                    </div>
                    <p class="m-0 ps-2">?
                    </p>
                <#elseif m == "io.jans.casa.authn.fido2">
                    <div class="fs-1 link-success icon">
                        <span class="fa-layers fa-fw" style="bottom:-.6rem;left:-.6rem">
                            <i class="fas fa-tablet" data-fa-transform="shrink-1"></i>
                            <i class="fas fa-mobile-alt" data-fa-transform="up-7 shrink-4"></i>
                            <i class="fas fa-stream" data-fa-transform="rotate--90 up-9 shrink-12"></i>
                        </span>
                    </div>
                    <p class="m-0">
                        Use Fido2-compliant devices such as security keys<!--, Windows Hello, Touch ID, Face ID, etc.-->
                    </p>
                </#if>
            </a>
            <br>
        </#list>
        <input type="hidden" id="method" name="method" value="">
    </form>

</div>

</@com.main>
