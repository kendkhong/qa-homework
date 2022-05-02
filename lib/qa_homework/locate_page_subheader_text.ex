defmodule QaHomework.LocatePageSubheaderText do
     use Hound.Helpers

     
     def get_page_subheader_text(strategy, selector) do
          find_element(strategy,selector,2)
     end

end