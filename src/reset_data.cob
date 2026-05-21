       IDENTIFICATION DIVISION.
       PROGRAM-ID. RESET-DATA.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USERS-FILE ASSIGN TO "data/users.dat"
              ORGANIZATION IS LINE SEQUENTIAL.
           SELECT ACCOUNTS-FILE ASSIGN TO "data/accounts.dat"
              ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TRANSACTIONS-FILE ASSIGN TO "data/transactions.dat"
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

       FD TRANSACTIONS-FILE.
       01 TRANSACTIONS-RECORD.
           05 TR-TIMESTAMP    PIC X(15).
           05 TR-ACCOUNT-ID   PIC X(10).
           05 TR-TYPE         PIC X(1).
           05 TR-AMOUNT       PIC 9(9)V99.
           05 TR-NEW-BALANCE  PIC 9(9)V99.
           05 TR-DESCRIPTION  PIC X(40).
           05 TR-PAD          PIC X(12).

       PROCEDURE DIVISION.
       MAIN.
           OPEN OUTPUT USERS-FILE

           MOVE SPACES TO USERS-RECORD
           MOVE "U100"           TO UR-USER-ID
           MOVE "KROOKODILE"     TO UR-NAME
           MOVE "123 FIRST ST"   TO UR-ADDRESS
           MOVE "CHICAGO"        TO UR-CITY
           MOVE "IL"             TO UR-STATE
           MOVE "60601"          TO UR-ZIPCODE
           MOVE "01-01-2000"     TO UR-DOB
           MOVE "123-456-7890"   TO UR-PHONE
           WRITE USERS-RECORD

           MOVE SPACES TO USERS-RECORD
           MOVE "U200"           TO UR-USER-ID
           MOVE "PIPLUP"         TO UR-NAME
           MOVE "456 SECOND DR"  TO UR-ADDRESS
           MOVE "MILWAUKEE"      TO UR-CITY
           MOVE "WI"             TO UR-STATE
           MOVE "53172"          TO UR-ZIPCODE
           MOVE "01-02-1990"     TO UR-DOB
           MOVE "456-789-0123"   TO UR-PHONE
           WRITE USERS-RECORD

           MOVE SPACES TO USERS-RECORD
           MOVE "U300"           TO UR-USER-ID
           MOVE "PSYDUCK"        TO UR-NAME
           MOVE "789 THIRD CT"   TO UR-ADDRESS
           MOVE "ORLANDO"        TO UR-CITY
           MOVE "FL"             TO UR-STATE
           MOVE "32801"          TO UR-ZIPCODE
           MOVE "01-03-1980"     TO UR-DOB
           MOVE "789-012-3456"   TO UR-PHONE
           WRITE USERS-RECORD

           MOVE SPACES TO USERS-RECORD
           MOVE "U400"           TO UR-USER-ID
           MOVE "CHARMANDER"     TO UR-NAME
           MOVE "012 FOURTH AVE" TO UR-ADDRESS
           MOVE "PORTLAND"       TO UR-CITY
           MOVE "OR"             TO UR-STATE
           MOVE "97201"          TO UR-ZIPCODE
           MOVE "01-04-1970"     TO UR-DOB
           MOVE "345-678-9012"   TO UR-PHONE
           WRITE USERS-RECORD

           MOVE SPACES TO USERS-RECORD
           MOVE "U500"           TO UR-USER-ID
           MOVE "LUCARIO"        TO UR-NAME
           MOVE "345 FIFTH ST"   TO UR-ADDRESS
           MOVE "SAN DIEGO"      TO UR-CITY
           MOVE "CA"             TO UR-STATE
           MOVE "92101"          TO UR-ZIPCODE
           MOVE "01-05-1960"     TO UR-DOB
           MOVE "678-901-2345"   TO UR-PHONE
           WRITE USERS-RECORD

           MOVE SPACES TO USERS-RECORD
           MOVE "U600"           TO UR-USER-ID
           MOVE "MEW"            TO UR-NAME
           MOVE "678 SIXTH DR"   TO UR-ADDRESS
           MOVE "SEATTLE"        TO UR-CITY
           MOVE "WA"             TO UR-STATE
           MOVE "98101"          TO UR-ZIPCODE
           MOVE "01-06-1950"     TO UR-DOB
           MOVE "901-234-5678"   TO UR-PHONE
           WRITE USERS-RECORD

           CLOSE USERS-FILE

           OPEN OUTPUT ACCOUNTS-FILE

           MOVE SPACES TO ACCOUNTS-RECORD
           MOVE "1001"     TO AR-ACCOUNT-ID
           MOVE "U100"     TO AR-USER-ID
           MOVE 1250.00    TO AR-BALANCE
           MOVE "OPEN"     TO AR-STATUS
           MOVE "CHECKING" TO AR-TYPE
           WRITE ACCOUNTS-RECORD

           MOVE SPACES TO ACCOUNTS-RECORD
           MOVE "1002"     TO AR-ACCOUNT-ID
           MOVE "U100"     TO AR-USER-ID
           MOVE 500.00     TO AR-BALANCE
           MOVE "OPEN"     TO AR-STATUS
           MOVE "SAVINGS"  TO AR-TYPE
           WRITE ACCOUNTS-RECORD

           MOVE SPACES TO ACCOUNTS-RECORD
           MOVE "1003"     TO AR-ACCOUNT-ID
           MOVE "U200"     TO AR-USER-ID
           MOVE 5000.00    TO AR-BALANCE
           MOVE "OPEN"     TO AR-STATUS
           MOVE "CHECKING" TO AR-TYPE
           WRITE ACCOUNTS-RECORD

           MOVE SPACES TO ACCOUNTS-RECORD
           MOVE "1004"     TO AR-ACCOUNT-ID
           MOVE "U300"     TO AR-USER-ID
           MOVE 2500.00    TO AR-BALANCE
           MOVE "OPEN"     TO AR-STATUS
           MOVE "SAVINGS"  TO AR-TYPE
           WRITE ACCOUNTS-RECORD

           MOVE SPACES TO ACCOUNTS-RECORD
           MOVE "1005"     TO AR-ACCOUNT-ID
           MOVE "U400"     TO AR-USER-ID
           MOVE 5.00       TO AR-BALANCE
           MOVE "OPEN"     TO AR-STATUS
           MOVE "SAVINGS"  TO AR-TYPE
           WRITE ACCOUNTS-RECORD

           MOVE SPACES TO ACCOUNTS-RECORD
           MOVE "1006"     TO AR-ACCOUNT-ID
           MOVE "U500"     TO AR-USER-ID
           MOVE 10000.00   TO AR-BALANCE
           MOVE "OPEN"     TO AR-STATUS
           MOVE "CHECKING" TO AR-TYPE
           WRITE ACCOUNTS-RECORD

           MOVE SPACES TO ACCOUNTS-RECORD
           MOVE "1007"     TO AR-ACCOUNT-ID
           MOVE "U600"     TO AR-USER-ID
           MOVE 15000.00   TO AR-BALANCE
           MOVE "OPEN"     TO AR-STATUS
           MOVE "CHECKING" TO AR-TYPE
           WRITE ACCOUNTS-RECORD

           CLOSE ACCOUNTS-FILE

           OPEN OUTPUT TRANSACTIONS-FILE

           MOVE SPACES TO TRANSACTIONS-RECORD
           MOVE "20260101-100000" TO TR-TIMESTAMP
           MOVE "1001"            TO TR-ACCOUNT-ID
           MOVE "O"               TO TR-TYPE
           MOVE 1250.00           TO TR-AMOUNT
           MOVE 1250.00           TO TR-NEW-BALANCE
           MOVE "ACCOUNT OPENED - INITIAL DEPOSIT" TO TR-DESCRIPTION
           WRITE TRANSACTIONS-RECORD

           MOVE SPACES TO TRANSACTIONS-RECORD
           MOVE "20260101-110000" TO TR-TIMESTAMP
           MOVE "1002"            TO TR-ACCOUNT-ID
           MOVE "O"               TO TR-TYPE
           MOVE 500.00            TO TR-AMOUNT
           MOVE 500.00            TO TR-NEW-BALANCE
           MOVE "ACCOUNT OPENED - INITIAL DEPOSIT" TO TR-DESCRIPTION
           WRITE TRANSACTIONS-RECORD

           MOVE SPACES TO TRANSACTIONS-RECORD
           MOVE "20260101-120000" TO TR-TIMESTAMP
           MOVE "1003"            TO TR-ACCOUNT-ID
           MOVE "O"               TO TR-TYPE
           MOVE 5000.00           TO TR-AMOUNT
           MOVE 5000.00           TO TR-NEW-BALANCE
           MOVE "ACCOUNT OPENED - INITIAL DEPOSIT" TO TR-DESCRIPTION
           WRITE TRANSACTIONS-RECORD

           MOVE SPACES TO TRANSACTIONS-RECORD
           MOVE "20260101-130000" TO TR-TIMESTAMP
           MOVE "1004"            TO TR-ACCOUNT-ID
           MOVE "O"               TO TR-TYPE
           MOVE 2500.00           TO TR-AMOUNT
           MOVE 2500.00           TO TR-NEW-BALANCE
           MOVE "ACCOUNT OPENED - INITIAL DEPOSIT" TO TR-DESCRIPTION
           WRITE TRANSACTIONS-RECORD

           MOVE SPACES TO TRANSACTIONS-RECORD
           MOVE "20260101-140000" TO TR-TIMESTAMP
           MOVE "1005"            TO TR-ACCOUNT-ID
           MOVE "O"               TO TR-TYPE
           MOVE 5.00              TO TR-AMOUNT
           MOVE 5.00              TO TR-NEW-BALANCE
           MOVE "ACCOUNT OPENED - INITIAL DEPOSIT" TO TR-DESCRIPTION
           WRITE TRANSACTIONS-RECORD

           MOVE SPACES TO TRANSACTIONS-RECORD
           MOVE "20260101-150000" TO TR-TIMESTAMP
           MOVE "1006"            TO TR-ACCOUNT-ID
           MOVE "O"               TO TR-TYPE
           MOVE 10000.00          TO TR-AMOUNT
           MOVE 10000.00          TO TR-NEW-BALANCE
           MOVE "ACCOUNT OPENED - INITIAL DEPOSIT" TO TR-DESCRIPTION
           WRITE TRANSACTIONS-RECORD

           MOVE SPACES TO TRANSACTIONS-RECORD
           MOVE "20260101-160000" TO TR-TIMESTAMP
           MOVE "1007"            TO TR-ACCOUNT-ID
           MOVE "O"               TO TR-TYPE
           MOVE 15000.00          TO TR-AMOUNT
           MOVE 15000.00          TO TR-NEW-BALANCE
           MOVE "ACCOUNT OPENED - INITIAL DEPOSIT" TO TR-DESCRIPTION
           WRITE TRANSACTIONS-RECORD

           CLOSE TRANSACTIONS-FILE

           DISPLAY "RESET SAMPLE DATA."
           STOP RUN.
