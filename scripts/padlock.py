from brownie import network, accounts, interface
from dotenv import dotenv_values


def main():
    # account = accounts.add(dotenv_values(".env")["private1"])
    padlock = interface.IPadlock("0xf8e8370a8d0a840db47b2d52bee5c549ad04809a")
    hash = padlock.passHash()
    print(hash)


if __name__ == "__main__":
    main()
