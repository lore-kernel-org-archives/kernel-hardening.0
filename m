Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <51534E5C.8070303@linux.vnet.ibm.com>
Date: Wed, 27 Mar 2013 15:54:04 -0400
From: Corey Bryant <coreyb@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Security vulnerability tools
To: oss-security@lists.openwall.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

I'd like to get a better understanding of tools used in the open source 
community (kernel and user space) to detect security vulnerabilities.

I have a list below to get started.  If anyone has any input, I'd 
appreciate it!

I'll plan on updating http://oss-security.openwall.org/wiki/tools with 
anything it doesn't already have.

pscan
-----
Scans C/C++ source code for problematic uses of printf style functions

rats
----
Rough auditing tool for security.  A general purpose scanner for 
detecting potential security problems in a wide range of languages.

flawfinder
----------
A general purpose scanner for finding and reporting upon potential flaws 
in both C and C++ source code

Valgrind
--------
Detect many memory management and threading bugs, and profile your 
programs in detail

KEDR
----
Provides runtime analysis of Linux kernel modules including device 
drivers, file system modules, etc

kmemcheck, kmemleak
-------------------
Linux Kernel debugging features for detecting memory issues

Smatch
------
A static analysis tool for C

Coverity
--------
Provides static analysis tools for C, C++, and other languages (requires 
license, Red Hat has one)

Coccinelle
----------
A tool for matching and fixing source code for C, C++, and other languages

Clang
-----
Static analysis tool for C/C++

Metasploit
----------
Used for identifying security issues. It includes many capabilities, 
including fuzzer support

Trinity
-------
A Linux system call fuzzer

fsfuzzer
--------
File system fuzzer

scapy
-----
Network packet fuzzer

-- 
Regards,
Corey Bryant
