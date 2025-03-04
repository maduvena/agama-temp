package io.jans.agamalab

import java.time.*
import java.time.format.DateTimeFormatter

class EmailTemplate {
    
    private static DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMMM dd, YYYY, HH:mma (O)")

    private String otp
    private ContextData context

    EmailTemplate(String otp, ContextData context) {
        this.otp = otp
        this.context = context
    }
    
    String subject() {
        "Your One-Time Password (OTP) for login to Gluu's portal is ${otp}"
    }
    
    String nakedBody() {
        "${otp} is the code to complete your verification"
    }

    String body() {

        """
<div style="width: 640px; font-size: 18px; font-family: 'Roboto', sans-serif; font-weight: 300">
    <div style="background-color: #b6f6da; border-bottom: 1px solid #0ca65d">
        <img src="https://gluu.org/wp-content/uploads/elementor/thumbs/Logo-qbe8p4qgmufqni0becxda6fnfib6krzb65uihag270.png" alt="Gluu Inc." />
    </div>
    <div style="padding: 12px; border-bottom: 1px solid #ccc;">
        <p>
        <b>Dear user,</b>
        <br><br>
        Thank you for choosing to log in to Gluu's portal. To ensure the security of your account, we have implemented an additional layer of protection through One-Time Password (OTP) verification.
        </p>
        <p>
        Your OTP is: 
        </p>
        <div style="display: flex; justify-content: center">
            <div style="background-color: #b6f6da; color: #0ca65d; font-size: 40px; font-weight: 400; letter-spacing: 6px" align="center">
                ${otp}
            </div>
        </div>
        <p>
        Please enter this code when prompted during the login process. Note this OTP is valid for a single use only and will expire shortly.
        </p>        
        <p>
        <br>
        Best regards,<br>
        The Gluu Team
        <br><br>
        </p>
    </div>
    <div style="padding: 12px; background-color: #ecf0f5; font-size: 16px">
        <p style="color: #48596b; font-weight: 500">When and where this happened<p>
        <p><span style="color: #48596b; font-weight: 500">Date:</span><br>${computeDateTime(context.timeZone)}</p>
        <p><span style="color: #48596b; font-weight: 500">${context.device.length() == 0 ? '' : ('Device:</span><br>' + context.device)}</p>
        <p><span style="color: #48596b; font-weight: 500">${context.location.length() == 0 ? '' : ('Approximate Location:</span><br>' + context.location)}</p>
    </div>
</div>
        """
    }

    private static String computeDateTime(String zone) {

        Instant now = Instant.now()
        try {
            return now.atZone(ZoneId.of(zone)).format(formatter)
        } catch (Exception e) {
            return now.atOffset(ZoneOffset.UTC).format(formatter)
        }
        
    }
    
}
