<p align="center">
  <a href="" rel="noopener">
 <img src="./.github/images/github-header-image.png" alt="Project logo"></a>
</p>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<h1 align="center"> :link: Table of Contents </h1>

+ [:link: Table of Contents](#%3A%6C%69%6E%6B%3A%2D%74%61%62%6C%65%2D%6F%66%2D%63%6F%6E%74%65%6E%74%73)
  + [:x: Problem](#%3A%78%3A%2D%70%72%6F%62%6C%65%6D)
  + [:heavy\_check\_mark: Solution](#%3A%68%65%61%76%79%5F%63%68%65%63%6B%5F%6D%61%72%6B%3A%2D%73%6F%6C%75%74%69%6F%6E)
  + [✅ Install prerequisites](#%E2%9C%85%2D%69%6E%73%74%61%6C%6C%2D%70%72%65%72%65%71%75%69%73%69%74%65%73)
  + [:memo: Notes](#%3A%6D%65%6D%6F%3A%2D%6E%6F%74%65%73)
  + [:gear: Instructions](#%3A%67%65%61%72%3A%2D%69%6E%73%74%72%75%63%74%69%6F%6E%73)
    + [Install](#%69%6E%73%74%61%6C%6C)
    + [Upgrade](#%75%70%67%72%61%64%65)
  



## :x: Problem

I've used Semaphore for about a year and loved it. But always hated that I needed to either use docker or install all this manually. Which is not an issue but hey why not make life easier? 

## :heavy_check_mark: Solution

I Created **SemaUwU**  after watching [Learn Linux TV](https://www.learnlinux.tv/complete-ansible-semaphore-tutorial-from-installation-to-automation/#more-4065) on installing semaphore and thought. Ahh cool a good base to base the script off of. I just need the logic to grab the Latest Release. 


## ✅ Install prerequisites
- **Deb Based**

```bash
sudo apt -y install jq wget curl git
```
  - **RPM Based**

```bash
sudo dnf -y install jq wget curl git
```

## :memo: Notes
> [!NOTE]
> I've modified the script to install MariaDB by default and pass the commands through to MariaDB for the setup of the database. This is not for the Sempaphore Setup portion but just the Datbase. All you need to is note that information for the semaphore portion.
> - In [mariab.conf](conf/mariadb.conf) you'll just need to change the password and make your own root password as well.

> [!NOTE]
> Since new versions of Semaphore let you use **Terraform** and **OpenTofu**. You Can also install them following the Instructions from the links below
> - [Terraform](https://developer.hashicorp.com/terraform/install?ajs_aid=edd2c1a1-9fee-4fca-b9af-9b89a5e3932c&product_intent=terraform)
> - [OpenTofu](https://opentofu.org/docs/intro/install/)

## :gear: Instructions

<details>
  <summary>Click me</summary>


### Install

- **Clone the repo.**

```bash
git clone https://github.com/ColoredBytes/semaUwU.git
```

- **Change into the directory**

 ```bash
cd semaUwU
```
- **On Deb Based Systems.**
 
 ```bash
 ./install.sh deb
```
- **On Rpm Based Systems.**

```bash
./install.sh rpm
```

---

### Upgrade

- **Change into the directory**

 ```bash
cd semaUwU
```
- **On Deb Based Systems.**
 
 ```bash
 ./upgrade.sh deb
```
- **On Rpm Based Systems.**

```bash
./upgrade.sh rpm
```
</details>









