import 'dart:html';

class Person
{
  String title ;
  int chargeoutCost ;
  LIElement personElement ;

  Person( this.title, this.chargeoutCost )
  {
    this.personElement = new LIElement();
    this.personElement.text = this.title ;
  }
}