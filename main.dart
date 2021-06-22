// TYPE NAME(PARAMS){}

void main(){
  var minhaClasse = MinhaClasse();
  printHelloWorld(message: minhaClasse.message);
}

void printHelloWorld({ required String message }) {
  print(message.replaceAll("DEU", "NÃO DEU"));
}

// class NomeDaFuncao{}
class MinhaClasse {
  var message = "DEU CERTO!";
}