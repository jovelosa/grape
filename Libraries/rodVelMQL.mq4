//+------------------------------------------------------------------+
//|                                                    rodVelMQL.mq4 |
//|                          Copyright 2023, Rodrigo Velosa, Library |
//|                         https://www.instagram.com/rodrigovelosa/ |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright 2023, Rodrigo Velosa, Library"
#property link      "https://www.instagram.com/rodrigovelosa/"
#property version   "1.00"
#property strict

//Input parameters
input int candleNum;             //Posición de la vela

extern int MagicNumber = 9876;   //Número Mágico
extern int Slippage=3;
extern int TakeProfit = 30;
extern int StopLoss = 30;

  long     account = 1234;
  string   symbol = Symbol();
  int      magic = 4321;
  string   key0 = "pSicologico0";
  string   delim = "_";
  string   valuDefaul = "-1";
  string pS0 = "S0", pS1 = "S1", pS2 = "S2", pS3 = "S3", pS4 = "S4";
  string gMaterKey = StringConcatenate(account,delim,symbol,delim,magic);
  int result=0;

//+------------------------------------------------------------------+
//| My function: Devuelve el tipo de vela según su posición          |
//| Date       : 24/07/2022                                          |
//+------------------------------------------------------------------+
 string CandleType(int candleNum) export
   {
    if(Open[candleNum]<Close[candleNum]){
       return "Alcista";
    }else if(Open[candleNum]>Close[candleNum]){
       return "Bajista";    
    }else{
       return "Doji";  
    }
   }
   
//+------------------------------------------------------------------+
//| My function: Devuelve el número total de ordenes                 |
//| Date       : 24/07/2022                                          |
//+------------------------------------------------------------------+  
 int TotalOrdersCount()
   {
     int result=0;
     for(int i=0;i<OrdersTotal();i++)
     {
        OrderSelect(i,SELECT_BY_POS ,MODE_TRADES);
        if (OrderMagicNumber()==MagicNumber) result++;
   
      }
     return (result);
   }
  
void CloseOrder(int ticket)
{
    bool result = OrderClose(ticket, OrderLots(), Bid, 3, Red);

    if (result)
    {
        Print("Orden cerrada con éxito. Ticket: ", ticket);
    }
    else
    {
        Print("Error al cerrar la orden. Código de error: ", GetLastError());
    }
}
//+------------------------------------------------------------------+
//| My function: Devuelve el número total de ordenes                 |
//| Date       : 24/07/2022                                          |
//+------------------------------------------------------------------+

void operation(int range){

  double open = Open[0];
  double close = Close[0];
   
    if(range>0)
         {  
            if (isBullishCandle(open, close)) {
                 // La vela es alcista
                 printf("La vela es alcista!");
                 // Here is your open buy rule
                 result = EjecutarCompra(1);
             
            } else if (isBearishCandle(open, close) ) {
                 // La vela es bajista
                 printf("La vela es bajista ->" );
                 // Here is your open Sell rule
                 
            } else {
                 // La vela es neutra (el precio de apertura y cierre es el mismo)
                 printf("La vela es neutra (el precio de apertura y cierre es el mismo!!");
            }
            
        }
}
//+------------------------------------------------------------------+
//| My function: Realiza una compra                                  |
//| Date       : 28/04/2023                                          |
//+------------------------------------------------------------------+
   int EjecutarCompra(double lotSize){
 
     int ticket =0;
     int order =+ 1;
     //double TheStopLoss=0;
     //double TheTakeProfit=0;
     //double MyPoint=Point;
     //if(Digits==3 || Digits==5) MyPoint=Point*10;
     
     //Obtenemos el precio actual del símbolo
     //double precio = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    
     //Calculamos el tamaño de la orden en función del lotSize
     //double tamanoOrden = NormalizeDouble(lotSize * MarketInfo(_Symbol, MODE_MINLOT), 2);
     
     //Abrimos una orden de compra
     ticket = OrderSend(Symbol(),OP_BUY,lotSize,Ask,Slippage,0,0,"My Order of Grape ->"+order,MagicNumber,0,Blue);
     //ticket  = OrderSend(_Symbol, OP_BUY, tamanoOrden, precio, 3, precio - StopLoss*Point, precio + TakeProfit*Point, "MiOrden", 0, 0, Green);
     
     //Comprobamos si la orden se ha abierto correctamente
     if(ticket > 0){
        printf("Orden de compra abierta con éxito : " + ticket);
        printf("Orden de compra Bid: " + Bid);
        printf("Orden de compra Ask: " + Ask);
        
     }else{
        printf("Error al abrir la orden de compra: ",GetLastError());   
     }
     
     return ticket; 
     
   }
   
