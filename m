Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160415085854.GJ15182@e104818-lin.cambridge.arm.com>
References: <CAGXu5jJ+++wTLk3zV8M6D-aPDnbejw9qOXcznqLRUySsYDiiaQ@mail.gmail.com>
	<20160415085854.GJ15182@e104818-lin.cambridge.arm.com>
Date: Wed, 20 Apr 2016 15:59:54 -0700
Message-ID: <CAGXu5jJSYHMdxb6=N7QDuPMTMyDLv4MHoxTnHDDWJDX-MJ-2bQ@mail.gmail.com>
From: Kees Cook <keescook@google.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: ARMv8.0 PAN emulation
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 15, 2016 at 1:58 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> Hi Kees,
>
> On Wed, Apr 13, 2016 at 08:34:31AM -0700, Kees Cook wrote:
>> I was curious about where PAN emulation for ARMv8.0 stood?
>
> I guess the question is with regards to the arm64 kernel port.

Yeah, in non-LPAE mode, we're covered by Domains, IIUC.

>> You'd mentioned[1] that it might be possible to rework the TTBR0 patch
>> to do what's needed. Is there anyone that has cycles to work on it?
>
> Unfortunately, not. I can put it on our to-do list but the backlog is
> pretty large already, so I can't realistically state an ETA.

Okay, no worries. I'll add this to my list of "things we need someone
to work on". :)

>> Also, did you ever get an answer about the lowmem boundary?
>
> No but I looked through the arm32 kernel and couldn't find any
> guarantees. IIRC, we used to have such assumption in the past until we
> got the TI Keystone platform with RAM being relocated above 4GB (after
> the initial boot code).

Okay, good to know.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
