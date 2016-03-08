Reply-To: kernel-hardening@lists.openwall.com
References: <1457470075-4586-1-git-send-email-sbauer@eng.utah.edu>
 <CALCETrVLyg3CJHoFORnmJ+_0WirKck=unBQ8Zu2JUd+WhF6C5g@mail.gmail.com>
From: Scotty Bauer <sbauer@eng.utah.edu>
Message-ID: <56DF48EF.2080305@eng.utah.edu>
Date: Tue, 8 Mar 2016 14:49:35 -0700
MIME-Version: 1.0
In-Reply-To: <CALCETrVLyg3CJHoFORnmJ+_0WirKck=unBQ8Zu2JUd+WhF6C5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 1/3] SROP Mitigation: Architecture independent code for
 signal cookies
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>, wmealing@redhat.com, Andi Kleen <ak@linux.intel.com>, Abhiram Balasubramanian <abhiram@cs.utah.edu>
List-ID: <kernel-hardening.lists.openwall.com>



On 03/08/2016 01:58 PM, Andy Lutomirski wrote:
> On Tue, Mar 8, 2016 at 12:47 PM, Scott Bauer <sbauer@eng.utah.edu> wrote:
>> This patch adds a per-process secret to the task struct which
>> will be used during signal delivery and during a sigreturn.
>> Also, logic is added in signal.c to generate, place, extract,
>> clear and verify the signal cookie.
>>
> 
> Potentially silly question: it's been a while since I read the SROP
> paper, but would the technique be effectively mitigated if sigreturn
> were to zero out the whole signal frame before returning to user mode?
> 

I don't know if I fully understand your question, but I'll respond anyway.

SROP is possible because the kernel doesn't know whether or not the
incoming sigreturn syscall is in response from a legitimate signal that
the kernel had previously delivered and the program handled. So essentially
these patches are an attempt to give the kernel a way to verify whether or 
not the the incoming sigreturn is a valid response or a exploit trying to
hijack control of the user program.

So no, zeroing out the frame wouldn't do much because if I understand your
question correctly once we call sigreturn the kernel is going to hand off
control to wherever the sigframe tells it to so I don't think zeroing would
do much.

The reason why I zero out the cookie is so if there is a stack leak bug or 
something along those lines an attacker couldnt leak the cookie and try and
derive what the per-process kernel secret is.

Hope that clarifies!
