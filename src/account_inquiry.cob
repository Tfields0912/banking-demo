       IDENTIFICATION DIVISION.
       PROGRAM-ID. ACCOUNT-INQUIRY.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USERS-FILE ASSIGN TO "data/users.dat"
              ORGANIZATION IS LINE SEQUENTIAL.
           SELECT ACCOUNTS-FILE ASSIGN TO "data/accounts.dat"
              ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD USERS-FILE.
       01 USERS-RECORD.
           05 UR-USER-ID    PIC X(10).
           05 UR-NAME       PIC X(40).
           05 UR-ADDRESS    PIC X(80).
           05 UR-CITY       PIC X(40).
           05 UR-STATE      PIC X(2).
           05 UR-ZIPCODE    PIC X(5).
           05 UR-DOB        PIC X(10).
           05 UR-PHONE      PIC X(12).
           05 UR-PAD        PIC X(1).

       FD ACCOUNTS-FILE.
       01 ACCOUNTS-RECORD.
           05 AR-ACCOUNT-ID PIC X(10).
           05 AR-USER-ID    PIC X(10).
           05 AR-BALANCE    PIC 9(9)V99.
           05 AR-STATUS     PIC X(8).
           05 AR-TYPE       PIC X(8).
           05 AR-PAD        PIC X(3).

       WORKING-STORAGE SECTION.
       01 CONTROL-FLAGS.
           05 EOF-FLAG PIC X VALUE "N".
           05 USER-FOUND-FLAG PIC X VALUE "N".
           05 LIST-FOUND-FLAG PIC X VALUE "N".

       01 INPUT-FIELDS.
           05 TRANS-CHOICE PIC X VALUE SPACE.
           05 TARGET-USER-ID PIC X(10).

       01 ACCOUNT-RECORD-FIELDS.
           05 ACCOUNT-ID       PIC X(10).
           05 USER-ID          PIC X(10).
           05 STATUS-STR       PIC X(10).
           05 ACCOUNT-TYPE-STR PIC X(10).
           05 BALANCE-NUM      PIC S9(9)V99.
           05 BALANCE-DISPLAY  PIC -Z(9)9.99.

       01 OUTPUT-FIELDS.
           05 BALANCE-COL PIC X(12).
           05 ACCOUNT-ID-COL PIC X(12).
           05 ACCOUNT-TYPE-COL PIC X(10).
           05 STATUS-COL PIC X(10).

       01 USER-RECORD-FIELDS.
           05 USER-NAME PIC X(40).
           05 USER-ADDRESS PIC X(80).
           05 USER-CITY PIC X(40).
           05 USER-STATE PIC X(2).
           05 USER-ZIPCODE PIC X(5).
           05 USER-DOB PIC X(10).
           05 USER-PHONE PIC X(12).

       01 SYSTEM-FIELDS.
           05 SYSTEM-COMMAND PIC X(200).

       PROCEDURE DIVISION.
       MAIN.
           DISPLAY "ENTER USER ID: " WITH NO ADVANCING
           ACCEPT TARGET-USER-ID
           MOVE FUNCTION TRIM(TARGET-USER-ID) TO TARGET-USER-ID

           IF TARGET-USER-ID = SPACES
              DISPLAY "USER ID IS REQUIRED."
              STOP RUN
           END-IF

           DISPLAY SPACE
           DISPLAY "USER INFORMATION"
           DISPLAY "----------------"
           PERFORM DISPLAY-USER-INFO

           DISPLAY SPACE
           DISPLAY "ACCOUNT INFORMATION"
           DISPLAY "-------------------"
           PERFORM LIST-USER-ACCOUNTS

           IF USER-FOUND-FLAG = "Y"
              DISPLAY SPACE
              DISPLAY "VIEW TRANSACTION HISTORY? (Y/N): "
                 WITH NO ADVANCING
              ACCEPT TRANS-CHOICE
              MOVE FUNCTION UPPER-CASE(TRANS-CHOICE) TO TRANS-CHOICE

              IF TRANS-CHOICE = "Y"
                MOVE "./bin/transaction-history" TO SYSTEM-COMMAND
                CALL "SYSTEM" USING SYSTEM-COMMAND
              END-IF
           END-IF

           STOP RUN.

       DISPLAY-USER-INFO.
           MOVE "N" TO EOF-FLAG USER-FOUND-FLAG
           OPEN INPUT USERS-FILE

           PERFORM UNTIL EOF-FLAG = "Y"
           READ USERS-FILE
           AT END
              MOVE "Y" TO EOF-FLAG
           NOT AT END
              IF UR-USER-ID = TARGET-USER-ID
                 MOVE "Y" TO USER-FOUND-FLAG
                 MOVE UR-USER-ID   TO USER-ID
                 MOVE UR-NAME      TO USER-NAME
                 MOVE UR-ADDRESS   TO USER-ADDRESS
                 MOVE UR-CITY      TO USER-CITY
                 MOVE UR-STATE     TO USER-STATE
                 MOVE UR-ZIPCODE   TO USER-ZIPCODE
                 MOVE UR-DOB       TO USER-DOB
                 MOVE UR-PHONE     TO USER-PHONE
                 DISPLAY "USER ID: " FUNCTION TRIM(USER-ID)
                 DISPLAY "NAME:    " FUNCTION TRIM(USER-NAME)
                 DISPLAY "ADDRESS: " FUNCTION TRIM(USER-ADDRESS)
                 DISPLAY "CITY:    " FUNCTION TRIM(USER-CITY)
                 DISPLAY "STATE:   " FUNCTION TRIM(USER-STATE)
                 DISPLAY "ZIPCODE: " FUNCTION TRIM(USER-ZIPCODE)
                 DISPLAY "DOB:     " FUNCTION TRIM(USER-DOB)
                 DISPLAY "PHONE:   " FUNCTION TRIM(USER-PHONE)
                 MOVE "Y" TO EOF-FLAG
              END-IF
           END-READ
           END-PERFORM

           CLOSE USERS-FILE

           IF USER-FOUND-FLAG NOT = "Y"
              DISPLAY "USER ID: " TARGET-USER-ID
              DISPLAY "NAME:    USER NOT FOUND"
           END-IF.

       LIST-USER-ACCOUNTS.
           MOVE "N" TO EOF-FLAG LIST-FOUND-FLAG
           OPEN INPUT ACCOUNTS-FILE

           DISPLAY "ACCOUNT ID    TYPE        BALANCE       STATUS"
           DISPLAY "----------------------------------------------"

           PERFORM UNTIL EOF-FLAG = "Y"
           READ ACCOUNTS-FILE
           AT END
              MOVE "Y" TO EOF-FLAG
           NOT AT END
              PERFORM LOAD-ACCOUNT-FIELDS
              IF FUNCTION TRIM(USER-ID) = TARGET-USER-ID
                 MOVE "Y" TO LIST-FOUND-FLAG
                 MOVE BALANCE-NUM TO BALANCE-DISPLAY
                 MOVE SPACES TO ACCOUNT-ID-COL ACCOUNT-TYPE-COL
                 MOVE SPACES TO BALANCE-COL STATUS-COL
                 MOVE FUNCTION TRIM(ACCOUNT-ID) TO ACCOUNT-ID-COL
                 MOVE FUNCTION TRIM(ACCOUNT-TYPE-STR)
                    TO ACCOUNT-TYPE-COL
                 MOVE FUNCTION TRIM(BALANCE-DISPLAY) TO BALANCE-COL
                 MOVE FUNCTION TRIM(STATUS-STR) TO STATUS-COL
                 DISPLAY ACCOUNT-ID-COL "  "
                    ACCOUNT-TYPE-COL "  $"
                    BALANCE-COL " "
                    STATUS-COL
              END-IF
           END-READ
           END-PERFORM

           CLOSE ACCOUNTS-FILE

           IF LIST-FOUND-FLAG NOT = "Y"
              DISPLAY "NO ACCOUNTS FOUND FOR USER."
           END-IF.

       LOAD-ACCOUNT-FIELDS.
           MOVE AR-ACCOUNT-ID TO ACCOUNT-ID
           MOVE AR-USER-ID    TO USER-ID
           MOVE AR-BALANCE    TO BALANCE-NUM
           MOVE AR-STATUS     TO STATUS-STR
           MOVE AR-TYPE       TO ACCOUNT-TYPE-STR.
