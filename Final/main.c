#include <main.h>
#include <lcd.c>
#include <string.h>
#include <stdlib.h>
#include <PIC16F877A_registers.h>
#use rs232(baud=38400, xmit=PIN_C6, rcv=PIN_C7, bits=8, parity=N, stop=1)
#define MAX_LEN 13

void comprobar_comando();
void echo();
void ajusta_dc_PWM(int8 );

char comandos[5][MAX_LEN] = {       // Comandos para consola
      "temperatura",
      "motor on",
      "motor off",
      "leds on",
      "leds off"
   };

char buffer[MAX_LEN];               // Buffer para mensaje recibido
char* patron_pwm = "pwm=";          // Puntero al patron del pwm
unsigned int8 pwm_val = 0;          // Cambiado a unsigned int16 para PWM de 10 bits
unsigned int8 temperatura = 0;      // Temperatura del sensor
int1 motor_on = 0;                   // Bandera para controlar el motor

void main()
{
   //===============================Variables del programa===============================
   char c;                      //Caracteres individuales recibidos
   int i = 0;                   //Indice para guardar mensaje
   //====================================================================================
   
   //===============================Configuracion del PIC===============================
   setup_timer_2(T2_DIV_BY_16,155,1);    // Se definen los parametros del temporizador para PWM
   lcd_init();                           // Se inicializa el LCD
   setup_port_a(ALL_ANALOG);             // Puertos para lectura ADC
   setup_adc(ADC_CLOCK_INTERNAL);        // Reloj de lectura ADC
   //===================================================================================
   
   lcd_putc("\fSistema listo");
   printf(">>Sistema listo\r");
   while(TRUE) {
      if(kbhit()) {             // Verifica si hay datos disponibles antes de leer
         c = getc();            // Lee un carácter
         if(c == '\r' || c == '\n') {
            buffer[i] = '\0';           // Termina la cadena
            comprobar_comando();        // Se comprueba si la cadena pertenece a un comando
            i = 0;                      
            memset(buffer, 0, MAX_LEN); // Se borra el buffer
         }
         else if(i < MAX_LEN - 1){     // Si aun caben caracteres
            buffer[i++] = c;           // Se añade al buffer
         }
      }
   }
}

/**
 * Funcion para poder verificar  si la cadena pertenece a un comando
 */
void comprobar_comando(){
   if(strcmp(buffer, comandos[0]) == 0) {
      
      setup_ccp1(CCP_OFF);       // Se apaga el PWM para no obstaculizar lectura
      set_adc_channel(1);        // Se fija el canal de lectura 
      delay_us(10);              // Estabilizacion
      temperatura = read_adc();  // Leer el valor de 8 bits
      temperatura = 2*temperatura; //Valor aproximado a lectura*19.53mV/(10mV/C)
      //Donde 19.53 mV es la resolucion a 8 bits y 10 mV/C es el paso del sensor
      printf(">>La temperatura es: %u *C\r", temperatura);
      printf(lcd_putc, "\fTemperatura: %u", temperatura);
      if(pwm_val>0) setup_ccp1(CCP_PWM);  // Si hay valor de PWM, se enciende PWM
   } 
   else if(strcmp(buffer, comandos[1]) == 0){
      output_high(IN1);             // Se enciende el motor
      output_low(EN1);              // Se apaga el enable
                                    // Esto no afecta por el control de PWM
                                    // Pero si no esta, el motor se enciende solo
      motor_on = 1;                 // Indica motor funcionando
      printf(">>Se enciende el motor\r");
      lcd_putc("\fEnciende motor");
   } 
   else if(strcmp(buffer, comandos[2]) == 0){
      output_low(IN1);              // Se apaga el motor
      motor_on = 0;                 // Indica motor apagado
      printf(">>Se apaga el motor\r");
      lcd_putc("\fApaga motor");
   }
   else if(strcmp(buffer, comandos[3]) == 0){
      printf(">>Se encienden los LEDs\r");
      lcd_putc("\fEnciende LEDs");
      output_b(0xFF);               // Se encienden los LEDs
   }
   else if(strcmp(buffer, comandos[4]) == 0){
      output_b(0x00);               // Se apagan los LEDs
      printf(">>Se apagan los LEDs\r");
      lcd_putc("\fApaga LEDs");
   }
   else if(strncmp(buffer, patron_pwm, strlen(patron_pwm)) == 0){
      // Extrae el valor después de "pwm="
      char *pwm_str = buffer + strlen(patron_pwm);
      
      // Verifica que todos los caracteres sean dígitos
      int valid = 1;
      for(int j = 0; pwm_str[j] != '\0'; j++) {
         if(!isdigit(pwm_str[j])) {
            valid = 0;
            break;
         }
      }
      
      if(!valid || strlen(pwm_str) > 3) {  // Máximo 3 dígitos (0-100)
         lcd_putc("\fPWM invalido");
         printf(">>PWM invalido\r");
         return;
      }
      
      pwm_val = atoi(pwm_str);
      
      if(pwm_val > 100) {
         lcd_putc("\fPWM > 100%");
         printf(">>El PWM debe ser menor a 100%%\r");
         return;
      }
      
      setup_ccp1(CCP_PWM);             // Se enciende el PWM
      ajusta_dc_PWM(pwm_val);          // Se ajusta el ciclo de trabajo
      if(!motor_on) output_low(IN1);   // Si el motor no esta andando, mantenlo asi
      printf(lcd_putc, "\f***PWM = %u%%***", pwm_val);
      printf(">>Se actualiza el PWM al %u%%\r", pwm_val);
   }
   else {     
      printf(">>El comando \"%s\" no es reconocido\r", buffer);
      lcd_putc("\fComando no");
      lcd_gotoxy(1,2);
      lcd_putc("reconocido");
   }
}



/**
 * Ajusta el ciclo de trabajo del PWM
 * @param duty_cycle Valor de 0 a 100%
 */
void ajusta_dc_PWM(int8 ciclo)
{
   if(ciclo>=0 && ciclo<=100)
   {
      set_pwm1_duty((int16)(ciclo*624/100));
   }
   else
   {
      set_pwm1_duty(0);
   }
}
