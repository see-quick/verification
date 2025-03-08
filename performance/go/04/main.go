package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hello, World!"))
}

func main() {
	fmt.Println("Go HTTP server running on port 8080")
	http.HandleFunc("/", handler)
	http.ListenAndServe(":8080", nil)
}
