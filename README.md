<p align="center">
  <img src="./assets/images/github-header-image.png" alt="Header">
  <a href="https://github.com/ColoredBytes/Sempahore/blob/96113c308c5c5c57bb28591d058b2e90b2c65d33/LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT">
  </a>
</p>


# :link: Table of Contents

- [:x: Problem](#x-problem)
- [:heavy\_check\_mark: Solution](#heavy_check_mark-solution)
- [:gear: Instructions](#gear-instructions)


## :x: Problem

I've used Semaphore for about a year and loved it. But always hated that I needed to either use docker or install all this manually. Which is not an issue but hey why not make life easier? 

## :heavy_check_mark: Solution

I Created **SemaUwU**  after watching [Learn Linux TV](https://www.learnlinux.tv/complete-ansible-semaphore-tutorial-from-installation-to-automation/#more-4065) on installing semaphore and thought. Ahh cool a good base to base the script off of. I just need the logic to grab the Latest Release. 

## :gear: Instructions

### **Install prerequisites**
- **Debian Based**

```bash
sudo apt -y install jq wget curl git
```
  - **RHEL Based**

```bash
sudo dnf -y install jq wget curl git
```
---

- **Clone Repo.**

```bash
git clone https://github.com/ColoredBytes/SemaUwU.git
```
- **Make the script executable.**

```bash
chmod +x SemaUwU/install.sh
```
## 🏃Running The Script.
- **Change into the directory**

 ```bash
cd SemaUwU
```
- **On Deb Based Systems.**
 
 ```bash
 ./install.sh deb
```
- **On Rpm Based Systems.**

```bash
./install.sh rpm
```
## :memo: Notes
> [!NOTE]
> I've modified the script to install MariaDB by default and pass the commands through to help setup it up.
> - In [mariab.conf](conf/mariadb.conf) you'll just need to change the password and make your own root password as well.
---
> [!NOTE]
> Since new versions of Semaphore let you use **Terraform** and **OpenTofu**. You Can also install them following the Instructions from the links below
> - [Terraform](https://developer.hashicorp.com/terraform/install?ajs_aid=edd2c1a1-9fee-4fca-b9af-9b89a5e3932c&product_intent=terraform)
> - [OpenTofu](https://opentofu.org/docs/intro/install/)

> [!CAUTION]
> Their is some weird Behavior with 24.04 of Ubunutu. I suggest using 22.04 or Debian as an Alternative. 



