From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <87pofjqlj3.fsf@possimpible.ozlabs.ibm.com>
References: <20170504142435.10175-1-danielmicay@gmail.com> <87pofjqlj3.fsf@possimpible.ozlabs.ibm.com>
Date: Wed, 10 May 2017 22:00:18 +1000
Message-ID: <877f1okjl9.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] [PATCH] add the option of fortified string.h functions
To: Daniel Axtens <dja@axtens.net>, Daniel Micay <danielmicay@gmail.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, linuxppc-dev@lists.ozlabs.org
Cc: andrew.donnellan@au1.ibm.com
List-ID: <kernel-hardening.lists.openwall.com>

Daniel Axtens <dja@axtens.net> writes:

> Hi Daniel and ppc people,
>
> (ppc people: this does some compile and run time bounds checking on
> string functions. It's cool - currently it picks up a lot of random
> things so it will require some more work across the tree, but hopefully
> it will eventually hit mainline.)

Cool! 

> Once those were added, I needed to disable fortification in prom_init.c,
> as we apparently can't have new symbols there. (I don't understand that
> file so I haven't dug into it.)

We can refer to new symbols from there, we just have a script to check
we don't refer to anything new inadvertently.

prom_init() is sort of a shim that runs before the kernel, except it's
linked with the kernel, but ideally wouldn't be, but we never bothered
actually making it separate. O_o

> We also have problems with the feature fixup tests leading to a panic on
> boot. It relates to getting what I think are asm labels(?) and how we
> address them. I have just disabled fortify here for now; I think the
> code could be rewritten to take the labels as unsigned char *, but I
> haven't dug into it.

OK, yeah it's using asm labels to compare the patched code vs the
expected result. Can probably be fixed by making them char[] like we do
for other things like __start_interrupts etc.

cheers
