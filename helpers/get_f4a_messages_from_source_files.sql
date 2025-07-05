DECLARE
    v_line VARCHAR2(4000);
    v_key VARCHAR2(100);
    v_text VARCHAR2(4000);
    v_file UTL_FILE.FILE_TYPE;
BEGIN
    -- Open the extracted messages file
    v_file := UTL_FILE.FOPEN('DATA_DIR', 'extracted_messages.txt', 'R');

    LOOP
        BEGIN
            -- Read each line
            UTL_FILE.GET_LINE(v_file, v_line);

            -- Extract the message key and text
            v_key := REGEXP_SUBSTR(v_line, '^\'[^\']+\'');
            v_text := REGEXP_SUBSTR(v_line, '\'.*\'$', 1, 2);

            -- Insert into the table
            INSERT INTO engine_messages (message_key, message_text)
            VALUES (v_key, v_text);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                EXIT;
        END;
    END LOOP;

    -- Close the file
    UTL_FILE.FCLOSE(v_file);
END;
/
