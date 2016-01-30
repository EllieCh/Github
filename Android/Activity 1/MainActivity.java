package com.rayssolartechnologies.tipcalc;

/*
 * Gayathri N Kannepalli
 * This activity class represents the event handling and state
 * of our first Number Guessing Game app.
 */

import android.app.*;
import android.support.v7.app.*;
import android.os.*;
import android.view.*;
import android.widget.*;
import java.util.*;

public class MainActivity extends Activity {
    private int num1;    // the numbers on the left and right buttons
    private int num2;
    private int points;  // player's point total; initially 0

    /*
     * Called when the player clicks the left number button.
     */
    public void clickButton1(View view) {
        check(num1, num2);
    }

    /*
     * Called when the player clicks the right number button.
     */
    public void clickButton2(View view) {
        check(num2, num1);
    }

    /*
     * Updates the player's score based on whether they guessed correctly.
     * Also shows a 'toast' which is a brief popup message.
     */
    private void check(int a, int b) {
        if (a > b) {
            points++;
            Toast.makeText(this, "Correct!", Toast.LENGTH_SHORT).show();
        } else {
            points--;
            Toast.makeText(this, "You are a STUPID.", Toast.LENGTH_SHORT).show();
        }

        TextView pointsView = (TextView) findViewById(R.id.pointsTextView);
        pointsView.setText("Points: " + points);
        roll();
    }

    /*
     * Chooses new random integers to appear on the two buttons.
     */
    private void roll() {
        // pick two random numbers
        Random r = new Random();
        num1 = r.nextInt(9);
        num2 = r.nextInt(9);
        while (num2 == num1) {
            num2 = r.nextInt(9);
        }

        // set the buttons to display the random numbers
        Button left = (Button) findViewById(R.id.buttonLeft);
        left.setText("" + num1);     // "" + int -> converts int to String

        Button right = (Button) findViewById(R.id.buttonRight);
        right.setText("" + num2);
    }


    /*************************************************************************
     * BELOW THIS POINT IS CODE THAT WAS GENERATED BY ANDROID STUDIO THAT WE *
     * DID NOT MODIFY, EXCEPT FOR ONE LINE THAT IS MARKED BELOW.             *
     *************************************************************************/

    /*
     * This method is called by Android when our activity is first created.
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        roll();   // <-- we added this line to set initial button random numbers
    }
}