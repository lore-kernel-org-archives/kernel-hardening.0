References: <20170504142435.10175-1-danielmicay@gmail.com>
 <20170508175723.448CCAC043@b01ledav006.gho.pok.ibm.com>
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Date: Tue, 9 May 2017 16:24:05 +1000
MIME-Version: 1.0
In-Reply-To: <20170508175723.448CCAC043@b01ledav006.gho.pok.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <fef51372-8c0c-0a9d-7e33-b4862f70885b@au1.ibm.com>
Subject: Re: [kernel-hardening] [PATCH] add the option of fortified string.h
 functions
To: Daniel Axtens <dja@axtens.net>, Daniel Micay <danielmicay@gmail.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linuxppc-dev@lists.ozlabs.org
List-ID: <kernel-hardening.lists.openwall.com>

On 09/05/17 03:57, Daniel Axtens wrote:
> (ppc people: this does some compile and run time bounds checking on
> string functions. It's cool - currently it picks up a lot of random
> things so it will require some more work across the tree, but hopefully
> it will eventually hit mainline.)

Ooh, nice!

>
> I've tested this on ppc with pseries_le_defconfig.
>
> I needed a couple of the fixes from github
> (https://github.com/thestinger/linux-hardened/commits/4.11) in order to
> build, specifically
> https://github.com/thestinger/linux-hardened/commit/c65d6a6f309b06703584a23ac2b2bda4bb363143
> https://github.com/thestinger/linux-hardened/commit/adcec4756574a8c7f7cb5b6fa51ebeaeeae71aae
>
> Once those were added, I needed to disable fortification in prom_init.c,
> as we apparently can't have new symbols there. (I don't understand that
> file so I haven't dug into it.)
>
> We also have problems with the feature fixup tests leading to a panic on
> boot. It relates to getting what I think are asm labels(?) and how we
> address them. I have just disabled fortify here for now; I think the
> code could be rewritten to take the labels as unsigned char *, but I
> haven't dug into it.
>
> With the following fixups, I can boot a LE buildroot initrd (per
> https://github.com/linuxppc/linux/wiki/Booting-with-Qemu). Sadly I don't
> have access to real hardware any more, so I can't say anything more than
> that. (ajd - perhaps relevant to your interests?)

I'll test it baremetal when I get the chance, and I'll see if I can 
investigate the issues you've raised.

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
