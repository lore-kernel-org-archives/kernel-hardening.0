Reply-To: kernel-hardening@lists.openwall.com
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
 <CALCETrUxfPBawXNvKZgOnxhkaesw-b4PqCFUZbkRdaaqpjqnPQ@mail.gmail.com>
 <56FAF571.3040802@eng.utah.edu>
 <CALCETrWeLp1FX3Fz2z-kJezhPXKjvZHEhBH3guijeCgXdUunng@mail.gmail.com>
 <CA+55aFzY0p5OyTfnajTz2SL9qni=0FyUT7SeqS0CuXnwRPHS5w@mail.gmail.com>
From: Scotty Bauer <sbauer@eng.utah.edu>
Message-ID: <56FB0C65.4020602@eng.utah.edu>
Date: Tue, 29 Mar 2016 17:14:45 -0600
MIME-Version: 1.0
In-Reply-To: <CA+55aFzY0p5OyTfnajTz2SL9qni=0FyUT7SeqS0CuXnwRPHS5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v4 0/4] SROP Mitigation: Sigreturn Cookies
To: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, wmealing@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>



On 03/29/2016 04:34 PM, Linus Torvalds wrote:
> On Tue, Mar 29, 2016 at 4:38 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> Then there's an unanswered question: is this patch acceptable given
>> that it's an ABI break?  Security fixes are sometimes an exception to
>> the "no ABI breaks" rule, but it's by no means an automatic exception.
> 
> So there isn't any "no ABI break" rule - there is only a "does it
> break real applications" rule.
> 
> (This can also be re-stated as: "Talk is cheap", aka "reality trumps
> documentation".
> 
> Documentation is meaningless if it doesn't match reality, and what we
> actually *do* is what matters.
> 
> So the ABI isn't about some theoretical interface documentation, the
> ABI is about what people use and have tested.
> 
> On the one hand, that means that that our ABI is _stricter_ than any
> documentatiuon, and that "but we can make this change that breaks app
> XYZ, because XYZ is depending on undocumented behavior" is not an
> acceptable excuse.
> 
> But on the other hand it *also* means that since the ABI is about real
> programs, not theoretical issues, we can also change things as long as
> we don't actually break anything that people can notice and depend
> on).
> 
> And while *acute* security holes will be fixed regardless of ABI
> issues, something like this that is only hardening rather than fixing
> a particular security hole, really needs to not break any
> applications.
> 
> Because if it does break anything, it needs to be turned off by
> default. That's a hard rule. And since that would be largely defeating
> the whole point o fthe series, I think we really need to have made
> sure nothing breaks before a patch series like this can be accepted.
> 
> That said, if this is done right, I don't think it will break
> anything. CRIU may indeed be a special case, but CRIU isn't really a
> normal application, and the CRIU people may need to turn this off
> explicitly, if it does break.
> 
> But yes, dosemu needs to be tested, and needs to just continue
> working. But does dosemu actually create a signal stack, as opposed to
> just playing with one that has been created for it? I thought it was
> just the latter case, which should be ok even with a magic cookie in
> there.
> 
>                    Linus
> 


For what it's worth this series is breaking CRIU, I just tested:

root@node0:/mnt/criu# criu restore -vvvv -o restore.log --shell-job
root@node0:/mnt/criu# tail -3 /var/log/syslog
Mar 29 17:12:08 localhost kernel: [ 3554.625535] Possible exploit attempt or buggy program!
Mar 29 17:12:08 localhost kernel: [ 3554.625535] If you believe this is an error you can disable SROP  Protection by #echo 1 > /proc/sys/kernel/disable-srop-protection
Mar 29 17:12:08 localhost kernel: [ 3554.625545] test_[25305] bad frame in rt_sigreturn frame:000000000001e540 ip:7f561542cf20 sp:7ffe004ecfd8 orax:ffffffffffffffff in libc-2.19.so[7f561536c000+1bb0]
root@node0:/mnt/criu# echo 1 > /proc/sys/kernel/disable-srop-protection 
root@node0:/mnt/criu# criu restore -vvvv -o restore.log --shell-job
slept for one second
slept for one second
slept for one second
slept for one second
root@node0:/mnt/criu# 


I'm working on getting dosemu up and running-- are there any other applications
off the top of your head that I should be testing with?
