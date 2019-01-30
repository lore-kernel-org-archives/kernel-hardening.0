MIME-Version: 1.0
References: <CAG48ez0QRmU9fGV3x7nceGqBGADNTb66MnG4PW_xu+xnGUqg=g@mail.gmail.com>
 <20190130182157.GP18558@fuggles.cambridge.arm.com>
In-Reply-To: <20190130182157.GP18558@fuggles.cambridge.arm.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 30 Jan 2019 20:34:52 +0100
Message-ID: <CAG48ez2FMfyagDedETV54sFEit_mJy00iqBFsNngyeT=g=a4PA@mail.gmail.com>
Subject: Re: ARM64 suggestion: reduce the compat address limit (currently 0x100000000)?
Content-Type: text/plain; charset="UTF-8"
To: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 30, 2019 at 7:22 PM Will Deacon <will.deacon@arm.com> wrote:
> On Wed, Jan 30, 2019 at 05:32:00PM +0100, Jann Horn wrote:
> > At the moment, compat tasks running on ARM64 can allocate memory up to
> > 0x100000000 (TASK_SIZE_32). Testing on an Android device (with an
> > admittedly somewhat old kernel):
>
> [...]
>
> > ffff1000-100000000 rw-p 00000000 00:00 0
> >
> > This means that mmap() allocations do not adhere to section 6.5.8 of
> > C99 ("If the
> > expression P points to an element of an array object and the
> > expression Q points to the
> > last element of the same array object, the pointer expression Q+1
> > compares greater than
> > P.") if you treat mmap() allocations as returning an array.
>
> Oh, good point.
>
> > In practice, I've also seen code that does things like computing a
> > pointer that is out of bounds by a few bytes and then comparing it
> > against the end of the array; while this is UB according to C99, it
> > probably makes sense to try to avoid breaking such code.
>
> Agreed, and since the current behaviour isn't something you can portably
> rely on anyway, I think we're ok to change it.
>
> > X86-64's compat code uses the limit 0xFFFFe000 (IA32_PAGE_OFFSET),
> > which I think makes more sense. Would it make sense to do something
> > like the following (untested)?
>
> Can't we just go with 0x100000000 - PAGE_SIZE instead?

Ah, yeah, sounds good. I think x86 probably only chose 0xFFFFe000 to
keep user allocations out of the way for the 32-bit vsyscall page.
