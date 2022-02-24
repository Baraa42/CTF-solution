from brownie import network, accounts
from dotenv import dotenv_values


def main():
    account0 = accounts.add(dotenv_values(".env")["private1"])
    print(account0)
    print(account0.balance())


if __name__ == "__main__":
    main()
