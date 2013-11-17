# FuelPHP Vagrant Development setup (CentOS6)

このプロジェクトは、あなたのFuelPHPプロジェクトを含むCentOS 6.4 (64bit)仮想マシンをセットアップします。FuelPHPプロジェクトのディレクトリをマウントするため、お好みのエディタで作業できます。

## 要件

* VirtualBox - フリーな仮想化ソフトウェア [ダウンロード](https://www.virtualbox.org/wiki/Downloads)
* Vagrant **1.3+** - VirtualBoxのイメージを操作するツール [ダウンロード](http://downloads.vagrantup.com/)
* Git - バージョン管理システム [ダウンロード](http://git-scm.com/downloads)

### テストされたバージョン

* VirtualBox 4.2.18
* Vagrant 1.3.5
* Git 1.7.9.5

## この開発環境に含まれるもの

以下のいくつかは、Chef Opscodeリポジトリを使ってインストールされます。

* PHP 5.4
* Apache 2.2
  * vhost setup for your project
* MySQL 5.1
  * **fuel_dev** and **fuel_test** databases
* phpMyAdmin 3.5

## 推奨されるセットアップ方法とディレクトリ構成

vagrant-fuelphp-centos6をあなたのプロジェクトに追加します:

	$ git submodule add git@github.com:kenjis/vagrant-fuelphp-centos6.git vagrant
	$ git submodule update --init --recursive
	$ cd vagrant
	$ vagrant up

ディレクトリ構成は以下のようになります:

	project/
	project/fuel
	project/public/
	project/vagrant/

## FuelPHPプロジェクトへのアクセス方法

* **Browser**: [http://localhost:8000](http://localhost:8000)
* **Browser by IP**: [http://192.168.33.33](http://192.168.33.33)
* **Mysql**: mysql:host=192.168.33.33;dbname=fuel_dev (rootユーザのpasswordはVagrantfileに記載されています)

### Vagrant

よく使うコマンド:

* `vagrant up` 仮想マシンを起動しプロビジョンします
* `vagrant suspend` 起動状態の仮想マシンを保存して停止します
* `vagrant halt` 仮想マシンを停止します
* `vagrant ssh` 仮想マシンへのSSHアクセスを提供します

もっと知りたい場合は、http://docs.vagrantup.com/v2/

## Thanks to

* https://github.com/iturgeon/vagrant-fuelphp
