#include <16F877A.h>
#device ADC=10
#use delay(crystal=20000000,restart_wdt)

unsigned char codifica(unsigned char);

int time_dl = 10;
int cont = 0;

unsigned char cont_su = 0;  // unidades de segundo
unsigned char cont_sd = 0;  // decenas de segundo
unsigned char cont_mu = 0;  // unidades de minuto
unsigned char cont_md = 0;  // decenas de minuto

short pause = 1;

#INT_EXT
void interrupcion_start()
{
   pause = !pause;
}

void main()
{
   set_tris_b(0x03);  // RB0 y RB1 como entrada
   set_tris_a(0x00);  // puerto A como salida (segmentos)
   set_tris_d(0x00);  // puerto D como salida (segmentos)

   setup_adc_ports(NO_ANALOGS); // todos los pines como digitales
   
   enable_interrupts(GLOBAL);
   enable_interrupts(INT_EXT);
     
   while(TRUE)
   {
      output_low(PIN_A3);
      output_high(PIN_A0);  // Selecciona primer dígito: decenas de minuto
      output_d(codifica(cont_md));
      delay_ms(time_dl);
      
      output_low(PIN_A0);
      output_high(PIN_A1);  // Selecciona primer dígito: decenas de minuto
      output_d(codifica(cont_mu));
      delay_ms(time_dl);
      
      output_low(PIN_A1);
      output_high(PIN_A2);  // Selecciona primer dígito: decenas de minuto
      output_d(codifica(cont_sd));
      delay_ms(time_dl);
      
      output_low(PIN_A2);
      output_high(PIN_A3);  // Selecciona primer dígito: decenas de minuto
      output_d(codifica(cont_su));
      delay_ms(time_dl);
   
      //------------------------------------------------------------------------------
      if(pause == 0)  //pause
      {
         cont++;
         delay_ms(10);
         
         if(cont >= 16)
         {
            cont = 0;
            cont_su++;
            if(cont_su >= 10)
            {
               cont_su = 0;
               cont_sd++;
               if(cont_sd >= 6)
               {
                  cont_sd = 0;
                  cont_mu++;
                  if(cont_mu >= 10)
                  {
                     cont_mu = 0;
                     cont_md++;
                  }
               }
            }
         }
      }
      //------------------------------------------------------------------------------
      if(input(PIN_B1) == 0)
      {
         pause = 1;
         cont_su = 0;
         cont_sd = 0;
         cont_mu = 0;
         cont_md = 0;
         cont = 0;
      }
   }
   
}

unsigned char codifica(unsigned char numero) {
   switch (numero) {
      case 0: return 0x3F;
      case 1: return 0x06;
      case 2: return 0x5B;
      case 3: return 0x4F;
      case 4: return 0x66;
      case 5: return 0x6D;
      case 6: return 0x7D;
      case 7: return 0x07;
      case 8: return 0x7F;
      case 9: return 0x6F;
      default: return 0x00;
   }
}
