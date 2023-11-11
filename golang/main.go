package main

import (
	"log"
	"net/url"

	"github.com/gorilla/websocket"
)

func handleIncomingMessage(messageType int, message []byte) {
	log.Printf("Received: %s", message)
}

func main() {
	u := url.URL{Scheme: "wss", Host: "www.deribit.com", Path: "/ws/api/v2/"}

	c, _, err := websocket.DefaultDialer.Dial(u.String(), nil)
	if err != nil {
		log.Fatal("dial:", err)
	}
	defer c.Close()

	for {
		mt, message, err := c.ReadMessage()
		if err != nil {
			log.Println("read:", err)
			return
		}
		handleIncomingMessage(mt, message)
	}
}
