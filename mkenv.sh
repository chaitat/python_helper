#!/bin/bash

# ตรวจสอบว่าใช้ระบบปฏิบัติการอะไร
os_type="unknown"
activate_cmd=""

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    os_type="Linux"
    activate_cmd=".env/bin/activate"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    os_type="Mac"
    activate_cmd=".env/bin/activate"
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    os_type="Windows"
    activate_cmd=".env/Scripts/activate"
fi

echo -e "Operating system detected: \033[32m$os_type\033[0m"
echo " "
echo -e "Activate command: \033[32m$activate_cmd\033[0m"  # แสดงค่า activate_cmd

# ถ้า env มีอยู่แล้วให้ activate
if [ -d ".env" ]; then
    echo -e "\033[32mVirtual environment found\033[0m, activating..."
    source "$activate_cmd"  # ใช้ source แทน eval
else
    # ถ้า env ไม่มี ให้สร้างและ activate
    echo -e "\033[91mNo virtual environment found\033[0m, creating one..."
    python3 -m venv .env
    source "$activate_cmd"  # ใช้ source แทน eval
fi

# ตรวจสอบว่ามีไฟล์ requirements.txt หรือไม่
if [ -f "requirements.txt" ]; then
    echo -e "\033[31mrequirements.txt found\033[0m, installing dependencies..."
    pip install -r requirements.txt
else
    echo -e "\033[91mrequirements.txt not found\033[0m, skipping installation"
fi

# ตรวจสอบว่ามีโฟลเดอร์ .git หรือไม่
if [ -d ".git" ]; then
    echo "Git repository already exists, skipping initialization."
else
    # ถามผู้ใช้ว่าต้องการสร้าง git repository หรือไม่
    echo "Do you want to initialize a git repository?"
    select git_init in "yes" "no"; do
        case $git_init in
            yes )
                echo "Initializing git repository..."
                git init
                break
                ;;
            no )
                echo "Skipping git initialization."
                break
                ;;
            * )
                echo "Please select yes or no."
                ;;
        esac
    done
fi
