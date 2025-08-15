# ps4_autoLL

**This repo is for users who want to enjoy the early HEN with Lua & Lapse. For the main update, please refer to the main repo [remote_lua_loader](https://github.com/shahrilnet/remote_lua_loader)**

Automatically loads HEN with Lua + Lapse kernel exploit for PS4, supports PS4 firmware up to version `12.02`.

Base on [remote_lua_loader](https://github.com/shahrilnet/remote_lua_loader) and [itsPLK's fork](https://github.com/itsPLK/ps5_lua_loader)

## How to use
* Copy all files from the savedata dir to your decrypted save (make sure to delete all files except the "sce_sys" folder before copy), then encrypt and resign to your accounts (you can either use Apollo and Discord bot from HTOS)
* Copy the modified save to your PS4
* Download vtx `hen.bin` from [Scene-Collective's releases](https://github.com/Scene-Collective/ps4-hen/releases) and rename to `payload.bin`
* Copy `payload.bin` to the root directory of your USB drive (exFAT format) (it only needs to be done once)
* Plug the USB drive to your PS4 and run the games, it will do the exploit and copy the payload to the internal HDD (it only needs to be copied once), enjoy! <be>

Please note that there might be bugs; this is an early version of the Lapse exploit, so keep it in mind. <be>
DO NOT run the exploit again after the HEN is loaded; it may cause instability. <be>
If you get an exploit error, restart the PS4 and try again.

## Update HEN

* Copy the new HEN and rename it to `payload.bin` to the USB drive's root, then run the game to update the payload on the internal HDD.

## Game Compatibility

Currently, this loader is compatible with the following games:
  
| Game Title                            | TITLE ID    | Notes                                                                           |
|---------------------------------------|-------------|---------------------------------------------------------------------------------|
| Raspberry Cube                        | CUSA16074   |                                                                                 |
| Aibeya                                | CUSA17068   |                                                                                 |
| Hamidashi Creative                    | CUSA27389   |                                                                                 |
| Hamidashi Creative Demo               | CUSA27390   | Requires latest firmware to download from PSN                                   |
| Aikagi Kimi to Issho ni Pack          | CUSA16229   |                                                                                 |
| Aikagi 2                              | CUSA19556   |                                                                                 |
| IxSHE Tell                            | CUSA17112   |                                                                                 |
| IxSHE Tell Demo                       | CUSA17126   | Requires latest firmware to download from PSN                                   |
| Nora Princess and Stray Cat Heart HD  | CUSA13303   |                                                                                 |
| Jinki Resurrection                    | CUSA25179   |                                                                                 |
| Jinki Resurrection Demo               | CUSA25180   | Requires latest firmware to download from PSN                                   |
| Fuyu Kiss                             | CUSA29745   |                                                                                 |
| Fuyu Kiss Demo                        | CUSA29746   | Requires latest firmware to download from PSN                                   |
| Nora Princess and Crying Cat 2        | CUSA13586   |                                                                                 |
| Haruoto Alice Gram Snow Drop          | CUSA14324   |                                                                                 |
| Tonari ni Kanojo no Iru Shiawase Winter Guest          | CUSA11977   |                                                                                 |
| Mikagami Sumika no Seifuku Katsudou          | CUSA11481   |                                                                                 |

## Credits

* abc – for the lapse exploits
* shahrilnet – creator and maintainer of the original [remote_lua_loader](https://github.com/shahrilnet/remote_lua_loader)
* flatz - for sharing ideas and lua implementations
* null_ptr - for helping to develop umtx exploit for PS5 & numerous helps with the loader development
* gezine - for sharing the vulnerable games & ideas
* specter & chendo - for webkit implementations referenced a lot
* al-azif - parts and information grabbed from his sdk, as well as from his ftp server, and ps4-hen repo
* echostretch & illusion0001 - for the maintaining ps4-hen repo
* horror - for the notification popup and ftp server payloads
* everyone else who shared their knowledge with the community
* and the excellent [blog post](https://memorycorruption.net/posts/rce-lua-factorio/) where most of the ideas of lua primitives are taken from 

