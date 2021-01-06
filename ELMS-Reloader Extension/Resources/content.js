function checkIfTimeout() {
    const title = document.getElementsByTagName('h1')?.item(0)
    if(title?.innerHTML == "タイムアウト") {
        return true
    } else {
        return false
    }
}

if(checkIfTimeout()) {
    url = new URL(location.href)
    query = url.search
    location.href = "https://aidipigakunin.oicte.hokudai.ac.jp/pub/login.cgi" + query
} else {
    let UserRequestValue = "UserRequest"
    let PassRequestValue = "PassRequest"
    
    function requestIdentifier(name, resolve) {
        const request = { requestType:"Identifier", "name":name}
        return browser.runtime.sendMessage(request).then(response => {
            console.log("Got a response", response)
            if(response?.error) console.error("Error from background:", response?.error)
            return response?.value
        }).then(resolve)
    }

    const userPromise = requestIdentifier(UserRequestValue, (value) => {
        var pass_input = document.getElementById('username_input')
        if(pass_input) {
            pass_input.value = value
            return value
        } else {
            console.warn('User input not found.')
        }
    });

    const passPromise = requestIdentifier(PassRequestValue, (value) => {
        var pass_input = document.getElementById('password_input')
        if(pass_input) {
            pass_input.value = value
            return value
        } else {
            console.warn('Password input not found.')
        }
    });
    
    Promise.all([userPromise, passPromise]).then((user, pass) => {
        var button = document.getElementById('login_button')
        var error_message = document.getElementById('error_message')
        if(!error_message) {
            button?.click()
        }
    });
}
