MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1494276637.6144.1.camel@gmail.com>
References: <20170504142435.10175-1-danielmicay@gmail.com> <87pofjqlj3.fsf@possimpible.ozlabs.ibm.com>
 <1494276637.6144.1.camel@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 8 May 2017 14:53:45 -0700
Message-ID: <CAGXu5jLVTFF0vP3+eH3D=x8An+1zYekQywPLQ3=Kcku+ufH_NQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH] add the option of fortified string.h functions
To: Daniel Micay <danielmicay@gmail.com>
Cc: Daniel Axtens <dja@axtens.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 8, 2017 at 1:50 PM, Daniel Micay <danielmicay@gmail.com> wrote:
> On Tue, 2017-05-09 at 03:57 +1000, Daniel Axtens wrote:
>> Hi Daniel and ppc people,
>>
>> (ppc people: this does some compile and run time bounds checking on
>> string functions. It's cool - currently it picks up a lot of random
>> things so it will require some more work across the tree, but
>> hopefully
>> it will eventually hit mainline.)
>>
>> I've tested this on ppc with pseries_le_defconfig.

Yay! Thanks very much!

>>
>> I needed a couple of the fixes from github
>> (https://github.com/thestinger/linux-hardened/commits/4.11) in order
>> to
>> build, specifically
>> https://github.com/thestinger/linux-hardened/commit/c65d6a6f309b067035
>> 84a23ac2b2bda4bb363143
>> https://github.com/thestinger/linux-
>> hardened/commit/adcec4756574a8c7f7cb5b6fa51ebeaeeae71aae
>
> By the way, Kees is working on landing these upstream as proper fixes
> rather than the workarounds I did there. In most cases, it's a matter of
> migrating from memcpy past the end of a constant string to strncpy (to
> make sure that the destination is still fully filled but with zeroes
> instead of arbitrary junk from rodata vs strcpy/strlcpy which won't
> cover that). A few of them are a bit weirder though. I haven't seen any
> false positives yet though, due to sticking to __builtin_object_size(p,
> 0) for now.

FWIW, all the net-dev ones have been applied for -next now.

>> Once those were added, I needed to disable fortification in
>> prom_init.c,
>> as we apparently can't have new symbols there. (I don't understand
>> that
>> file so I haven't dug into it.)
>>
>> We also have problems with the feature fixup tests leading to a panic
>> on
>> boot. It relates to getting what I think are asm labels(?) and how we
>> address them. I have just disabled fortify here for now; I think the
>> code could be rewritten to take the labels as unsigned char *, but I
>> haven't dug into it.
>
> They probably need to be changed to use 'unsigned char foo[]' instead of
>  'char foo' with &foo taken as an address and used as a larger buffer.
> That's undefined and the compiler can assume it's limited to the size of
> the type used to define it which then gets enforced by these fortified
> wrappers rather than just used for optimization (in practice, it won't
> break much without these, but it could).

We'd need something to actually extract the sizes of the asm
functions. Right now, that kind of thing is done in the linker
scripts, but that may be too late.

-Kees

-- 
Kees Cook
Pixel Security
