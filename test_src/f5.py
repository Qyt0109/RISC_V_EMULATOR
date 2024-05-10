import threading
import pyautogui
import keyboard
import time

exit_flag = False

time_sleep = 1000


def press():
    while not exit_flag:
        pyautogui.press('f5')
        time.sleep(time_sleep/1000)

def up():
    global time_sleep
    while not exit_flag:
        if keyboard.is_pressed(keyboard.KEY_UP):
            time_sleep += 100
            print(time_sleep)
        time.sleep(0.2)  # Add a small delay to avoid high CPU usage
        if exit_flag:
            break

def down():
    global time_sleep
    while not exit_flag:
        if keyboard.is_pressed(keyboard.KEY_DOWN):
            if time_sleep > 0:
                time_sleep -= 100
            print(time_sleep)
        time.sleep(0.2)  # Add a small delay to avoid high CPU usage
        if exit_flag:
            break

        

def listen_for_esc():
    global exit_flag
    keyboard.wait('esc')
    print("Exiting program...")
    exit_flag = True

if __name__ == "__main__":
    # Start a thread for continuously pressing
    f5_thread = threading.Thread(target=press)
    f5_thread.start()

    up_thread = threading.Thread(target=up)
    up_thread.start()

    down_thread = threading.Thread(target=down)
    down_thread.start()

    # Listen for the 'esc' key press
    listen_for_esc()

    # Wait for the thread to finish
    f5_thread.join()
    up_thread.join()
    down_thread.join()
