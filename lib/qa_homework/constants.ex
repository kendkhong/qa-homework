defmodule QaHomework.Constants do

     def valid_username, do: "tomsmith"
     def invalid_username, do: ["jsmith", "jdoe", "jsally"]
     
     def valid_password, do: "SuperSecretPassword!"
     def invalid_password, do: ["password", "wrongpassword", "tryagain"]

end