From: Hector Martin 'marcan' <marcan@marcan.st>
References: <c6603960-c155-8f9f-6458-38e9ba6d4bdd@marcan.st>
 <CALCETrXhUdMNfC0yBah39Z=xWVe3Fix-qF922gJjqzTO1B7TSA@mail.gmail.com>
 <06a4b0b4-4b36-91b6-d146-9fc1300b785f@marcan.st>
Message-ID: <a4f2bc2f-4d90-85fe-c0cc-d0d31551e933@marcan.st>
Date: Sat, 11 Nov 2017 01:36:47 +0900
MIME-Version: 1.0
In-Reply-To: <06a4b0b4-4b36-91b6-d146-9fc1300b785f@marcan.st>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Re: vDSO maximum stack usage, stack probes,
 and -fstack-check
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-11-11 01:02, Hector Martin 'marcan' wrote:
> Not entirely sure what's going on here.

Actually, if you think about it, it doesn't matter that it skips the
first page, since it's probing one page more. That just means the caller
will have probed the previous page. So ultimately you're just probing
ahead of where you need to, but that should be OK.

-- 
Hector Martin "marcan" (marcan@marcan.st)
Public Key: https://mrcn.st/pub
