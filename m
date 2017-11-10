MIME-Version: 1.0
In-Reply-To: <a4f2bc2f-4d90-85fe-c0cc-d0d31551e933@marcan.st>
References: <c6603960-c155-8f9f-6458-38e9ba6d4bdd@marcan.st>
 <CALCETrXhUdMNfC0yBah39Z=xWVe3Fix-qF922gJjqzTO1B7TSA@mail.gmail.com>
 <06a4b0b4-4b36-91b6-d146-9fc1300b785f@marcan.st> <a4f2bc2f-4d90-85fe-c0cc-d0d31551e933@marcan.st>
From: Andy Lutomirski <luto@kernel.org>
Date: Fri, 10 Nov 2017 14:04:13 -0800
Message-ID: <CALCETrVd-f-N=O6QmtdzS7oSVkXpsJhxH+=9+0fvfFmy5Cz3WQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: vDSO maximum stack usage, stack probes,
 and -fstack-check
To: Hector Martin 'marcan' <marcan@marcan.st>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

> On Nov 10, 2017, at 8:36 AM, Hector Martin 'marcan' <marcan@marcan.st> wrote:
>
>> On 2017-11-11 01:02, Hector Martin 'marcan' wrote:
>> Not entirely sure what's going on here.
>
> Actually, if you think about it, it doesn't matter that it skips the
> first page, since it's probing one page more. That just means the caller
> will have probed the previous page. So ultimately you're just probing
> ahead of where you need to, but that should be OK.
>

The whole point is to touch the stack pages in order.  Also, I see no
guarantee that the function would touch the intermediate page before
clobbering the probed page.  You're seeing exactly that behavior, in
fact.

> --
> Hector Martin "marcan" (marcan@marcan.st)
> Public Key: https://mrcn.st/pub
