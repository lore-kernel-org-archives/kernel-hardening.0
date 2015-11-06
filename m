Reply-To: kernel-hardening@lists.openwall.com
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
 <1446816504.8412.35.camel@debian.org>
 <CAGXu5jKkF61CG_Aiv19p24XvJ7yQ-V+J_RBXbvMbw-cWmzDbmQ@mail.gmail.com>
From: Richard Weinberger <richard@nod.at>
Message-ID: <563CF235.7030105@nod.at>
Date: Fri, 6 Nov 2015 19:32:21 +0100
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKkF61CG_Aiv19p24XvJ7yQ-V+J_RBXbvMbw-cWmzDbmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] Kernel Self Protection Project
To: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Solar Designer <solar@openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Ben Hutchings <ben@decadent.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, James Morris <jmorris@namei.org>, Andy Lutomirski <luto@amacapital.net>
List-ID: <kernel-hardening.lists.openwall.com>

Am 06.11.2015 um 19:11 schrieb Kees Cook:
> On Fri, Nov 6, 2015 at 5:28 AM, Yves-Alexis Perez <corsac@debian.org> wrote:
>> On jeu., 2015-11-05 at 12:59 -0800, Kees Cook wrote:
>>> For now, I'm going to focus on taking a look at the PAX_SIZE_OVERFLOW
>>> gcc plugin, which will also get us the gcc plugin infrastructure.
>>> Other people, please speak up on what you'd like to tackle.
>>
>> Hi Kees, and first many thanks for the initiative. That's definitely something
>> of interest for me (both personally and professionally).
>>
>> Something which might also be interesting in kernel self protection is the
>> “active response” found in grsecurity (GRKERNSEC_SEC_KERN_LOCKOUT) and the
>> “deter exploite bruteforcing” (GRKERNSEC_BRUTE), which can help prevent
>> exploitation with repeated attempts.
> 
> I don't want to discourage work on any of this, but for now, I'm
> trying to focus on kernel protections (rather than the userspace
> hardening features). If other people (you?) want to coordinate the
> userspace hardening work, then let's add it to the list, and create a
> separate kernsec.org wiki landing place for it. I think it should be
> organized in the same way, though: discuss a problem, give examples,
> list potential mitigations.
> 
> FWIW, GRKERNSEC_BRUTE was attempted earlier[1], and the technical
> discussion devolved into people thinking that glibc should handle it.
> I totally disagree[2], since not all systems use glibc (Android).
> Bruteforcing protection should be in the kernel: it is the manager of
> processes, full stop.

Thanks for bringing up my patch again.
Given the push back I've received (on and off list) I gave up.
But maybe it is time to try a second time. :-)

> [1] https://lkml.org/lkml/2014/12/24/306
> [2] https://lkml.org/lkml/2015/1/5/732

Thanks,
//richard
