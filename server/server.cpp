#include "server.h"

void * clientConnect(void * arg)
{
    ThreadArg * ptarg = (ThreadArg *)arg;
    SrvPI srvPI;

    while (1)
    {
        srvPI.run(ptarg->fd);
    }

    return(NULL);
}


int main(int argc, char **argv)
{
    struct sockaddr_in  cliaddr;
    socklen_t len = sizeof(cliaddr);
    char buff[MAXLINE];
    int listenfd, srvConnfd;

    Socket listenSocket(SRV_SOCKET, NULL, CTRPORT);
    listenfd = listenSocket.init();

    std::cout << "Listen socket port: " << CTRPORT << std::endl;

    pthread_t tid;
    ThreadArg threadArg;

    while (1)
    {  
        srvConnfd = listenSocket.tcpAccept(listenfd, (SA *) &cliaddr, &len);
        printf("control conection from %s, port %d\n",
                inet_ntop(AF_INET, &cliaddr.sin_addr.s_addr, buff, sizeof(buff)), ntohs(cliaddr.sin_port));
        
        threadArg.fd = srvConnfd;
        Pthread_create(&tid, NULL, &clientConnect, &threadArg);
    }
    return 0;   
}


