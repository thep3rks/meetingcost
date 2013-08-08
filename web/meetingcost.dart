import 'dart:html';
import 'dart:async';
import 'dart:math';
import 'package:web_ui/web_ui.dart';

@observable String totalCost = '£0';
@observable String costPerHour = '£0';

double hoursPerDay = 7.5 ;
int secondsPerHour = 3600;

Stopwatch myWatch ;
ButtonElement addButton;
ButtonElement stopButton;
ButtonElement startButton;
ButtonElement resetButton;
ButtonElement deleteAll;
UListElement attendees;
List people ;
double costPerSecond ;
SelectElement rolesSelect ;

List roles = [ ] ;

class Person
{
  String title ;
  int chargeoutCost ;
  LIElement personElement ;

  Person( this.title, this.chargeoutCost )
  {
    this.personElement = new LIElement();
    this.personElement.text = rolesSelect.selectedOptions[0].text;
  }
}

void main()
{
  myWatch = new Stopwatch();

  addButton = query("#addbutton");
  addButton.onClick.listen( ( e ) => addPerson( ) ) ;

  startButton = query("#startbutton");
  startButton.onClick.listen( ( e ) => startwatch( ) ) ;

  stopButton = query("#stopbutton");
  stopButton.onClick.listen( ( e ) => stopwatch( ) ) ;
  stopButton.disabled = true;

  resetButton = query("#resetbutton");
  resetButton.onClick.listen( ( e ) => resetwatch( ) ) ;
  resetButton.disabled = true;

  attendees = query('#attendees');

  deleteAll = query('#delete-all');
  deleteAll.onClick.listen((e) => removeAllPeople( ) );

  rolesSelect = query("#roles-list");

  //createRolesList( ) ;

  people = [ ] ;
}

/*
void createRolesList( )
{
  Person cd = new Person( "Creative Director", 1500 ) ;
  roles.add( cd ) ;

  cd = new Person( "Account Director", 1000 ) ;
  roles.add( cd ) ;

  cd = new Person( "Planning Director", 1500 ) ;
  roles.add( cd ) ;

  rolesSelect = new SelectElement( ) ;

  var options = [ ] ;

  for( var i = 0; i < roles.length; i++)
  {
    Person role = roles[ i ] ;

    OptionElement test = new OptionElement() ;
    test.value = role.title ;
    test.text = role.title ;

    options.add( test ) ;
  }

  rolesSelect.options.addAll( options ) ;

  DivElement rolesList = query('#roles-list') ;
  rolesList.children.add( rolesSelect ) ;
}
*/

// Rate calculator

void addPerson( )
{
  if( people == null ) people = [ ] ;

  Person p = new Person( rolesSelect.selectedOptions[0].text, int.parse(rolesSelect.selectedOptions[0].value) ) ;

  people.add( p ) ;
  attendees.children.add( p.personElement );
  p.personElement.onClick.listen((e) => removePerson( p ) );

  calculateCosts() ;
}

void removePerson( Person person )
{
  attendees.children.remove( person.personElement ) ;
  people.remove( person ) ;

  calculateCosts() ;
}

void removeAllPeople( )
{
  attendees.children.clear( ) ;
  people = [ ] ;

  calculateCosts( ) ;
}

void calculateCosts( )
{
  var costPerDay = 0 ;

  for( Person person in people )
  {
    costPerDay = costPerDay += person.chargeoutCost ;
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