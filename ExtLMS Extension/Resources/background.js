let UserRequestValue = "UserRequest"
let PassRequestValue = "PassRequest"

async function requestIdentifierToContainer(name) {
    let message = {
        requestType: "Identifier",
        name: name
    }
    browser.runtime.sendNativeMessage("application.id", message, response => {
        console.log("Got a response from container:", response)
        return response.value
    });
}

function requestUser() {
    return requestIdentifierToContainer("UserRequest")
}

function requestPass() {
    return requestIdentifierToContainer("PassRequest")
}

function differedResponse(request) {
    const requestType = request?.requestType ?? ""
    switch(requestType) {
        case "Identifier": {
            const name = request?.name ?? ""
            
            switch(name) {
                case "User": {
                    return requestUser()
                }
                case "Pass": {
                    return requestPass()
                }
                default: {
                    console.error("Incomplete identifier name")
                }
            }
            break
        }
        default: {
            console.error("Unhandled requestType")
        }
    }
}

browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log("Received message: ", request);
//    differedResponse(request).then(sendResponse)

    let message = {request:request?.name}
    browser.runtime.sendNativeMessage("application.id", message, function(response) {
        console.log("Received response from native container", response);
        sendResponse(response)
    });
    return true
});
