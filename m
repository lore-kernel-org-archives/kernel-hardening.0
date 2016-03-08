Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <56DF48EF.2080305@eng.utah.edu>
References: <1457470075-4586-1-git-send-email-sbauer@eng.utah.edu>
 <CALCETrVLyg3CJHoFORnmJ+_0WirKck=unBQ8Zu2JUd+WhF6C5g@mail.gmail.com> <56DF48EF.2080305@eng.utah.edu>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 8 Mar 2016 13:57:40 -0800
Message-ID: <CALCETrVf1uSKJh7zENOgHW6et0wed5goU6AfaTB5RSiBhbCfeA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 1/3] SROP Mitigation: Architecture independent code for
 signal cookies
To: Scotty Bauer <sbauer@eng.utah.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>, wmealing@redhat.com, Andi Kleen <ak@linux.intel.com>, Abhiram Balasubramanian <abhiram@cs.utah.edu>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 8, 2016 at 1:49 PM, Scotty Bauer <sbauer@eng.utah.edu> wrote:
>
>
> On 03/08/2016 01:58 PM, Andy Lutomirski wrote:
>> On Tue, Mar 8, 2016 at 12:47 PM, Scott Bauer <sbauer@eng.utah.edu> wrote:
>>> This patch adds a per-process secret to the task struct which
>>> will be used during signal delivery and during a sigreturn.
>>> Also, logic is added in signal.c to generate, place, extract,
>>> clear and verify the signal cookie.
>>>
>>
>> Potentially silly question: it's been a while since I read the SROP
>> paper, but would the technique be effectively mitigated if sigreturn
>> were to zero out the whole signal frame before returning to user mode?
>>
>
> I don't know if I fully understand your question, but I'll respond anyway.
>
> SROP is possible because the kernel doesn't know whether or not the
> incoming sigreturn syscall is in response from a legitimate signal that
> the kernel had previously delivered and the program handled. So essentially
> these patches are an attempt to give the kernel a way to verify whether or
> not the the incoming sigreturn is a valid response or a exploit trying to
> hijack control of the user program.
>

I got that part, but I thought that the interesting SROP bit was using
sigreturn to return back to a frame where you could just repeat the
sigreturn a bunch of times to compute things and do other evil.  I'm
wondering whether zeroing the whole frame would make SROP much less
interesting to an attacker.

--Andy
