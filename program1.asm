# CS286 Project 1 - Program #1 (IF ~ THEN ~ ELSE)
# Name: Alex Agbleade
# Student ID: 800812955
#

        .data
prompt_speed:        .asciiz "Enter your current driving speed in MPH (1 to 200): "
invalid_speed:       .asciiz "You made an invalid input for your current driving speed. Enter a valid input for your current driving speed\n"
prompt_limit:        .asciiz "Enter the absolute speed limit specified for the road you are currently running on (15 - 70): "
invalid_limit:       .asciiz "You made an invalid input for the absolute speed limit. Enter a valid input for the speed limit\n"
msg_safe:            .asciiz "\n\n\n You are a safe driver!\n"
msg_fine_120:        .asciiz "\n\n\n You may receive a $120 fine\n"
msg_fine_140:        .asciiz "\n\n\n You may receive a $140 fine\n"
msg_fine_classB:     .asciiz "\n\n\n Class B misdemeanor and carries up to six months in jail and a maximum $1,500 in fines\n"
msg_fine_classA:     .asciiz "\n\n\n Class A misdemeanor and carries up to one year in jail and a maximum $2,500 in fines\n"

        .text
        .globl main
main:
# --- read current driving speed (validated 1..200) ---
ask_speed:
        li $v0, 4
        la $a0, prompt_speed
        syscall

        li $v0, 5
        syscall
        move $t0, $v0        # $t0 = current speed

        # validate 1..200
        li $t1, 1
        blt $t0, $t1, bad_speed
        li $t1, 200
        bgt $t0, $t1, bad_speed
        j ask_limit

bad_speed:
        li $v0, 4
        la $a0, invalid_speed
        syscall
        j ask_speed

# --- read speed limit (validated 15..70) ---
ask_limit:
        li $v0, 4
        la $a0, prompt_limit
        syscall

        li $v0, 5
        syscall
        move $t2, $v0        # $t2 = speed limit

        # validate 15..70
        li $t3, 15
        blt $t2, $t3, bad_limit
        li $t3, 70
        bgt $t2, $t3, bad_limit
        j check_penalty

bad_limit:
        li $v0, 4
        la $a0, invalid_limit
        syscall
        j ask_limit

# --- penalty evaluation ---
check_penalty:
        ble $t0, $t2, safe_msg

        # diff = current - limit
        sub $t4, $t0, $t2

        # diff 1..20 -> $120
        li $t5, 1
        blt $t4, $t5, safe_msg
        li $t5, 20
        ble $t4, $t5, fine120

        # diff 21..25 -> $140
        li $t5, 25
        ble $t4, $t5, fine140

        # diff 26..34 -> Class B
        li $t5, 34
        ble $t4, $t5, fine_classB

        # otherwise Class A
        j fine_classA

safe_msg:
        li $v0, 4
        la $a0, msg_safe
        syscall
        j program_exit

fine120:
        li $v0, 4
        la $a0, msg_fine_120
        syscall
        j program_exit

fine140:
        li $v0, 4
        la $a0, msg_fine_140
        syscall
        j program_exit

fine_classB:
        li $v0, 4
        la $a0, msg_fine_classB
        syscall
        j program_exit

fine_classA:
        li $v0, 4
        la $a0, msg_fine_classA
        syscall
        j program_exit

program_exit:
        li $v0, 10
        syscall
