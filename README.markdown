# wsd-caveman-chat: A websocket-driver, caveman2, chat example

This common lisp project is an example of using websockets to create a browser based chat. In particular, it is a proof of concept using the first two libraries.

* [websocket-driver](https://github.com/fukamachi/websocket-driver): websocket server (using clack) in common lisp. This project ignores the websocket client side.
* [caveman2](http://8arrow.org/caveman/): web framework that uses [clack](https://github.com/fukamachi/clack) as the web-server front end and [djula](https://mmontone.github.io/djula/) as the html template engine.  This example uses [hunchentoot](http://weitz.de/hunchentoot/) as the web-server backend. This example ignores the DB part of caveman.
* [event-emitter](https://github.com/fukamachi/event-emitter): used in websocket-driver but also used to control the chat room.
* [jonathan](https://github.com/Rudolph-Miller/jonathan): to encode and decode JSON on the server side
* [parenscript](https://common-lisp.net/project/parenscript/): to generate browser side javascript including browser side websocket client.
* [log4cl](https://github.com/7max/log4cl): to generate logging information to understand what is going on.
* [string-case](https://github.com/pkhuong/string-case): fast `case` for strings 
* [alexandria](https://common-lisp.net/project/alexandria/): utilities

Another example project 

## Installation

Clone this project into quicklisp's local-project directory or another directory asdf's search path (i.e. ~/common-lisp).

    (ql:quickload :wsd-caveman-chat)

All dependencies are in quicklisp.

## Usage

After installation and loading of the system, in the repl:

    (wsd-caveman-chat:start)
    
Then open your browser to [http://localhost:8080/](http://localhost:8080/).

Want to use a different port? Do this instead:

    (wsd-caveman-chat:start :port 5000)

To stop,
 
    (wsd-caveman-chat:stop)
    
## Author

* andy peterson (andy.arvid@gmail.com)

## Copyright

No copyright is claimed by the author and you can copy the code as you wish

# License

Licensed under the Unlicense License.

