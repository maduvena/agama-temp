<#macro main>

<#-- this macro must be called within an html form only, hopefully just before its closing tag -->

<input type="hidden" name="location" id="location" value="">
<input type="hidden" name="device" id="device" value="">
<input type="hidden" name="zone" id="zone" value="">

<script src="platform.js">
    //Platform.js v1.3.6 (https://github.com/bestiejs/platform.js)
</script>

<script>
    function attachHeaders(xhr, headers) {

        for (var i = 0; i < headers.length; i++) {
            xhr.setRequestHeader(headers[i].name, headers[i].value)
        }

    }

    function attachEvents(xhr, res, rej) {

        xhr.onload = () => {
            if (xhr.status < 300) {
                return res(xhr.responseText)
            } else {
                return rej(xhr.responseText)
            }
        }
        xhr.onerror = () => rej(xhr.statusText)

    }

    function genericGET(url, headers) {

        return new Promise((resolve, reject) => {
            const xhr = new XMLHttpRequest()
            xhr.open("GET", url)
            if (headers) {
                attachHeaders(xhr, headers)
            }
            attachEvents(xhr, resolve, reject)
            xhr.send()
        })

    }

    function setDisplayableLocation(city, state, country) {

        let lolo = [city, state, country].filter((lo) => lo != null)
        let ty = lolo.join(", ")
        console.log("You are in " + ty)
        document.getElementById("location").value = ty

    }

    function processLocation(obj, zoneProp, cityProp, stateProp, countryProp) {

        if (zoneProp && obj[zoneProp])
            document.getElementById("zone").value = obj[zoneProp]

        let country = obj[countryProp], state = obj[stateProp], city = obj[cityProp]

        if (!country && !state && !city) throw new Error("No country/state/city found")

        setDisplayableLocation(city, state, country)

    }

    function fillContextData(captureLocation) {

        if (platform && platform.description) {
            document.getElementById("device").value = platform.description
        }

        if (captureLocation) {

            genericGET("https://api.ipapi.is", [])
                .then(result => {

                    let obj = JSON.parse(result)
                    if (!obj.location) throw new Error("ipapi - no location object")

                    processLocation(obj.location, "timezone", "city", "state", "country")   //"countryCode"
                })
                .catch(err => {
                    console.log("IPAPI call failed:" + err)

                    genericGET("https://freeipapi.com/api/json/", [])
                        .then(result => {
                            let obj = JSON.parse(result)

                            processLocation(obj, "timeZone", "cityName", "regionName", "countryName")   //"country_code"
                        })
                        .catch(err => console.log("FREEIPAPI call failed:" + err))
                }) 
        }
    }
</script>

</#macro>
