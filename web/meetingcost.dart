import 'dart:html';
import 'dart:async';
import 'dart:math';
import 'package:web_ui/web_ui.dart';

@observable String totalCost = '£0';
@observable String costPerHour = '£0';

double hoursPerDay = 7.5 ;
int secondsPerHour = 3600;

Stopwatch myWatch ;
ButtonElement stopButton;
ButtonElement startButton;
ButtonElement resetButton;
ButtonElement deleteAll;
InputElement toDoInput;
UListElement toDoList;
List people ;
double costPerSecond ;

void main()
{
  myWatch = new Stopwatch();

  startButton = query("#startbutton");
  startButton.onClick.listen( ( e ) => startwatch( ) ) ;

  stopButton = query("#stopbutton");
  stopButton.onClick.listen( ( e ) => stopwatch( ) ) ;
  stopButton.disabled = true;

  resetButton = query("#resetbutton");
  resetButton.onClick.listen( ( e ) => resetwatch( ) ) ;
  resetButton.disabled = true;

  toDoList = query('#to-do-list');

  toDoInput = query('#to-do-input');
  toDoInput.onChange.listen(addPerson);

  deleteAll = query('#delete-all');
  deleteAll.onClick.listen((e) => removeAllPeople( ) );

  people = [ ] ;
}

// Rate calculator

void addPerson(Event e)
{
  var newPerson = new LIElement();
  newPerson.text = toDoInput.value;
  newPerson.onClick.listen((e) => removePerson( newPerson ) );
  toDoInput.value = '';
  toDoList.children.add( newPerson );

  people.add( newPerson ) ;

  calculateCosts() ;
}

void removePerson( person )
{
  toDoList.children.remove( person ) ;
  people.remove( person ) ;

  calculateCosts() ;
}

void removeAllPeople( )
{
  toDoList.children.clear( ) ;
  people = [ ] ;

  calculateCosts( ) ;
}

void calculateCosts( )
{
  var costPerDay = 0 ;

  for( LIElement person in people )
  {
    costPerDay = costPerDay += int.parse(person.text) ;
  }

  print( "costPerDay: $costPerDay" ) ;

  var cph = (costPerDay / hoursPerDay).round() ;

  costPerHour = "£$cph" ;

  costPerSecond = cph / secondsPerHour ;

  print( "costPerSecond is $costPerSecond" ) ;
}

// Stopwatch stuff

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

void updateCost(Timer _)
{
  var s = myWatch.elapsedMilliseconds~/1000 ;

  double costSoFar = ( ( costPerSecond * s) * 100 ).round() / 100 ;

  totalCost = "£$costSoFar" ;
}
