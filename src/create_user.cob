       IDENTIFICATION DIVISION.
       PROGRAM-ID. CREATE-USER.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT USERS-IN ASSIGN TO "data/users.dat"
              ORGANIZATION IS LINE SEQUENTIAL.
           SELECT USERS-OUT ASSIGN TO "data/users.tmp"
              ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD USERS-IN.
       01 USERS-IN-RECORD.
           05 UI-USER-ID    PIC X(10).
           05 UI-NAME       PIC X(40).
           05 UI-ADDRESS    PIC X(80).
           05 UI-CITY       PIC X(40).
           05 UI-STATE      PIC X(2).
           05 UI-ZIPCODE    PIC X(5).
           05 UI-DOB        PIC X(10).
           05 UI-PHONE      PIC X(12).
           05 UI-PAD        PIC X(1).

       FD USERS-OUT.
       01 USERS-OUT-RECORD.
           05 UO-USER-ID    PIC X(10).
           05 UO-NAME       PIC X(40).
           05 UO-ADDRESS    PIC X(80).
           05 UO-CITY       PIC X(40).
           05 UO-STATE      PIC X(2).
           05 UO-ZIPCODE    PIC X(5).
           05 UO-DOB        PIC X(10).
           05 UO-PHONE      PIC X(12).
           05 UO-PAD        PIC X(1).

       WORKING-STORAGE SECTION.
       01 CONTROL-FLAGS.
           05 USERS-EOF-FLAG PIC X VALUE "N".
           05 USER-EXISTS-FLAG PIC X VALUE "N".

       01 INPUT-FIELDS.
           05 NEW-USER-ID PIC X(10).
           05 NEW-USER-NAME PIC X(40).
           05 NEW-USER-ADDRESS PIC X(80).
           05 NEW-USER-CITY PIC X(40).
           05 NEW-USER-STATE-ENTRY PIC X(20).
           05 NEW-USER-STATE PIC X(2).
           05 NEW-USER-ZIPCODE PIC X(5).
           05 NEW-USER-ZIPCODE-ENTRY PIC X(20).
           05 NEW-USER-DOB PIC X(10).
           05 NEW-USER-DOB-ENTRY PIC X(20).
           05 NEW-USER-PHONE PIC X(12).
           05 NEW-USER-PHONE-ENTRY PIC X(20).

       01 RECORD-FIELDS.
           05 USER-ID PIC X(10).

       01 SYSTEM-FIELDS.
           05 SYSTEM-COMMAND PIC X(200).

       PROCEDURE DIVISION.
       MAIN.
           DISPLAY "CREATE USER"
           DISPLAY "-----------"
           DISPLAY SPACE
           DISPLAY "USER INFORMATION"
           DISPLAY "----------------"
           DISPLAY "ID: " WITH NO ADVANCING
           ACCEPT NEW-USER-ID
           MOVE FUNCTION TRIM(NEW-USER-ID) TO NEW-USER-ID

           IF NEW-USER-ID = SPACES
              DISPLAY "ID IS REQUIRED."
              STOP RUN
           END-IF

           IF NEW-USER-ID(1:1) NOT = "U"
              DISPLAY "ID MUST START WITH U (EX: U100)."
              STOP RUN
           END-IF

           IF NEW-USER-ID(2:1) = SPACE
              DISPLAY "ID MUST BE AT LEAST 2 CHARACTERS."
              STOP RUN
           END-IF

           DISPLAY "NAME: " WITH NO ADVANCING
           ACCEPT NEW-USER-NAME
           MOVE FUNCTION TRIM(NEW-USER-NAME) TO NEW-USER-NAME

           IF NEW-USER-NAME = SPACES
              DISPLAY "NAME IS REQUIRED."
              STOP RUN
           END-IF

           IF NEW-USER-NAME IS NOT ALPHABETIC
              DISPLAY "NAME CANNOT HAVE NUMBERS."
              STOP RUN
           END-IF

           DISPLAY "ADDRESS: " WITH NO ADVANCING
           ACCEPT NEW-USER-ADDRESS
           MOVE FUNCTION TRIM(NEW-USER-ADDRESS) TO NEW-USER-ADDRESS

           IF NEW-USER-ADDRESS = SPACES
              DISPLAY "ADDRESS IS REQUIRED."
              STOP RUN
           END-IF

           IF FUNCTION TEST-NUMVAL(NEW-USER-ADDRESS) = 0
              DISPLAY "ADDRESS CANNOT BE ONLY NUMBERS."
              STOP RUN
           END-IF

           DISPLAY "CITY: " WITH NO ADVANCING
           ACCEPT NEW-USER-CITY
           MOVE FUNCTION TRIM(NEW-USER-CITY) TO NEW-USER-CITY

           IF NEW-USER-CITY = SPACES
              DISPLAY "CITY IS REQUIRED."
              STOP RUN
           END-IF

           IF NEW-USER-CITY IS NOT ALPHABETIC
              DISPLAY "CITY CANNOT HAVE NUMBERS."
              STOP RUN
           END-IF

           DISPLAY "STATE: " WITH NO ADVANCING
           ACCEPT NEW-USER-STATE-ENTRY
           MOVE FUNCTION TRIM(NEW-USER-STATE-ENTRY) 
              TO NEW-USER-STATE-ENTRY

           IF NEW-USER-STATE-ENTRY = SPACES
              DISPLAY "STATE IS REQUIRED."
              STOP RUN
           END-IF

           IF NEW-USER-STATE-ENTRY(1:2) IS NOT ALPHABETIC
              DISPLAY "STATE CANNOT HAVE NUMBERS."
              STOP RUN
           END-IF

           IF NEW-USER-STATE-ENTRY(2:1) = SPACE
              OR NEW-USER-STATE-ENTRY(3:1) NOT = SPACE
              DISPLAY "STATE MUST BE EXACTLY 2 CHARACTERS."
              STOP RUN
           END-IF

           MOVE NEW-USER-STATE-ENTRY(1:2) TO NEW-USER-STATE

           DISPLAY "ZIPCODE: " WITH NO ADVANCING
           ACCEPT NEW-USER-ZIPCODE-ENTRY
           MOVE FUNCTION TRIM(NEW-USER-ZIPCODE-ENTRY)
              TO NEW-USER-ZIPCODE-ENTRY

           IF NEW-USER-ZIPCODE-ENTRY = SPACES
              DISPLAY "ZIPCODE IS REQUIRED."
              STOP RUN
           END-IF

           IF NEW-USER-ZIPCODE-ENTRY(5:1) = SPACE
              OR NEW-USER-ZIPCODE-ENTRY(6:1) NOT = SPACE
              DISPLAY "ZIPCODE MUST BE EXACTLY 5 DIGITS."
              STOP RUN
           END-IF

           IF NEW-USER-ZIPCODE-ENTRY(1:5) IS NOT NUMERIC
              DISPLAY "ZIPCODE CAN BE ONLY NUMBERS."
              STOP RUN
           END-IF

           MOVE NEW-USER-ZIPCODE-ENTRY(1:5) TO NEW-USER-ZIPCODE

           DISPLAY "DOB (MM-DD-YYYY): " WITH NO ADVANCING
           ACCEPT NEW-USER-DOB-ENTRY
           MOVE FUNCTION TRIM(NEW-USER-DOB-ENTRY)
              TO NEW-USER-DOB-ENTRY

           IF NEW-USER-DOB-ENTRY = SPACES
              DISPLAY "DATE OF BIRTH IS REQUIRED."
              STOP RUN
           END-IF

           IF NEW-USER-DOB-ENTRY(10:1) = SPACE
              OR NEW-USER-DOB-ENTRY(11:1) NOT = SPACE
              DISPLAY "DATE OF BIRTH MUST BE MM-DD-YYYY."
              STOP RUN
           END-IF

           IF NEW-USER-DOB-ENTRY(3:1) NOT = "-"
              OR NEW-USER-DOB-ENTRY(6:1) NOT = "-"
              DISPLAY "DATE OF BIRTH MUST BE MM-DD-YYYY."
              STOP RUN
           END-IF

           IF NEW-USER-DOB-ENTRY(1:2) IS NOT NUMERIC
              OR NEW-USER-DOB-ENTRY(4:2) IS NOT NUMERIC
              OR NEW-USER-DOB-ENTRY(7:4) IS NOT NUMERIC
              DISPLAY "DATE OF BIRTH MUST BE MM-DD-YYYY."
              STOP RUN
           END-IF

           MOVE NEW-USER-DOB-ENTRY(1:10) TO NEW-USER-DOB

           DISPLAY "PHONE NUMBER (XXX-XXX-XXXX): " WITH NO ADVANCING
           ACCEPT NEW-USER-PHONE-ENTRY
           MOVE FUNCTION TRIM(NEW-USER-PHONE-ENTRY)
              TO NEW-USER-PHONE-ENTRY

           IF NEW-USER-PHONE-ENTRY = SPACES
              DISPLAY "PHONE NUMBER IS REQUIRED."
              STOP RUN
           END-IF

           IF NEW-USER-PHONE-ENTRY(12:1) = SPACE
              OR NEW-USER-PHONE-ENTRY(13:1) NOT = SPACE
              DISPLAY "PHONE NUMBER MUST BE XXX-XXX-XXXX."
              STOP RUN
           END-IF

           IF NEW-USER-PHONE-ENTRY(4:1) NOT = "-"
              OR NEW-USER-PHONE-ENTRY(8:1) NOT = "-"
              DISPLAY "PHONE NUMBER MUST BE XXX-XXX-XXXX."
              STOP RUN
           END-IF

           IF NEW-USER-PHONE-ENTRY(1:3) IS NOT NUMERIC
              OR NEW-USER-PHONE-ENTRY(5:3) IS NOT NUMERIC
              OR NEW-USER-PHONE-ENTRY(9:4) IS NOT NUMERIC
              DISPLAY "PHONE NUMBER MUST BE XXX-XXX-XXXX."
              STOP RUN
           END-IF

           MOVE NEW-USER-PHONE-ENTRY(1:12) TO NEW-USER-PHONE

           PERFORM CREATE-USER-RECORD

           IF USER-EXISTS-FLAG = "Y"
              DISPLAY "USER ID ALREADY EXISTS."
           ELSE
              DISPLAY "USER CREATED."
           END-IF
           STOP RUN.

       CREATE-USER-RECORD.
           MOVE "N" TO USERS-EOF-FLAG USER-EXISTS-FLAG
           OPEN INPUT USERS-IN
           OPEN OUTPUT USERS-OUT

           PERFORM UNTIL USERS-EOF-FLAG = "Y"
           READ USERS-IN
           AT END
              MOVE "Y" TO USERS-EOF-FLAG
           NOT AT END
              IF UI-USER-ID = NEW-USER-ID
                 MOVE "Y" TO USER-EXISTS-FLAG
              END-IF
              MOVE USERS-IN-RECORD TO USERS-OUT-RECORD
              WRITE USERS-OUT-RECORD
           END-READ
           END-PERFORM

           IF USER-EXISTS-FLAG NOT = "Y"
              PERFORM BUILD-USER-OUT-RECORD
              WRITE USERS-OUT-RECORD
           END-IF

           CLOSE USERS-IN
           CLOSE USERS-OUT

           MOVE "mv -f data/users.tmp data/users.dat" TO SYSTEM-COMMAND
           CALL "SYSTEM" USING SYSTEM-COMMAND.

       BUILD-USER-OUT-RECORD.
           MOVE SPACES TO USERS-OUT-RECORD
           MOVE NEW-USER-ID      TO UO-USER-ID
           MOVE NEW-USER-NAME    TO UO-NAME
           MOVE NEW-USER-ADDRESS TO UO-ADDRESS
           MOVE NEW-USER-CITY    TO UO-CITY
           MOVE NEW-USER-STATE   TO UO-STATE
           MOVE NEW-USER-ZIPCODE TO UO-ZIPCODE
           MOVE NEW-USER-DOB     TO UO-DOB
           MOVE NEW-USER-PHONE   TO UO-PHONE.
