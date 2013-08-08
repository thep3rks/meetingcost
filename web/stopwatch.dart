import 'dart:async';

Stopwatch myWatch ;

class TimerControl
{

  void startwatch( )
  {
    myWatch.start();
    var oneSecond = new Duration( milliseconds:1000 );
    new Timer.periodic( oneSecond, updateCost);

    startButton.disabled = true;
    stopButton.disabled = false;
    resetButton.disabled = true;
  }

  void stopwatch()
  {
    myWatch.stop();
    startButton.disabled = false;
    resetButton.disabled = false;
    stopButton.disabled = true;
  }

  void resetwatch()
  {
    myWatch.reset();
    totalCost = '£0';
    resetButton.disabled = true;
  }
}