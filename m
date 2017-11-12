References: <c6603960-c155-8f9f-6458-38e9ba6d4bdd@marcan.st>
 <CALCETrXhUdMNfC0yBah39Z=xWVe3Fix-qF922gJjqzTO1B7TSA@mail.gmail.com>
 <06a4b0b4-4b36-91b6-d146-9fc1300b785f@marcan.st>
 <a4f2bc2f-4d90-85fe-c0cc-d0d31551e933@marcan.st>
 <CALCETrVd-f-N=O6QmtdzS7oSVkXpsJhxH+=9+0fvfFmy5Cz3WQ@mail.gmail.com>
 <6dc150cb-13df-65d8-cb6e-0a522c13ae11@marcan.st>
 <CALCETrV-Q817-woi=2GqP4t46yTHF+p301C6ObFn2NDXeqfukw@mail.gmail.com>
From: Hector Martin 'marcan' <marcan@marcan.st>
Message-ID: <720b01a7-05bc-22d8-fdb1-1d67a0e18b54@marcan.st>
Date: Sun, 12 Nov 2017 13:39:44 +0900
MIME-Version: 1.0
In-Reply-To: <CALCETrV-Q817-woi=2GqP4t46yTHF+p301C6ObFn2NDXeqfukw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Re: vDSO maximum stack usage, stack probes,
 and -fstack-check
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-11-12 13:21, Andy Lutomirski wrote:
>> Only because Go is not C and is not compiled like this. If all the code
>> is GCC-compiled C code and built with -fstack-check, it should always
>> probe stack pages in order except for potentially the second page in the
>> stack, which may be touched after the third page (but hopefully your
>> stack is at least two pages long to begin with).
> 
> If you're generating code to improve stack overflow, assuming that you
> have at least two pages left seems like an *awful* assumption to make.

If all the code is compiled with the option, then it guarantees you have
at least two pages left, as long as you have at least two pages when the
program/thread starts.

> Gentoo Hardened should seriously consider turning it back off.  Do you
> happen to know what exactly Gentoo does to cause the vdso to get build
> with -fstack-check?  I'll write a patch to either fail the build or to
> force it off.

So you're saying Gentoo Hardened should turn off an exploit mitigation
that, though imperfect, works in the vast majority of cases and seems to
have caused a grand total of one [1] bug in a package so far (two if you
count the one I found)? That seems completely silly to me. I'm sure once
GCC 8 is out with dedicated stack clash protection they'll switch to
that, but in the meantime -fstack-check seems like a perfectly
reasonable idea.

Anyway, they just add it to the default specs for gcc. You can turn it
back off with -fstack-check=no.

You still haven't addressed the important question, though: should vDSO
be *documented* to consume a certain maximum amount of stack space? If
not, this whole thing is pointless since vDSO would be fine as it is. If
yes, then -fstack-check=no isn't the only thing you have to worry about;
more options to limit stack frame size, and perhaps code changes to
inline everything, might be appropriate.

[1] https://bugs.gentoo.org/637152

-- 
Hector Martin "marcan" (marcan@marcan.st)
Public Key: https://mrcn.st/pub
