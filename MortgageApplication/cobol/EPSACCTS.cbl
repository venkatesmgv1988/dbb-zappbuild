       ID DIVISION.
       PROGRAM-ID. EPSACCTS.
      *    THIS PROGRAM WILL READ THE ACCOUNT AND CUSTOMER DB TO
      *    GENERATE FILE OUTPUT WITH CICS SCREEN DATA
      *
      *    AUTHOR - ARUNKUMAR KOWALPADOLI & AJAY CHINCHANSUR
      *    DATE - 05/06/2022
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. IBM-FLEX-ES.
       OBJECT-COMPUTER. IBM-FLEX-ES.

       INPUT-OUTPUT SECTION.
       FILE-CONTROL.

       SELECT ACCT-RESULT-FILE ASSIGN TO RSTFILE
       ORGANIZATION IS SEQUENTIAL
       FILE STATUS IS WS-RSTFILE-STATUS.

       DATA DIVISION.

       FILE SECTION.

       FD RSTFILE
       BLOCK CONTAINS 0 RECORDS
       RECORDING MODE IS F
       BLOCK CONTAINS 0 RECORDS.

       01 RSTFILE-REC      PIC X(300).

       WORKING-STORAGE SECTION.
      *
       01  W-FLAGS.
           10  W-SEND-FLAG                    PIC X.
               88  SEND-ERASE                   VALUE '1'.
               88  SEND-DATAONLY                VALUE '2'.
               88  SEND-MAPONLY                 VALUE '3'.
               88  SEND-DATAONLY-ALARM          VALUE '4'.
               88  SEND-ALL                     VALUE '5'.

       01 W-CALL-PROGRAM                      PIC X(8).

       01 WS-WORK-FIELDS.
           05 WS-SQLCODE           PIC 9(08) VALUE 0.
           05 WS-CURRENT-DATETIME  PIC X(26) VALUE SPACES.

       01 WS-RSTFILE-RECORD.
           05  OP-CUST-ACCT         PIC X(10).
           05  OP-ACCT-TYP          PIC X(20).
           05  OP-ACCT-STA          PIC X(10).
           05  OP-ACCT-OPEN-DT      PIC X(10).
           05  OP-ACCT-CLOS-DT      PIC X(10).
           05  OP-ACCT-LST-ACTV-DT  PIC X(10).
           05  OP-CUST-ID           PIC X(10).
           05  OP-CUST-FNAME        PIC X(20).
           05  OP-CUST-LNAME        PIC X(20).
           05  OP-CUST-DOB          PIC X(10).
           05  OP-CUST-GENDER       PIC X(01).
           05  OP-CUST-ADR1         PIC X(50).
           05  OP-CUST-ADR2         PIC X(50).
           05  OP-CUST-CITY         PIC X(20).
           05  OP-CUST-STATE        PIC X(02).
           05  OP-CUST-ZIP          PIC X(10).
           05  OP-CUST-CNTRY        PIC X(20).
           05  OP-FILLER            PIC X(17).


       *-----------------------------------*
       *  DB2 COMMUNICATION AREA           *
       *-----------------------------------*

       EXEC SQL
         INCLUDE SQLCA
       END-EXEC.

       LINKAGE SECTION.

       01 WS-IN-ACCT-DATA.
          05 WS-IN-ACCT       PIC X(10).


       PROCEDURE DIVISION USING WS-IN-ACCT-DATA.

       0000-MAINLINE.

       DISPLAY '*******************'
       DISPLAY '   PROGRAM START   '
       DISPLAY '*******************'

       PERFORM 1000-INITIALIZATION
       THRU 1000-EXIT

       PERFORM A100-PROCESS-ACCT
       THRU A100-EXIT

       PERFORM 9000-TERMINATE
       THRU 9000-EXIT
       GOBACK
       .

       1000-INITIALIZATION.

       INITIALIZE WS-WORK-FIELDS

       EXEC SQL
           SET :WS-CURRENT-DATETIME = CURRENT TIMESTAMP
       END-EXEC

       EVALUATE SQLCODE
           WHEN +0
                DISPLAY '**************************************'
                DISPLAY 'CURRENT DATETIME: ' WS-CURRENT-DATETIME
                DISPLAY '**************************************'
           WHEN OTHER
                DISPLAY '**************************************'
                DISPLAY 'PROGRAM FAILED -' WS-CURRENT-DATETIME
                DISPLAY '**************************************'
                MOVE SQLCODE TO WS-SQLCODE
                DISPLAY 'SQLCODE: ' WS-SQLCODE
        END-EVALUATE

        OPEN OUTPUT RSTFILE

        EVALUATE WS-RSTFILE-STATUS
           WHEN 00
                CONTINUE
           WHEN OTHER
                DISPLAY 'OPEN OUTPUT FILE FAILED: '
                        WS-RSTFILE-STATUS
                MOVE SQLCODE TO WS-SQLCODE
                DISPLAY 'SQLCODE: ' WS-SQLCODE
        END-EVALUATE.

       1000-EXIT.
       EXIT.


       A100-PROCESS-ACCT.

       DISPLAY 'PROGRAM STARTED '

         EXEC SQL
              SELECT
                       ACC.CUST_ACCT
                      ,ACC.ACCT_TYP
                      ,ACC.ACCT_STA
                      ,ACC.ACCT_OPEN_DT
                      ,ACC.ACCT_CLOS_DT
                      ,ACC.ACCT_LST_ACTV_DT
                      ,CUS.CUST_ID
                      ,CUS.CUST_FNAME
                      ,CUS.CUST_LNAME
                      ,CUS.CUST_DOB
                      ,CUS.CUST_GENDER
                      ,CUS.CUST_ADR1
                      ,CUS.CUST_ADR2
                      ,CUS.CUST_CITY
                      ,CUS.CUST_STATE
                      ,CUS.CUST_ZIP
                      ,CUS.CUST_CNTRY
                 INTO :OP-CUST-ACCT
                      ,OP-ACCT-TYP
                      ,OP-ACCT-STA
                      ,OP-ACCT-OPEN-DT
                      ,OP-ACCT-CLOS-DT
                      ,OP-ACCT-LST-ACTV-DT
                      ,OP-CUST-ID
                      ,OP-CUST-FNAME
                      ,OP-CUST-LNAME
                      ,OP-CUST-DOB
                      ,OP-CUST-GENDER
                      ,OP-CUST-ADR1
                      ,OP-CUST-ADR2
                      ,OP-CUST-CITY
                      ,OP-CUST-STATE
                      ,OP-CUST-ZIP
                      ,OP-CUST-CNTRY
              FROM CUST_ACCOUN1 ACC,
                   CUSTOMER1 CUS,
                   CUST_LINK1 XREF
              WHERE XREF.CUST_ACCT = ACC.CUST_ACCT
               AND  XREF.CUST_ID = CUS.CUST_ID
               AND  ACC.CUST_ACCT = :WS-IN-ACCT
         END-EXEC

         IF SQLCODE = 0

              DISPLAY ' SQL EXECUTED SUCESSFULLY '
              DISPLAY ' CUSTOMER ACCOUNT IS       ' WS-IN-ACCT

              MOVE WS-RSTFILE-RECORD TO RSTFILE-REC
              WRITE RSTFILE-REC

         ELSE

              DISPLAY ' SQL FAILED '
              DISPLAY  ' SQL CODE   '  SQLCODE

         END-IF

         DISPLAY ' PROGRAM ENDED'.

        A100-EXIT.
        EXIT.

        9000-TERMINATE.

                DISPLAY '**************************************'
                DISPLAY 'PROGRAM TERMINATING'
                DISPLAY '**************************************'

         CLOSE RSTFILE

         EVALUATE WS-RSTFILE-STATUS
           WHEN 00
                CONTINUE
           WHEN OTHER
                DISPLAY 'CLOSE OUTPUT FILE FAILED: '
                        WS-RSTFILE-STATUS
                MOVE SQLCODE TO WS-SQLCODE
                DISPLAY 'SQLCODE: ' WS-SQLCODE
        END-EVALUATE.

       9000-EXIT.
       EXIT.
