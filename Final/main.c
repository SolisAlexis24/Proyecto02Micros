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
   while(TRUE) {
      if(kbhit()) {             // Verifica si hay datos disponibles antes de leer
         c = getc();            // Lee un car�cter
         if(c == '\r' || c == '\n') {
            buffer[i] = '\0';           // Termina la cadena
            comprobar_comando();        // Se comprueba si la cadena pertenece a un comando
            i = 0;                      
            memset(buffer, 0, MAX_LEN); // Se borra el buffer
         }
         else if(i < MAX_LEN - 1){     // Si aun caben caracteres
            buffer[i++] = c;           // Se a�ade al buffer
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
      printf(">>%u\r", temperatura);
      printf(lcd_putc, "\fTemp: %u", temperatura);
      if(pwm_val>0) setup_ccp1(CCP_PWM);  // Si hay valor de PWM, se fija
   } 
   else if(strcmp(buffer, comandos[1]) == 0){
      echo();
      lcd_putc("\fEnciende motor");
      output_high(IN1);             // Se enciende el motor
      output_low(EN1);
      //set_pwm1_duty(pwm_val);             // Se fija pwm
   }
   else if(strcmp(buffer, comandos[2]) == 0){
      echo();
      lcd_putc("\fApaga motor");
      output_low(IN1);              // Se apaga el motor
      set_pwm1_duty(0);             // Se fija pwm a 0
   }
   else if(strcmp(buffer, comandos[3]) == 0){
      echo();
      lcd_putc("\fEnciende LEDs");
      output_b(0xFF);               // Se encienden los LEDs
   }
   else if(strcmp(buffer, comandos[4]) == 0){
      echo();
      lcd_putc("\fApaga LEDs");
      output_b(0x00);               // Se apagan los LEDs
   }
   else if(strncmp(buffer, patron_pwm, strlen(patron_pwm)) == 0){
      // Extrae el valor despu�s de "pwm="
      char *pwm_str = buffer + strlen(patron_pwm);
      
      // Verifica que todos los caracteres sean d�gitos
      int valid = 1;
      for(int j = 0; pwm_str[j] != '\0'; j++) {
         if(!isdigit(pwm_str[j])) {
            valid = 0;
            break;
         }
      }
      
      if(!valid || strlen(pwm_str) > 3) {  // M�ximo 3 d�gitos (0-100)
         lcd_putc("\fPWM invalido");
         return;
      }
      
      pwm_val = atoi(pwm_str);
      
      if(pwm_val > 100) {
         lcd_putc("\fPWM > 100%");
         return;
      }
      
      setup_ccp1(CCP_PWM);
      // Se ajusta el ciclo de trabajo
      ajusta_dc_PWM(pwm_val);

      printf(lcd_putc, "\f***PWM = %u%%***", pwm_val);
   }
   else {      
      lcd_putc("\fComando no");
      lcd_gotoxy(1,2);
      lcd_putc("reconocido");
   }
}

/**
 * Eco del comando recibido por comunicaci�n serial
 */
void echo()
{
    printf(">>%s\r", buffer);
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
