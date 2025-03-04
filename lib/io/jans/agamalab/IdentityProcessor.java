package io.jans.agamalab;

import io.jans.as.common.model.common.User;
import io.jans.as.common.service.common.UserService;
import io.jans.orm.exception.operation.EntryNotFoundException;
import io.jans.service.EncryptionService;  
import io.jans.service.cdi.util.CdiUtil;
import io.jans.util.StringHelper;

import java.io.IOException;
import java.util.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import static io.jans.inbound.Attrs.*;

public class IdentityProcessor {

    private static final Logger logger = LoggerFactory.getLogger(IdentityProcessor.class);

    private static final String INUM_ATTR = "inum";
    private static final String EXT_ATTR = "jansExtUid";
    private static final String EXT_UID_PREFIX = "github:";
    private static final String ROLE_ATTR = "role";
        
    public static Map<String, String> accountFromEmail(String email) {

        checkEmail(email);
        User user = getUser(MAIL, email);
        boolean local = user != null;
        logger.debug("There is {} local account for {}", local ? "a" : "no", email);

        if (local) {
            String uid = getSingleValuedAttr(user, UID);
            String inum = getSingleValuedAttr(user, INUM_ATTR);
            String name = getSingleValuedAttr(user, GIVEN_NAME);

            if (name == null) {
                name = getSingleValuedAttr(user, DISPLAY_NAME);

                if (name == null) {
                    name = email.substring(0, email.indexOf("@"));
                }
            }
            //I need a modifiable map 
            return new HashMap<>(Map.of(UID, uid, INUM_ATTR, inum, "name", name, "email", email));
        }
        return new HashMap<>();

    }

    public static Map<String, String> remoteAccountDetails(String rid, String email) {
        
        String extUid = externalIdOf(rid);
        User user = getUser(EXT_ATTR, extUid);
        boolean remote = user != null;
        
        if (!remote) {
            logger.debug("No match found via external uid, checking with email");
            checkEmail(email);

            user = getUser(MAIL, email);
            remote = user != null;
        }
        
        Map<String, String> details = null;
        logger.debug("There is {} account mapping either to remote account {} or local {}", 
                remote ? "an" : "no", extUid, email);
        
        if (remote) {
            details = new HashMap<>();            

            for (String attr : Arrays.asList(INUM_ATTR, UID, GIVEN_NAME)) {
                String val = getSingleValuedAttr(user, attr);
                if (val != null) {
                    details.put(attr.equals(GIVEN_NAME) ? "name" : attr, val);
                }
            }
        }
        return details;

    }
    
    public static String externalIdOf(String id) {
        return EXT_UID_PREFIX + id;
    }
    
    public static String onboard(Map<String, String> profile, Set<String> attributes, String extUid)
        throws Exception {
        
        User user = new User();
        if (StringHelper.isEmpty(profile.get(GIVEN_NAME))) throw new Exception("First name not provided");

        if (extUid != null) {
            user.setAttribute(EXT_ATTR, extUid, true);
        }
        
        attributes.forEach(attr -> {
                String val = profile.get(attr);
                if (StringHelper.isNotEmpty(val)) {
                    user.setAttribute(attr, val);
                }
        });
        UserService userService = CdiUtil.bean(UserService.class);
        
        user = userService.addUser(user, true);
        if (user == null) throw new EntryNotFoundException("Added user not found");
        
        return getSingleValuedAttr(user, INUM_ATTR);
        
    }

    public static String link(String userInum, boolean encrypted, String id, boolean forceLink) throws Exception {
        
        String inum = encrypted ? CdiUtil.bean(EncryptionService.class).decrypt(userInum) : userInum;
        String extId = externalIdOf(id);
        logger.debug("Processing linking of external user {} to local user {}", extId, inum);
        
        User user = getUser(INUM_ATTR, inum);
        if (user == null) {
            logger.error("User identified with {} not found!", inum);
            throw new IOException("Target user for account linking does not exist");
        }

        String uid = getSingleValuedAttr(user, UID);
        List<String> extUidsList = user.getAttributeValues(EXT_ATTR);

        Set<String> extUids = new HashSet<>();
        extUids.add(extId);
        
        for (String extUid : extUidsList) {
            if (extUid.startsWith(EXT_UID_PREFIX)) {

                if (!forceLink) {
                    logger.info("Linking aborted");
                    return uid;
                }

                logger.warn("User with external ID {} will be now linked to {}", extUid, extId);
            } else {
                extUids.add(extUid);
            }
        }

        user.setExternalUid(null);      //temp hack so the following line really takes effect
        user.setAttribute(EXT_ATTR, extUids.toArray(new String[0]), true);
        //The setAttribute(String, List<String>, boolean) version does weird stuff when used from Groovy

        UserService userService = CdiUtil.bean(UserService.class);
        userService.updateUser(user);
        return uid;

    }
    
    public static void updateRole(String uid, String roleValue) {
        
        try {            
            User user = getUser(UID, uid);
            HashSet<String> roles = new HashSet<>(Optional.ofNullable(
                    user.getAttributeValues(ROLE_ATTR)).orElse(Collections.emptyList()));            
            logger.debug("Current roles for user {} are {}", uid, roles);

            if (!roles.contains(roleValue)) {
                roles.add(roleValue);
                user.setAttribute(ROLE_ATTR, roles.toArray(new String[0]), true);
                //The setAttribute(String, List<String>, boolean) version does weird stuff when used from Groovy

                logger.info("Updating user's roles");
                CdiUtil.bean(UserService.class).updateUser(user);
            }

        } catch (Exception e) {
            logger.error(e.getMessage(), e);
        }
        
    }

    private static void checkEmail(String email) {
        if (!Optional.ofNullable(email).orElse("").contains("@"))
            throw new IllegalArgumentException("Invalid syntax in e-mail");
    }
    
    private static User getUser(String attributeName, String value) {
        UserService userService = CdiUtil.bean(UserService.class);
        return userService.getUserByAttribute(attributeName, value, true);
    }

    private static String getSingleValuedAttr(User user, String attribute) {

        Object value = null;
        if (attribute.equals(UID)) {
            //user.getAttribute("uid", true, false) always returns null :(
            value = user.getUserId();
        } else {
            value = user.getAttribute(attribute, true, false); 
        }
        return value == null ? null : value.toString();

    }
    
}
