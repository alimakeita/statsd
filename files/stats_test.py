import socket
sock = socket.socket( socket.AF_INET,
socket.SOCK_DGRAM )
sock.sendto("ping:1|c", ("127.0.0.1", 8125))