//+------------------------------------------------------------------+
//| My function: Realiza el calculo de los precios psicologicos en un rango de 100 pits                                  |
//| Date       : 05/05/2023                                          |
//+------------------------------------------------------------------+
  void pSicologicRange(string option, int digits){
    
     double precioVenta = SymbolInfoDouble(_Symbol, SYMBOL_BID);
     double S0 = 0, S1 = 0, S2 = 0, S3 = 0, S4 = 0;
     double parteDecimal= 0.00;
     
     if(option == 'D')
       {
         string precioStr = DoubleToStr(precioVenta, _Digits);
         string precioSubstr = StringSubstr(precioStr, 0, digits);
         double precioSubstring = StringToDouble(precioSubstr);
         SetGvar(gMaterKey,"precioStr",precioVenta,delim);
         S0 = precioSubstring;
         S1 += precioSubstring + 0.002;
         S2 += precioSubstring + 0.005;
         S3 += precioSubstring + 0.008;
         S4 += precioSubstring + 0.01;
          
       }else if(option == 'Z'){
         SetGvar(gMaterKey,"precioVenta",precioVenta,delim);
         //S0 = (double) NormalizeDouble(precioVenta, 0);
         string precioStr = DoubleToStr(precioVenta, _Digits);
         string precioSubstr = StringSubstr(precioStr, 0, digits);
         double precioSubstring = StringToDouble(precioSubstr);
         S0 = precioSubstring;
         S1 = StringToDouble(DoubleToStr(S0, 0) + "." + DoubleToStr(2, _Digits));
         S2 = StringToDouble(DoubleToStr(S0, 0) + "." + DoubleToStr(5, _Digits));
         S3 = StringToDouble(DoubleToStr(S0, 0) + "." + DoubleToStr(8, _Digits));
         S4 += (double) NormalizeDouble(S0, 0)+1;
       }
     
     string s0Set = SetGvar(gMaterKey,pS0,DoubleToStr(S0,_Digits),delim);
     string s1Set = SetGvar(gMaterKey,pS1,DoubleToStr(S1,_Digits),delim);
     string s2Set = SetGvar(gMaterKey,pS2,DoubleToStr(S2,_Digits),delim);
     string s3Set = SetGvar(gMaterKey,pS3,DoubleToStr(S3,_Digits),delim);
     string s4Set = SetGvar(gMaterKey,pS4,DoubleToStr(S4,_Digits),delim);
     
  }
  
//+------------------------------------------------------------------+
//| My function: Realiza calculo de catidad de decimales             |
//| Date       : 06/05/2023                                          |
//+------------------------------------------------------------------+

   string SetGvar(string masterKey, string key, string defValue, string KeySeparator= "_"){
      string gvKey = masterKey + KeySeparator + key;
      string result = GlobalVariableSet(gvKey,defValue);
      
      //printf("Result Funcion GlobalVariableSet(gvKey,defValue)  =====>" + result);
      
      return result;  

   }
   //+------------------------------------------------------------------+
   string GetGvar(string masterKey, string key, string defValue, string KeySeparator= "_"){
      
      string gvKey = masterKey + KeySeparator + key;
      string result = GlobalVariableCheck(gvKey) ? GlobalVariableGet(gvKey): defValue;
      //printf("Result Funcion GlobalVariableCheck(gvKey)    =====>" + GlobalVariableCheck(gvKey));
      //printf("Result Funcion GlobalVariableGet(gvKey)    =====>" + GlobalVariableGet(gvKey));
      return (result);  
      
   }
 //+------------------------------------------------------------------+
 
// Función para determinar si una vela es alcista o bajista
   bool isBullishCandle(double open, double close) {
       return close > open;
   }

   bool isBearishCandle(double open, double close) {
       return close < open;
   }
   
//+------------------------------------------------------------------+
//| My function: Realiza la modificacion de una orden de compra      |
//| Date       : 12/05/2023                                          |
//+------------------------------------------------------------------+ 
   void ModifyOrder(int order_ticket, double stop_loss, double take_profit)
   {
    // Seleccionar la orden por su número de ticket
    if (OrderSelect(order_ticket, SELECT_BY_TICKET))
    {
        // Comprobar que la orden seleccionada es una orden de compra
        if (OrderType() == OP_BUY)
        {
              double MyPoint=Point;
               if(Digits==3 || Digits==5) MyPoint=Point*10;
               double TheStopLoss=0;
               double TheTakeProfit=0;
     
               TheStopLoss=0;
               TheTakeProfit=0;
               if(TakeProfit>0) TheTakeProfit=Ask+TakeProfit*MyPoint;
               if(stop_loss>0) stop_loss=stop_loss-Bid*MyPoint;
               
               Print("stop_loss ===>>>",stop_loss);
               Print("ask send ===>>>",Ask);
               Print("bid  send ===>>>",Bid);
                      
               
               if (!OrderModify(order_ticket,OrderOpenPrice(),NormalizeDouble(stop_loss,Digits),NormalizeDouble(take_profit,Digits),0,Green));
                  {
                      
                      Print("Error al modificar la orden: ", GetLastError());
                  }
        }
        else
        {
            Print("La orden seleccionada no es una orden de compra.");
        }
    }
    else
    {
        Print("No se puede encontrar la orden con el número de ticket ", order_ticket);
    }
}

//+------------------------------------------------------------------+
//| My function: Calcular pips       |
//| Date       : 12/05/2023                                          |
//+------------------------------------------------------------------+
int CalculatePips(double price1, double price2)
{
    int digits = MarketInfo(Symbol(), MODE_DIGITS); // Obtiene la cantidad de dígitos decimales del símbolo actual
    int pips = (int)MathAbs((price1 - price2) / Point);
    
    return pips/10;
}

//+------------------------------------------------------------------+
//| My function: Calcular pips       |
//| Date       : 12/05/2023                                          |
//+------------------------------------------------------------------+
double CalculateRealRange()
{
    double high = iHigh(NULL, 0, 1); // Precio más alto de la última vela
    double low = iLow(NULL, 0, 1); // Precio más bajo de la última vela

    double range = high - low; // Cálculo del rango de la vela

    return range;
}

double CalculateApproximatePrice(double price, int digits)
{
    double approximatePrice = NormalizeDouble(price, digits);

    return approximatePrice;
}
 
