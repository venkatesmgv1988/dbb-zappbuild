      ******************************************************************00010001
      * Module Name        STAFF                                       *00012002
      * Version            1.0                                         *00013001
      * Date               13/06/2022                                  *00014001
      *                                                                *00015001
      * COBOL DB2 Program                                              *00016001
      *                                                                *00017001
      * This program gets the Staff Information from DB2 Table         *00018001
      ******************************************************************00019101
       IDENTIFICATION DIVISION.                                         00019202
       PROGRAM-ID. STAFF.                                               00019302
                                                                        00019402
       ENVIRONMENT DIVISION.                                            00019502
       CONFIGURATION SECTION.                                           00019602
       DATA DIVISION.                                                   00019702
       WORKING-STORAGE SECTION.                                         00019802

       EXEC SQL                                                         00019902
          INCLUDE SQLCA
           END-EXEC.

       EXEC SQL                                                         00019902
           INCLUDE STAFF
           END-EXEC.

      *  Input Data                                                     00020002
       01 STAFF-INP-RECORD.                                             00020102
         05 STAFF-ID-I       PIC S9(04) COMP.                           00020202
                                                                        00020402
       EXEC SQL BEGIN DECLARE SECTION
       END-EXEC.

      *  Output data                                                    00020502
       01 STAFF-OUT-RECORD.                                             00020602
         05 STAFF-ID-O       PIC S9(04) COMP.                           00020702
         05 STAFF-NAME-O     PIC X(09).                                 00020802
         05 STAFF-DEPT-O     PIC S9(04) COMP.                           00020802
         05 STAFF-JOB-O      PIC X(05).                                 00020802
         05 STAFF-YEARS-O    PIC S9(04) COMP.                           00020802
         05 STAFF-SALARY-O   PIC S9(7)V(2).                             00020802
         05 STAFF-ERROR-O    PIC S9(9) COMP.
                                                                        00020802
       EXEC SQL END DECLARE SECTION
       END-EXEC.
                                                                        00110002
      *  Data fields used by the program                                00120002
      *01 WORK-STORAGE.                                                 00130003
      *  05 INPUTLENGTH      PIC S9(8) COMP-4.                          00131002
      *  05 DATALENGTH       PIC S9(8) COMP-4.                          00140002
                                                                        00310002
       PROCEDURE DIVISION.                                              00320002
      *  -----------------------------------------------------------    00330002
       MAIN-PROCESSING SECTION.                                         00340002
      *  -----------------------------------------------------------    00350002
                                                                        00360002
           MOVE STAFF-ID-I OF STAFF-INP-RECORD TO STAFF-ID-O OF
                            STAFF-OUT-RECORD.

      *  Fetch details from DB2 Table                                   00370002
           EXEC SQL                                                     00380002
              SELECT NAME, DEPT, JOB, YEARS, SALARY                     00390002
              INTO :STAFF-NAME-O, :STAFF-DEPT-O, :STAFF-JOB-O,          00400002
              :STAFF-YEARS-O, :STAFF-SALARY-O FROM STAFF                00400002
              WHERE ID =:STAFF_ID-O                                     00400002

           MOVE SQLCODE TO STAFF-ERROR-O.                               00440002

      *  Populate Error Code if no matching criteria                    00410002
      *    IF SQLCODE NOT = 0                                           00420002
      *       MOVE SQLCODE TO STAFF-ERROR-O                             00440002
      *    END-IF.                                                      00450002

      *  Finish                                                         01200002
           STOP RUN.                                                    00420002