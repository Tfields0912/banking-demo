       IDENTIFICATION DIVISION.
       PROGRAM-ID. BANK-MENU.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 CHOICE PIC X VALUE SPACE.
       01 DONE-FLAG PIC X VALUE "N".
       01 SYSTEM-COMMAND PIC X(200).

       PROCEDURE DIVISION.
       MAIN.
           PERFORM UNTIL DONE-FLAG = "Y"
              DISPLAY SPACE
              DISPLAY "=== MENU ==="
              DISPLAY SPACE
              DISPLAY "1) RESET DATA"
              DISPLAY "2) CREATE USER"
              DISPLAY "3) CREATE ACCOUNT"
              DISPLAY "4) ACCOUNT INQUIRY"
              DISPLAY "5) WITHDRAW/DEPOSIT"
              DISPLAY "6) LIST TRANSACTIONS"
              DISPLAY "7) CLOSE ACCOUNT"
              DISPLAY "8) EXIT"
              DISPLAY SPACE
              DISPLAY "SELECT OPTION: " WITH NO ADVANCING
              ACCEPT CHOICE

              EVALUATE CHOICE
                 WHEN "1"
                    MOVE "./bin/reset-data" TO SYSTEM-COMMAND
                    CALL "SYSTEM" USING SYSTEM-COMMAND
                 WHEN "2"
                    MOVE "./bin/create-user" TO SYSTEM-COMMAND
                    CALL "SYSTEM" USING SYSTEM-COMMAND
                 WHEN "3"
                    DISPLAY "NEED TO ADD"
                 WHEN "4"
                    MOVE "./bin/account-inquiry" TO SYSTEM-COMMAND
                    CALL "SYSTEM" USING SYSTEM-COMMAND
                 WHEN "5"
                    DISPLAY "NEED TO ADD"
                 WHEN "6"
                    DISPLAY "NEED TO ADD"
                 WHEN "7"
                    DISPLAY "NEED TO ADD"
                 WHEN "8"
                    MOVE "Y" TO DONE-FLAG
                 WHEN OTHER
                    DISPLAY "INVALID OPTION."
              END-EVALUATE
           END-PERFORM

           DISPLAY "GOODBYE!"
           STOP RUN.
