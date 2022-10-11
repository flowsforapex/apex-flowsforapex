select 
   json_object(
      key 'lang' value 'en',
      key 'messages' value
   json_arrayagg(
      json_object(
         key 'text_key' value enm.fmsg_message_key,
         key 'source' value enm.fmsg_message_content,
         key 'target' value enm.fmsg_message_content
      pretty)
   returning clob pretty)
   returning clob pretty)
from flow_messages enm
where enm.fmsg_lang = 'en';