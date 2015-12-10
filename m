Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1449770155.8579.2.camel@gmail.com>
References: <20151209172101.GA70633@davidb.org>
	<CAGXu5j+0oBHdS7vTQp_0ubuwvUftosYZCx8RJPXh7v7eYQncEQ@mail.gmail.com>
	<1449770155.8579.2.camel@gmail.com>
Date: Thu, 10 Dec 2015 10:42:27 -0800
Message-ID: <CAGXu5jK7LcS9M4NBZr3q8RVQss6GKQ-ifxhOTCMTAGZv3hF02A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Self Introduction
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

I've put the matrix up on the wiki here:

http://kernsec.org/wiki/index.php/Exploit_Methods/Userspace_data_usage

On Thu, Dec 10, 2015 at 9:55 AM, Daniel Micay <danielmicay@gmail.com> wrote:
>> ARMv8 64-bit: ??
>
> The worst case scenario would be doing something like the x86_64 UDEREF.
>
>> x86 pre-late-Broadwell: nothing upstream (though UDEREF in PaX exists)
>
> It's worth noting that there's the pre-PCID implementation (slow and
> vulnerable to races) and then two choices of better implementations when
> PCID is available. You probably know that already, but it's not obvious
> to everyone else.

Yeah. PCID was Sandybridge and later?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
