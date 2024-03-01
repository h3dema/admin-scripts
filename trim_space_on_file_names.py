# -*- coding: utf-8 -*-
"""

@@@  @@@  @@@@@@   @@@@@@@   @@@@@@@@  @@@@@@@@@@    @@@@@@
@@@  @@@  @@@@@@@  @@@@@@@@  @@@@@@@@  @@@@@@@@@@@  @@@@@@@@
@@!  @@@      @@@  @@!  @@@  @@!       @@! @@! @@!  @@!  @@@
!@!  @!@      @!@  !@!  @!@  !@!       !@! !@! !@!  !@!  @!@
@!@!@!@!  @!@!!@   @!@  !@!  @!!!:!    @!! !!@ @!@  @!@!@!@!
!!!@!!!!  !!@!@!   !@!  !!!  !!!!!:    !@!   ! !@!  !!!@!!!!
!!:  !!!      !!:  !!:  !!!  !!:       !!:     !!:  !!:  !!!
:!:  !:!      :!:  :!:  !:!  :!:       :!:     :!:  :!:  !:!
::   :::  :: ::::   :::: ::   :: ::::  :::     ::   ::   :::
 :   : :   : : :   :: :  :   : :: ::    :      :     :   : :


Copyright 2024 by Henrique Duarte Moura.
All rights reserved.

This file is part of the simple test project,
and is released under the "MIT License Agreement".
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

Please see the LICENSE file that should have been included as part of this package.
"""
__maintainer__ = "Henrique Duarte Moura"
__email__ = "Henrique.DuarteMoura@imec.be"
__version__ = "0.1.0"
import os

"""
This is a script that scans a directory (root) and all its subdirectories looking for files that have spaces as the initial part of the name.
The name is trim()ed and the file is renamed.

This script is very useful for applications like [Onedrive on Linux](https://github.com/abraunegg/onedrive), 
as one of the OneDrive rules prevents these files whose names start with spaces from being uploaded to the repository.

Usage:
======
python3 trim_space_on_file_names.py
"""

if __name__ == "__main__":
    rootdir = "/root/OneDrive"
    print(f"Will search at {rootdir}")
    for subdir, dirs, files in os.walk(rootdir):
        for file in files:
            if file.strip() != file:
                origin = os.path.join(subdir, file)
                print(origin)
                os.rename(origin, os.path.join(subdir, file.strip()))
