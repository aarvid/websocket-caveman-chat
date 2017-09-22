var wsocket = null;
var wsocketUrlPath = '/chat-server';
function webSocketOnMessage(event) {
    var datum = event.data;
    var msg = JSON.parse(datum);
    var chatBox = $('#chat-div');
    var msgDiv = $('<DIV></DIV>');
    var bNode = $('<B></B>');
    var nameNode = document.createTextNode(msg.name + ': ');
    var msgNode = document.createTextNode(msg.text);
    console.log('message', datum);
    bNode.append(nameNode);
    msgDiv.append(bNode).append(msgNode);
    return chatBox.append(msgDiv);
};
function webSocketConnect() {
    wsocket = new WebSocket('ws' + (window.location.protocol === 'https:' ? 's' : '') + '://' + window.location.host + wsocketUrlPath);
    wsocket.onmessage = webSocketOnMessage;
    return console.log('connect');
};
function connectClick() {
    return webSocketConnect();
};
function enterClick() {
    if (wsocket) {
        var nameBox = $('#username');
        if (nameBox.length) {
            wsocket.send(JSON.stringify({ type : 'enter', value : $(nameBox).val() }));
        };
    };
    return true;
};
function messageClick() {
    if (wsocket) {
        var msgBox = $('#msg-input');
        if (msgBox.length) {
            wsocket.send(JSON.stringify({ type : 'message', value : $(msgBox).val() }));
        };
    };
    return true;
};
function exitClick() {
    return wsocket ? wsocket.send(JSON.stringify({ type : 'exit', value : '' })) : null;
};
function closeClick() {
    return wsocket ? wsocket.close() : null;
};
