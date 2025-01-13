import os

def lambda_handler(event, context):
    for file in [
        "/etc/hostname",
        "/etc/hosts",
        "/etc/resolv.conf",
        "/etc/nsswitch.conf"
    ]:
        if not os.path.exists(file):
            print(f"file = {file} does not exists")
            continue
        with open(file) as fp:
            print(f"-------------------------------{file}----------------------------------")
            print(fp.read())
            print(f"-------------------------------{file}----------------------------------")
