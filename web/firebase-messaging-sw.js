importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyB5fUpucFP5VWKK24yq36X-3_l60DMkadY",
  authDomain: "djrapp-5e308.firebaseapp.com",
  projectId: "djrapp-5e308",
  storageBucket: "djrapp-5e308.appspot.com",
  messagingSenderId: "166498548375",
  appId: "1:166498548375:web:cfe373443aa6d9337807d2",
  measurementId: "G-TS11ZPQ804"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});