package io.jans.agamalab;

import com.nimbusds.oauth2.sdk.http.HTTPRequest;
import com.nimbusds.oauth2.sdk.http.HTTPResponse;

import io.jans.service.cdi.util.CdiUtil;
import io.jans.service.CacheService;
import io.jans.service.MailService;

import java.io.*;
import java.net.URL;
import java.security.SecureRandom;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class EmailUtils {

    private static final int OTP_LENGTH = 6;
    private static final SecureRandom RAND = new SecureRandom();
    
    private static final String BANNED_DOMAINS_KEY = "agamalab_blocked";
    private static final int duration = (int) TimeUnit.DAYS.toSeconds(10);
    private static final String BANNED_DOMAINS_URL = 
        "https://raw.githubusercontent.com/disposable-email-domains/disposable-email-domains/refs/heads/main/disposable_email_blocklist.conf";

    private static final Logger logger = LoggerFactory.getLogger(EmailUtils.class);

    public static String sendOTP(String to, ContextData context) {

        IntStream digits = RAND.ints(OTP_LENGTH, 0, 10);
        String otp = digits.mapToObj(i -> "" + i).collect(Collectors.joining());
        
        EmailTemplate et = new EmailTemplate(otp, context);
        MailService mailService = CdiUtil.bean(MailService.class);

        if (mailService.sendMail(to, et.subject(), et.nakedBody(), et.body())) {
            logger.debug("E-mail has been delivered to {} with code {}", to, otp);
            return otp;
        }
        logger.debug("E-mail delivery failed, check jans-auth logs");
        return null;

    }
    
    public static boolean isDummy(String email) {

        boolean dummy = false;
        try {
            CacheService cacheService = CdiUtil.bean(CacheService.class);
            String blocked = (String) cacheService.get(BANNED_DOMAINS_KEY);
            
            if (blocked == null) {
    
                HTTPRequest request = new HTTPRequest(HTTPRequest.Method.GET, new URL(BANNED_DOMAINS_URL));
                request.setConnectTimeout(2000);
                request.setReadTimeout(2000);
                
                logger.info("Retrieving list of e-mail domains to block");
                HTTPResponse r = request.send();
                int status = r.getStatusCode(); 
    
                if (status != 200) {
                    logger.warn("Unable to retrieve list. Response code was {}", status); 
                } else {
                    blocked = r.getBody();
                    
                    if (blocked == null) {
                        logger.warn("E-mail block list is empty!");
                    } else {
                        logger.info("E-mail block list has {} bytes", blocked.length());
                        cacheService.put(duration, BANNED_DOMAINS_KEY, blocked);
                    }
                }
            } 
            if (blocked != null) {
                logger.info("Checking if entered e-mail belongs to banned e-mail providers");
    
                try (BufferedReader br = new BufferedReader(new StringReader(blocked))) {
                    //list is supposed to be lowercased already
                    dummy = br.lines().filter(domain -> email.toLowerCase().endsWith("@" + domain))
                                .findAny().isPresent();
                }
            }
        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
        return dummy;
        
    }

}