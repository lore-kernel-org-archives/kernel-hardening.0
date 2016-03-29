Reply-To: kernel-hardening@lists.openwall.com
References: <1459281207-24377-1-git-send-email-sbauer@eng.utah.edu>
 <CA+55aFy2bac+-j6wWZ4D2UeA=h6rrdFL+B2Kns+ws6wGkVJzmg@mail.gmail.com>
 <56FB0B88.2020306@eng.utah.edu>
 <CA+55aFx2trnk2xqdL7u-RG7vi6GXp+bZ1y3bqTSDNY101rfAZA@mail.gmail.com>
From: Scotty Bauer <sbauer@eng.utah.edu>
Message-ID: <56FB10E8.1060504@eng.utah.edu>
Date: Tue, 29 Mar 2016 17:34:00 -0600
MIME-Version: 1.0
In-Reply-To: <CA+55aFx2trnk2xqdL7u-RG7vi6GXp+bZ1y3bqTSDNY101rfAZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v4 0/4] SROP Mitigation: Sigreturn Cookies
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, the arch/x86 maintainers <x86@kernel.org>, Andi Kleen <ak@linux.intel.com>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, wmealing@redhat.com
List-ID: <kernel-hardening.lists.openwall.com>



On 03/29/2016 05:25 PM, Linus Torvalds wrote:
> On Tue, Mar 29, 2016 at 6:11 PM, Scotty Bauer <sbauer@eng.utah.edu> wrote:
>>
>> Yeah I had toyed with using hashes, I used hash_64 not md5 which is like 14
>> extra instructions or something.
> 
> That sounds fine. Anything that requires enough code to undo that it
> kind of defeats the purpose of a SROP should be enough. It's not about
> encryption, I'd just think that if you can force the buffer overflow
> while already in a signal handler, you'd want something that is at
> least *slightly* harder to defeat than a single "xor" instruction.
> 
>> It's not hard to implement So I can try it. When you say an extra hardening
>> mode do you mean hide it behind a sysctl or some sort of compile time CONFIG?
> 
> Since there already is a sysctl, I'd just assume that.
> 
> The important part is that the *default* value for that sysctl can't
> break real applications. I don't really count CRIU as a real app, if
> only because once you start doing checkpoint-restore you are going to
> do some amount of system maintenance anyway, so somebody doing CRIU is
> kind of expected to have a certain amount of system expertise, I would
> say.
> 
> But dosemu - or Wine - is very much something that "normal people" run
> - people who we do *not* expect to have to know about new sysctl's
> etc. They already have one (mmap at zero), but that is very directly
> related to what vm86 mode and Wine does, and people have had time to
> learn about it. Let's not add another.
> 
> So testing dosemu and wine would be good. I wonder what else has shown
> issues with signal stack layout changes. Debuggers and some JIT
> engines, I suspect.
> 
>               Linus
> 


Alright I'll test Wine/Mono, Dosemu, some random languages/debuggers see if
there is anything that breaks.

Thanks.
