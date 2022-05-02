defmodule QaHomework.LocatePageHeaderText do
     use Hound.Helpers

     
     def get_page_header_text(strategy, selector) do
          find_element(strategy,selector,2)
     end

end