Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <99FC4B6EFCEFD44486C35F4C281DC6731F1DF8B1@ORSMSX107.amr.corp.intel.com>
References: <20151209172101.GA70633@davidb.org>
	<CAGXu5j+0oBHdS7vTQp_0ubuwvUftosYZCx8RJPXh7v7eYQncEQ@mail.gmail.com>
	<1449770155.8579.2.camel@gmail.com>
	<CAGXu5jK7LcS9M4NBZr3q8RVQss6GKQ-ifxhOTCMTAGZv3hF02A@mail.gmail.com>
	<1449774477.8579.4.camel@gmail.com>
	<CAGXu5j+OhUjRZSfCoFZeAY23-rzGDQ_6cU886BNSr3PCzQ60Hw@mail.gmail.com>
	<99FC4B6EFCEFD44486C35F4C281DC6731F1DF8B1@ORSMSX107.amr.corp.intel.com>
Date: Thu, 10 Dec 2015 11:45:35 -0800
Message-ID: <CAGXu5jLU=tbyCm2Jjjj1RshygiFEYMKNtbwPs6p-seCkJ2Ajdw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Self Introduction
To: "Schaufler, Casey" <casey.schaufler@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, PaX Team <pageexec@freemail.hu>, Michael Ellerman <mpe@ellerman.id.au>, Heiko Carstens <heiko.carstens@de.ibm.com>, Ralf Baechle <ralf@linux-mips.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 10, 2015 at 11:38 AM, Schaufler, Casey
<casey.schaufler@intel.com> wrote:
>> -----Original Message-----
>> From: keescook@google.com [mailto:keescook@google.com] On Behalf Of
>> Kees Cook
>> Sent: Thursday, December 10, 2015 11:24 AM
>> To: kernel-hardening@lists.openwall.com
>> Cc: Catalin Marinas <catalin.marinas@arm.com>; PaX Team
>> <pageexec@freemail.hu>; Michael Ellerman <mpe@ellerman.id.au>; Heiko
>> Carstens <heiko.carstens@de.ibm.com>; Ralf Baechle <ralf@linux-mips.org>
>> Subject: Re: [kernel-hardening] Self Introduction
>>
>> On Thu, Dec 10, 2015 at 11:07 AM, Daniel Micay <danielmicay@gmail.com>
>> wrote:
>> >> Yeah. PCID was Sandybridge and later?
>> >
>> > Yeah, that's right. And it defaults to the strong PCID implementation,
>> > but there's also a weaker but significantly faster PCID-based one.
>>
>> Is there anyone from Intel on the list? I would love to see UDEREF
>> ported to upstream on x86 (and the non PCID version too). No one has
>> stepped up to work on it yet.
>
> Yes, we're here. There are a couple things we need to do before making
> commitments on things, including deciding which are the most urgent
> from our perspective. We will be looking at what we want to do with
> UDEREF.

That's great! Thanks for speaking up. Another area that hasn't seen
any traction yet is PAX_USERCOPY. Valdis seems to be MIA, so I'd love
to see someone else take on that chunk of work.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
