//+------------------------------------------------------------------+
//|                                                        Grape.mq4 |
//|                       Copyright 2023, Rodrigo Velosa, ForexRobot |
//|                         https://www.instagram.com/rodrigovelosa/ |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Rodrigo Velosa, ForexRobot"
#property link      "https://www.instagram.com/rodrigovelosa/"
#property version   "1.00"
#property strict

//input double TakeProfit    =50;
//input double Lots          =0.1;
input double TrailingStop  =30;
input double MACDOpenLevel =3;
input double MACDCloseLevel=2;
input int    MATrendPeriod =26;

#property indicator_chart_window
#property script_show_inputs
#property indicator_chart_window
#property script_show_inputs
#include "..\\Libraries\\rodVelMQL.mq4"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
 int OnInit()
  {
  
   printf("Nuestro Robot Grape se ha Cargado a la gráfica!!");
   printf("El simbolo seleccionado es: "+ Symbol());
   int ticket = OrderTicket();
   CloseOrder(ticket);
   
   //string currentDate[1];
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
 void OnDeinit(const int reason)
  {

   printf("Nuestro Robot Grape se ha Eliminado a la gráfica!!");
   
  }
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
 void OnTick(void){
  int      result=0, range=-1;
  long     account = 1234;
  string   symbol = Symbol();
  int      magic = 4321;
  double   ListPsicologyc[5];
  string   delim = "_";
  string   valuDefaul = "-1";
  string   pS0 = "S0", pS1 = "S1", pS2 = "S2", pS3 = "S3", pS4 = "S4";
  string   gMaterKey = StringConcatenate(account,delim,symbol,delim,magic);
  int current_order_ticket;
  double   precioVenta= 0;
  double open = Open[0];
  double close = Close[0];
  double price1 = Bid; // Precio 1 (por ejemplo, precio de oferta actual)
  double price2 = Ask; // Precio 2 (por ejemplo, precio de demanda actual)


   pSicologicRange('D',4);// Z:int, D:decimal
   
    double currentBid = NormalizeDouble(Bid, Digits); // Obtener el precio actual de oferta (bid)
    double approximatePrice = CalculateApproximatePrice(currentBid, Digits);
    
   
   if( TotalOrdersCount()== 0 ){
   int result=0;
   
      precioVenta = SymbolInfoDouble(_Symbol, SYMBOL_BID);
      //Agregamos el listado de los precios psicolgicos al arreglo - 100pits
      ListPsicologyc[0]= GetGvar(gMaterKey,pS0,valuDefaul,delim);
      ListPsicologyc[1]= GetGvar(gMaterKey,pS1,valuDefaul,delim);
      ListPsicologyc[2]= GetGvar(gMaterKey,pS2,valuDefaul,delim);
      ListPsicologyc[3]= GetGvar(gMaterKey,pS3,valuDefaul,delim);
      ListPsicologyc[4]= GetGvar(gMaterKey,pS4,valuDefaul,delim);
      
      
      Print("PRECIO VENTA ACTUAL->",precioVenta);
            //Print("PRECIO S0 -> ",ListPsicologyc[0]);
            //Print("PRECIO S1 -> ",ListPsicologyc[1]);
            //Print("PRECIO S2 -> ",ListPsicologyc[2]);
            //Print("PRECIO S3 -> ",ListPsicologyc[3]);
            //Print("PRECIO S4 -> ",ListPsicologyc[4]);
 
 //-------------------------------------------------------------------------------------------------------//      
      if(precioVenta > ListPsicologyc[0] && precioVenta < ListPsicologyc[1] )
        {
           Print("Entro a psico 0->",precioVenta);
           Print("Dif. precio 0->",NormalizeDouble(precioVenta-ListPsicologyc[0],_Digits));
           int pips = CalculatePips(precioVenta, ListPsicologyc[0]);
           Print("El número de pips es: ", pips);
           range = 1;
           operation(range);
        }else if(precioVenta > ListPsicologyc[1] && precioVenta < ListPsicologyc[2] )
                {
                 Print("Entro a psico 1->",precioVenta);
                 Print("Dif. precio 1->",NormalizeDouble(precioVenta-ListPsicologyc[1],_Digits));
                 int pips = CalculatePips(precioVenta, ListPsicologyc[1]);
                 Print("El número de pips es: ", pips);
                 range = 2;
                 operation(range);
                }else if(precioVenta > ListPsicologyc[2] && precioVenta < ListPsicologyc[3] )
                        {
                         Print("Entro a psico 2->",precioVenta);
                         Print("Dif. precio 2->",NormalizeDouble(precioVenta-ListPsicologyc[2],_Digits));
                         int pips = CalculatePips(precioVenta, ListPsicologyc[2]);
                         Print("El número de pips es: ", pips);
                         range = 3;
                         operation(range);
                        }else if(precioVenta > ListPsicologyc[3] && precioVenta < ListPsicologyc[4] )
                                {
                                 Print("Entro a psico 3->",precioVenta);
                                 Print("Dif. precio 3->",NormalizeDouble(precioVenta-ListPsicologyc[3],_Digits));
                                 int pips = CalculatePips(precioVenta, ListPsicologyc[3]);
                                 Print("El número de pips es: ", pips);
                                 range = 4;
                                 operation(range);
                                }
      
 //-------------------------------------------------------------------------------------------------------//
     
       
          for(int cnt=0;cnt<OrdersTotal();cnt++){
          
              OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
              if (OrderSelect(OrdersTotal() - 1, SELECT_BY_POS, MODE_TRADES)) // Seleccionar la última orden abierta
                   {
                       current_order_ticket = OrderTicket(); // Obtener el número de ticket de la orden
                       //Print("El número de orden actual es ", current_order_ticket);
                   }
          
             if(OrderType()== OP_BUY)
                 {
                  printf("================================================");
                      printf("Entro a compras...   ",current_order_ticket);
                      printf("OrderType() =====>   "+ OP_BUY);
                      ModifyOrder(current_order_ticket, precioVenta,ListPsicologyc[range]);
                  printf("================================================");
                  
                 }
                 
               if(OrderType()== OP_SELL)
                 {
                  printf("================================================");
                     printf("Entro a ventas...    ");
                     printf("OP_SELL  ----------->" + OP_SELL);
                  printf("================================================");
                  
                 }
         }
        //-------------------------------------------------------------------------------------------//
    }else
       {
            for(int cnt=0;cnt<OrdersTotal();cnt++){
               //OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
                    current_order_ticket = OrderTicket(); // Obtener el número de ticket de la orden
                    Print("El número de orden actual es ", current_order_ticket);
                   
                 if(OrderType()== OP_BUY)
                 {
                  printf("================================================");
                      printf("Entro a modificar SL de compras...",current_order_ticket);
                      //ModifyOrder(current_order_ticket, ListPsicologyc[range-1],ListPsicologyc[range]);
                  printf("================================================");
                  
                 }
            
            }
        
       }
    

  }
  
 
//+------------------------------------------------------------------+
