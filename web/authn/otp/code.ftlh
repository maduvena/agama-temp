<#import "../../agamalab/commons.ftlh" as com>
    <#import "../commons.ftlh" as authncom>

        <@com.main>

            <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/js/all.min.js"
                integrity="sha512-2bMhOkE/ACz21dJT8zBOMgMecNxx0d37NND803ExktKiKdSzdwn+L7i9fdccw/3V06gM/DBWKbYmQvKMdAA9Nw=="
                crossorigin="anonymous" referrerpolicy="no-referrer" async>
                </script>

            <@com.nojs />

            <div class="border border-1 rounded-3 bg-white p-5 shadow">

                <h2 class="main-head mb-5">${name!}, check your phone's OTP app</h2>

                <div class="row justify-content-center">
                    <div class="col-2 py-4">
                        <img src="assets/OTP.png" />
                    </div>
                </div>

                <#if !(matches!true)>
                    <p align="center" class="text-danger mb-4">Wrong code entered!</p>
                </#if>

                <form method="post" enctype="application/x-www-form-urlencoded">
                    <div class="mb-5 row">
                        <label for="passcode" class="col-sm-5 col-form-label">Enter the code displayed</label>
                        <div class="col-sm-3">
                            <input type="text" class="form-control" id="passcode" name="passcode" pattern="[0-9]+"
                                placeHolder="000000" autocomplete="off" required autofocus>
                            <#-- Pressing the enter key on this field triggers submission via the FIRST submit button
                                found in the page -->
                        </div>
                        <div class="col-sm-4">
                            <input type="submit" class="btn btn-success px-3" value=" Login ">
                        </div>
                    </div>
                </form>
                <#if escape!false>
                    <@authncom.main />
                </#if>
            </div>

        </@com.main>
