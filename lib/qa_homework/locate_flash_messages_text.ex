defmodule QaHomework.LocateFlashMessagesText do
     use Hound.Helpers

     
     def get_flash_messages_text(strategy, selector) do
          find_element(strategy,selector,2)
     end

end