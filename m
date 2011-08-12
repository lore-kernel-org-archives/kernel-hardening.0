Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 12 Aug 2011 13:09:40 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110812090940.GA16072@albatros>
References: <20110807110025.GA3778@albatros>
 <20110808173913.GA16028@albatros>
 <20110810095200.GA2377@albatros>
 <20110810130333.GA31122@openwall.com>
 <20110810132715.GA8993@albatros>
 <20110810142609.GA31434@openwall.com>
 <20110810150257.GA12198@albatros>
 <20110810154059.GA31860@openwall.com>
 <20110810162101.GA2833@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810162101.GA2833@albatros>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Minor thing.  ldd (at least from Ubuntu) tries to blindly apply all
existing loaders to the program:

$ LANG=C ldd /bin/bash
/usr/bin/ldd: line 161: /lib/ld-linux.so.2: cannot execute binary file
    linux-vdso.so.1 =>  (0x00007fffbc1ff000)
    libncurses.so.5 => /lib/libncurses.so.5 (0x00007f158eb27000)
    libdl.so.2 => /lib/libdl.so.2 (0x00007f158e923000)
    libc.so.6 => /lib/libc.so.6 (0x00007f158e59f000)
    /lib64/ld-linux-x86-64.so.2 (0x00007f158ed98000)

$ file /bin/bash
/bin/bash: ELF 64-bit LSB executable, x86-64, version 1 (SYSV),
dynamically linked (uses shared libs), for GNU/Linux 2.6.15, stripped
$ readelf -l /bin/bash | grep -A2 INTER
  INTERP         0x0000000000000238 0x0000000000400238 0x0000000000400238
                 0x000000000000001c 0x000000000000001c  R      1
      [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]

ld-linux.so loading fails because of 64 bit ELFs enforcement.

I consider it as a bug of ldd :)

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
