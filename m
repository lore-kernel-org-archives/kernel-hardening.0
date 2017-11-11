References: <c6603960-c155-8f9f-6458-38e9ba6d4bdd@marcan.st>
 <CALCETrXhUdMNfC0yBah39Z=xWVe3Fix-qF922gJjqzTO1B7TSA@mail.gmail.com>
 <06a4b0b4-4b36-91b6-d146-9fc1300b785f@marcan.st>
 <a4f2bc2f-4d90-85fe-c0cc-d0d31551e933@marcan.st>
 <CALCETrVd-f-N=O6QmtdzS7oSVkXpsJhxH+=9+0fvfFmy5Cz3WQ@mail.gmail.com>
From: Hector Martin 'marcan' <marcan@marcan.st>
Message-ID: <6dc150cb-13df-65d8-cb6e-0a522c13ae11@marcan.st>
Date: Sat, 11 Nov 2017 14:16:48 +0900
MIME-Version: 1.0
In-Reply-To: <CALCETrVd-f-N=O6QmtdzS7oSVkXpsJhxH+=9+0fvfFmy5Cz3WQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Re: vDSO maximum stack usage, stack probes,
 and -fstack-check
To: Andy Lutomirski <luto@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-11-11 07:04, Andy Lutomirski wrote:
>> On Nov 10, 2017, at 8:36 AM, Hector Martin 'marcan' <marcan@marcan.st> wrote:
>>
>>> On 2017-11-11 01:02, Hector Martin 'marcan' wrote:
>>> Not entirely sure what's going on here.
>>
>> Actually, if you think about it, it doesn't matter that it skips the
>> first page, since it's probing one page more. That just means the caller
>> will have probed the previous page. So ultimately you're just probing
>> ahead of where you need to, but that should be OK.
>>
> 
> The whole point is to touch the stack pages in order.  Also, I see no
> guarantee that the function would touch the intermediate page before
> clobbering the probed page.  You're seeing exactly that behavior, in
> fact.

Only because Go is not C and is not compiled like this. If all the code
is GCC-compiled C code and built with -fstack-check, it should always
probe stack pages in order except for potentially the second page in the
stack, which may be touched after the third page (but hopefully your
stack is at least two pages long to begin with).

AIUI -fstack-check was not intended for stack clash protection (the
latter isn't even in a GCC release yet), but in most circumstances it
seems to me like it's an effective mitigation if all code is compiled
with it. Qualys mentioned it as such in their advisory. This is probably
why Gentoo Hardened enables it by default globally in their toolchain.

-- 
Hector Martin "marcan" (marcan@marcan.st)
Public Key: https://mrcn.st/pub
