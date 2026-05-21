       IDENTIFICATION DIVISION.
       PROGRAM-ID. CLOSE-ACCOUNT.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT ACCOUNTS-IN ASSIGN TO "data/accounts.dat"
              ORGANIZATION IS LINE SEQUENTIAL.
           SELECT ACCOUNTS-OUT ASSIGN TO "data/accounts.tmp"
              ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANSACTIONS-FILE ASSIGN TO "data/transactions.dat"
              ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD ACCOUNTS-IN.
       01 ACCOUNTS-IN-RECORD.
           05 AI-ACCOUNT-ID  PIC X(10).
           05 AI-USER-ID     PIC X(10).
           05 AI-BALANCE     PIC 9(9)V99.
           05 AI-STATUS      PIC X(8).
           05 AI-TYPE        PIC X(8).
           05 AI-PAD         PIC X(3).

       FD ACCOUNTS-OUT.
       01 ACCOUNTS-OUT-RECORD.
           05 AO-ACCOUNT-ID  PIC X(10).
           05 AO-USER-ID     PIC X(10).
           05 AO-BALANCE     PIC 9(9)V99.
           05 AO-STATUS      PIC X(8).
           05 AO-TYPE        PIC X(8).
           05 AO-PAD         PIC X(3).

       FD TRANSACTIONS-FILE.
       01 TRANSACTIONS-RECORD.
           05 TR-TIMESTAMP    PIC X(15).
           05 TR-ACCOUNT-ID   PIC X(10).
           05 TR-TYPE         PIC X(1).
           05 TR-AMOUNT       PIC 9(9)V99.
           05 TR-NEW-BALANCE  PIC 9(9)V99.
           05 TR-DESCRIPTION  PIC X(40).
           05 TR-PAD          PIC X(12).

       WORKING-STORAGE SECTION.
       01 CONTROL-FLAGS.
           05 EOF-FLAG PIC X VALUE "N".
           05 FOUND-FLAG PIC X VALUE "N".
           05 NOT-ZERO-FLAG PIC X VALUE "N".
           05 ALREADY-CLOSED-FLAG PIC X VALUE "N".
           05 INVALID-ENTRY-FLAG PIC X VALUE "N".

       01 INPUT-FIELDS.
           05 TARGET-ID PIC X(10).

       01 RECORD-FIELDS.
           05 ACCOUNT-ID     PIC X(10).
           05 USER-ID        PIC X(10).
           05 BALANCE-NUM    PIC S9(9)V99 VALUE 0.
           05 BALANCE-OUT    PIC Z(9)9.99.

       01 WORK-FIELDS.
           05 DATE-YYYYMMDD PIC X(8).
           05 TIME-HHMMSSCC PIC X(8).
           05 CLOSE-TRANS-DESC PIC X(40).
           05 CLOSE-TRANS-TYPE PIC X.

       01 SYSTEM-FIELDS.
           05 SYSTEM-COMMAND PIC X(200).

       PROCEDURE DIVISION.
       MAIN.
           DISPLAY "ENTER ACCOUNT ID: " WITH NO ADVANCING
           ACCEPT TARGET-ID
           MOVE FUNCTION TRIM(TARGET-ID) TO TARGET-ID

           IF TARGET-ID = SPACES
              DISPLAY "ACCOUNT ID IS REQUIRED."
              STOP RUN
           END-IF

           OPEN INPUT ACCOUNTS-IN
           OPEN OUTPUT ACCOUNTS-OUT

           PERFORM UNTIL EOF-FLAG = "Y"
           READ ACCOUNTS-IN
           AT END
           MOVE "Y" TO EOF-FLAG
           NOT AT END
           PERFORM PROCESS-ACCOUNT
           END-READ
           END-PERFORM

           CLOSE ACCOUNTS-IN
           CLOSE ACCOUNTS-OUT

           IF FOUND-FLAG = "Y"
              IF ALREADY-CLOSED-FLAG = "Y"
                 MOVE "rm -f data/accounts.tmp" TO SYSTEM-COMMAND
                 CALL "SYSTEM" USING SYSTEM-COMMAND
                 DISPLAY "ACCOUNT IS ALREADY CLOSED."
              ELSE IF INVALID-ENTRY-FLAG = "Y"
                 MOVE "rm -f data/accounts.tmp" TO SYSTEM-COMMAND
                 CALL "SYSTEM" USING SYSTEM-COMMAND
                 DISPLAY "ACCOUNT ENTRY IS INVALID."
              ELSE IF NOT-ZERO-FLAG = "Y"
                 MOVE "rm -f data/accounts.tmp" TO SYSTEM-COMMAND
                 CALL "SYSTEM" USING SYSTEM-COMMAND
                 DISPLAY "ACCOUNT BALANCE MUST BE ZERO."
              ELSE
                 MOVE "mv -f data/accounts.tmp data/accounts.dat"
                    TO SYSTEM-COMMAND
                 CALL "SYSTEM" USING SYSTEM-COMMAND
                 OPEN EXTEND TRANSACTIONS-FILE
                 ACCEPT DATE-YYYYMMDD FROM DATE YYYYMMDD
                 ACCEPT TIME-HHMMSSCC FROM TIME
                 MOVE "C" TO CLOSE-TRANS-TYPE
                 MOVE "ACCOUNT CLOSED" TO CLOSE-TRANS-DESC
                 MOVE SPACES TO TRANSACTIONS-RECORD
                 STRING
                 DATE-YYYYMMDD DELIMITED BY SIZE
                 "-" DELIMITED BY SIZE
                 TIME-HHMMSSCC(1:6) DELIMITED BY SIZE
                 INTO TR-TIMESTAMP
                 END-STRING
                 MOVE FUNCTION TRIM(TARGET-ID) TO TR-ACCOUNT-ID
                 MOVE CLOSE-TRANS-TYPE TO TR-TYPE
                 MOVE ZERO TO TR-AMOUNT
                 MOVE ZERO TO TR-NEW-BALANCE
                 MOVE CLOSE-TRANS-DESC TO TR-DESCRIPTION
                 WRITE TRANSACTIONS-RECORD
                 CLOSE TRANSACTIONS-FILE
                 DISPLAY "ACCOUNT CLOSED."
              END-IF
           ELSE
              MOVE "rm -f data/accounts.tmp" TO SYSTEM-COMMAND
              CALL "SYSTEM" USING SYSTEM-COMMAND
              DISPLAY "ACCOUNT NOT FOUND."
           END-IF

           STOP RUN.

       PROCESS-ACCOUNT.
           IF AI-ACCOUNT-ID = TARGET-ID
              MOVE "Y" TO FOUND-FLAG
              MOVE AI-ACCOUNT-ID TO ACCOUNT-ID
              MOVE AI-USER-ID TO USER-ID

              IF AI-STATUS NOT = "OPEN" AND AI-STATUS NOT = "CLOSED"
                 MOVE "Y" TO INVALID-ENTRY-FLAG
                 MOVE ACCOUNTS-IN-RECORD TO ACCOUNTS-OUT-RECORD
                 WRITE ACCOUNTS-OUT-RECORD
                 EXIT PARAGRAPH
              END-IF

              IF AI-TYPE NOT = "CHECKING" AND AI-TYPE NOT = "SAVINGS"
                 MOVE "Y" TO INVALID-ENTRY-FLAG
                 MOVE ACCOUNTS-IN-RECORD TO ACCOUNTS-OUT-RECORD
                 WRITE ACCOUNTS-OUT-RECORD
                 EXIT PARAGRAPH
              END-IF

              IF AI-STATUS = "CLOSED"
                 MOVE "Y" TO ALREADY-CLOSED-FLAG
                 MOVE ACCOUNTS-IN-RECORD TO ACCOUNTS-OUT-RECORD
                 WRITE ACCOUNTS-OUT-RECORD
                 EXIT PARAGRAPH
              END-IF

              MOVE AI-BALANCE TO BALANCE-NUM
              IF BALANCE-NUM NOT = 0
                 MOVE "Y" TO NOT-ZERO-FLAG
                 MOVE ACCOUNTS-IN-RECORD TO ACCOUNTS-OUT-RECORD
                 WRITE ACCOUNTS-OUT-RECORD
              ELSE
                 MOVE BALANCE-NUM TO BALANCE-OUT
                 MOVE SPACES TO ACCOUNTS-OUT-RECORD
                 MOVE ACCOUNT-ID TO AO-ACCOUNT-ID
                 MOVE USER-ID TO AO-USER-ID
                 MOVE BALANCE-NUM TO AO-BALANCE
                 MOVE "CLOSED" TO AO-STATUS
                 MOVE AI-TYPE TO AO-TYPE
                 WRITE ACCOUNTS-OUT-RECORD
              END-IF
           ELSE
              MOVE ACCOUNTS-IN-RECORD TO ACCOUNTS-OUT-RECORD
              WRITE ACCOUNTS-OUT-RECORD
           END-IF.
