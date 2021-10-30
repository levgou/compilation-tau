
import java.io.*;
import java.io.PrintWriter;

import java_cup.runtime.Symbol;

public class Main {
    static public void main(String argv[]) {
        Lexer l;
        Symbol s;
        FileReader file_reader;
        PrintWriter file_writer = null;
        String inputFilename = argv[0];
        String outputFilename = argv[1];

        try {
            /********************************/
            /* [1] Initialize a file reader */
            /********************************/
            file_reader = new FileReader(inputFilename);

            /********************************/
            /* [2] Initialize a file writer */
            /********************************/
            file_writer = new PrintWriter(outputFilename);

            /******************************/
            /* [3] Initialize a new lexer */
            /******************************/
            l = new Lexer(file_reader);

            /***********************/
            /* [4] Read next token */
            /***********************/
            s = l.next_token();

            /********************************/
            /* [5] Main reading tokens loop */
            /********************************/
            while (s.sym != TokenNames.EOF) {
                Token token = new Token(s.value, s.sym, l.getLine(), l.getTokenStartPosition());
                /************************/
                /* [6] Print to console */
                /************************/
                System.out.println(token);

                /*********************/
                /* [7] Print to file */
                /*********************/
                file_writer.println(token);

                /***********************/
                /* [8] Read next token */
                /***********************/
                s = l.next_token();
            }

            /******************************/
            /* [9] Close lexer input file */
            /******************************/
            l.yyclose();

            /**************************/
            /* [10] Close output file */
            /**************************/
            file_writer.close();
        } catch (Exception e) {
            if (file_writer != null) {
                file_writer.close();
            }
            e.printStackTrace();
        }
    }
}


