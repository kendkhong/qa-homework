defmodule HomeworkTest do
  # Import helpers
  use Hound.Helpers
  use ExUnit.Case
  import IO
  import Finch
  import QaHomework.LocatePageHeaderText
  import QaHomework.LocatePageSubheaderText
  import QaHomework.LocateFlashMessagesText
  import QaHomework.Constants

  # Start hound session and destroy when tests are run
  hound_session()

  test "Verify form authentication" do
    navigate_to("https://the-internet.herokuapp.com/login",5)

    assert page_title() =~ "The Internet"
    take_screenshot("test/ui/screenshots/pagetitle_success.png")

    # Verify header text
    element = get_page_header_text(:tag, "h2")
    assert visible_text(element) == "Login Page"
    take_screenshot("test/ui/screenshots/pageheader_success.png")

    # Verify subheader text
    element = get_page_subheader_text(:class, "subheader")
    assert visible_text(element) == "This is where you can log into the secure area. Enter tomsmith for the username and SuperSecretPassword! for the password. If the information is wrong you should see error messages."
    take_screenshot("test/ui/screenshots/pagesubheader_success.png")

    # Verify form input
    loginform = find_element(:id, "login") 
    find_within_element(loginform, :id, "username") |> fill_field(valid_username())
    find_within_element(loginform, :id, "password") |> fill_field(valid_password()) 
    :timer.sleep(2000)
    take_screenshot("test/ui/screenshots/filloutform_success.png")
    
    find_within_element(loginform, :tag, "button") |> click()

    # Verify successfully logged in screen
    element = get_flash_messages_text(:id, "flash-messages")
    assert visible_text(find_within_element(element, :id, "flash")) == "You logged into a secure area!\n×"

    element = get_page_header_text(:tag, "h2")
    assert visible_text(element) == "Secure Area"

    element = get_page_subheader_text(:class, "subheader") 
    assert visible_text(element) == "Welcome to the Secure Area. When you are done click logout below."
    take_screenshot("test/ui/screenshots/loggedin_success.png")

    :timer.sleep(2000)
    # Log out
    find_element(:tag, "a") |> click()
    take_screenshot("test/ui/screenshots/loggedout_success.png")

  end


  test "Verify invalid form input" do
    navigate_to("https://the-internet.herokuapp.com/login",5)


    # Verify invalid form input
    loginform = find_element(:id, "login") 
    find_within_element(loginform, :id, "username") |> fill_field(Enum.random(invalid_username()))
    find_within_element(loginform, :id, "password") |> fill_field(Enum.random(invalid_password()))
    :timer.sleep(2000)
    take_screenshot("test/ui/screenshots/filloutform_unsuccess.png")

    # submit form
    find_within_element(loginform, :tag, "button") |> click()

    # Verify successfully logged in screen
    element = get_flash_messages_text(:id, "flash-messages")
    assert visible_text(find_within_element(element, :id, "flash")) == "Your username is invalid!\n×"
    take_screenshot("test/ui/screenshots/loginfailure_success.png")

  end

  test "Verify JS Alert dialog" do
    navigate_to("https://the-internet.herokuapp.com/javascript_alerts",5)

    find_element(:xpath, ~s|//*[@onclick="jsAlert()"]|) |> click() 
    :timer.sleep(2000)
    puts dialog_text()
    assert dialog_text() == "I am a JS Alert"
    accept_dialog()
    take_screenshot("test/ui/screenshots/jsalertpop_success.png")

  end

  test "Verify JS Prompt dialog" do
    navigate_to("https://the-internet.herokuapp.com/javascript_alerts",5)

    find_element(:xpath, ~s|//*[@onclick="jsPrompt()"]|) |> click() 
    :timer.sleep(3000)
    puts dialog_text()
    assert dialog_text() == "I am a JS prompt"
    input_into_prompt("Ken Khong")
    accept_dialog()
    take_screenshot("test/ui/screenshots/jsprompt_success.png")

  end
  test "Verify checkbox" do
    navigate_to("https://the-internet.herokuapp.com/checkboxes",5)

    form = find_element(:id, "checkboxes")
    enabledcheckbox1 = find_within_element(form, :tag, "input")
    click(enabledcheckbox1)
    assert element_enabled?(enabledcheckbox1)
    disabledcheckbox1 = find_within_element(form, :xpath, ~s|//*[@type="checkbox"]|)
    click(disabledcheckbox1)
    take_screenshot("test/ui/screenshots/checkbox_success.png")    

  end

  ##############################################################################
  ## Building and testing a simple API call here
  ##############################################################################

  defp build_request(path) do
    request_url = "https://the-internet.herokuapp.com/#{path}"
    build(:get, request_url, [{"Content-Type", "application/json"}]) |> request(MyFinch)

  end

  defp parse_response({:ok, %Finch.Response{status: 200, body: body}}) do
    Jason.decode(body)
  end

  defp parse_response({:ok, %Finch.Response{status: error_code, body: body}}) do
    {:error, {:http, error_code, body}}
  end

  defp parse_response({:error, _exception} = error), do: error

  test "Verify API call and response" do
    build_request("status_codes/200")
    |> parse_response()

  end

end
