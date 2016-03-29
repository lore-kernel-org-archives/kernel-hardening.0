Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <56FAF571.3040802@eng.utah.edu>
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
 <CALCETrUxfPBawXNvKZgOnxhkaesw-b4PqCFUZbkRdaaqpjqnPQ@mail.gmail.com> <56FAF571.3040802@eng.utah.edu>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 29 Mar 2016 14:38:36 -0700
Message-ID: <CALCETrWeLp1FX3Fz2z-kJezhPXKjvZHEhBH3guijeCgXdUunng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 0/4] SROP Mitigation: Sigreturn Cookies
To: Scotty Bauer <sbauer@eng.utah.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, wmealing@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 29, 2016 at 2:36 PM, Scotty Bauer <sbauer@eng.utah.edu> wrote:
>
>
> On 03/29/2016 03:29 PM, Andy Lutomirski wrote:
>> On Tue, Mar 29, 2016 at 12:53 PM, Scott Bauer <sbauer@eng.utah.edu> wrote:
>>> Sigreturn-oriented programming is a new attack vector in userland
>>> where an attacker crafts a fake signal frame on the stack and calls
>>> sigreturn. The kernel will extract the fake signal frame, which
>>> contains attacker controlled "saved" registers. The kernel will then
>>> transfer control to the attacker controlled userland instruction pointer.
>>>
>>> To prevent SROP attacks the kernel needs to know or be able to dervive
>>> whether a sigreturn it is processing is in response to a legitimate
>>> signal the kernel previously delivered.
>>>
>>> Further information and test code can be found in Documentation/security
>>> and this excellent article:
>>> http://lwn.net/Articles/676803/
>>>
>>> These patches implement the necessary changes to generate a cookie
>>> which will be placed above signal frame upon signal delivery to userland.
>>> The cookie is generated using a per-process random value xor'd with
>>> the address where the cookie will be stored on the stack.
>>>
>>> Upon a sigreturn the kernel will extract the cookie from userland,
>>> recalculate what the original cookie should be and verify that the two
>>> do not differ. If the two differ the kernel will terminate the process
>>> with a SIGSEGV.
>>>
>>> This prevents SROP by adding a value that the attacker cannot guess,
>>> but the kernel can verify. Therefore an attacker cannot use sigreturn as
>>> a method to control the flow of a process.
>>>
>>
>> Has anyone verified that this doesn't break CRIU cross-machine (or
>> cross-boot) migration and that this doesn't break dosemu?  You're
>> changing the ABI here.
>>
>
> I haven't yet I'll do that to verify it breaks -- I'm pretty sure under some
> conditions it will break CRIU. That's why we added the sysctl to turn it off.
> Should I have mentioned this in the main commit that it possibly breaks CRIU/DOSEMU?
> I went ahead and added that to the Documentation.
>
>

Then there's an unanswered question: is this patch acceptable given
that it's an ABI break?  Security fixes are sometimes an exception to
the "no ABI breaks" rule, but it's by no means an automatic exception.

--Andy
