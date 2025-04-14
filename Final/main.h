#include <16F877A.h>
#fuses HS,NOPROTECT,NOWDT,NOLVP
#device ADC=8
#use delay(crystal=20MHz)
#use FIXED_IO( B_outputs=PIN_B7,PIN_B6,PIN_B5,PIN_B4,PIN_B3,PIN_B2,PIN_B1,PIN_B0 )
#use FIXED_IO( C_outputs=PIN_C2,PIN_C1,PIN_C0 )
#define L0   PIN_B0
#define L1   PIN_B1
#define L2   PIN_B2
#define L3   PIN_B3
#define L4   PIN_B4
#define L5   PIN_B5
#define L6   PIN_B6
#define L7   PIN_B7
#define IN1   PIN_C0
#define IN2   PIN_C1
#define EN1   PIN_C2
#define RX   PIN_C6
#define TX   PIN_C7

#define LCD_ENABLE_PIN  PIN_D1
#define LCD_RS_PIN      PIN_D0                                 
#define LCD_RW_PIN      PIN_D7   
#define LCD_DATA4       PIN_D5                                    
#define LCD_DATA5       PIN_D4                                  
#define LCD_DATA6       PIN_D3                                 
#define LCD_DATA7       PIN_D2 



