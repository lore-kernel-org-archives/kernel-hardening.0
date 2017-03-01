MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CALCETrW21Hx1NiMSo7wu8o3c0TH4WUN_pMx20ZPH_AgwxKJRJw@mail.gmail.com>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-2-git-send-email-keescook@chromium.org>
 <1488270174.1747.11.camel@gmail.com> <CAGXu5jKvY1VRxBk_F9omixEBhaSTE18tfRWNcPUKhFk303v6iw@mail.gmail.com>
 <20170301104337.GA28874@leverpostej> <CAGXu5jKTunStRbQ0FpuZpE5bXkmbv0wPmHYqJB2HNxnOzUTvXw@mail.gmail.com>
 <CALCETrW21Hx1NiMSo7wu8o3c0TH4WUN_pMx20ZPH_AgwxKJRJw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 1 Mar 2017 15:14:06 -0800
Message-ID: <CAGXu5j+4CFp9ceGDuCttxNm849o4Wd1pC2Ngm+y+GH4VmmcGQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH 1/8] Introduce rare_write() infrastructure
To: Andy Lutomirski <luto@amacapital.net>
Cc: Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 1, 2017 at 1:00 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Mar 1, 2017 at 12:13 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Mar 1, 2017 at 2:43 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>>> My objection to that was that we can't implement CPU-local full
>>> disabling of RO protection for the kernel page tables on some
>>> architectures and configurations, e.g. arm64, or 32-bit arm with LPAE.
>>
>> The CPU-local is a pretty important requirement... Hrmm
>
> Why?  Presumably we'd do pretty well if we made an alias somewhere at
> a random address and got rid of it quickly.

I'd much rather avoid any risk like this, just so the protection could
be safely reasoned about...

>>> The RW alias write_write(var, val) approach only relies on what arches
>>> already have to implement for userspace to work, so if we can figure out
>>> how to make that work API-wise, we can probably implement that
>>> generically with switch_mm() and {get,put}_user().
>>
>> With a third mm? I maybe misunderstood what you meant about userspace...
>
> I think I'd like this series a lot better if the arch hooks were
> designed in such a way that a generic implementation could be backed
> by kmap, use_mm, or similar.  This would *require* that the arch hooks
> be able to return a different address.  Also, I see no reason that the
> list manipulation needs to be particularly special.  If the arch hook

Yeah, there's nothing special about the list manipulation except that
it already dropped the const casts, so adding them back is trivial.

> sets up an alias, couldn't the generic code just call it twice.
>
> So here's a new proposal for how the hooks could look:
>
> void __arch_rare_write_begin(void);
> void *__arch_rare_write_map(void *addr, size_t len);
> void *__arch_rare_write_unmap(void *addr, size_t len);
> void __arch_rare_write_end(void);
>
> or an even simpler variant:
>
> void __arch_rare_write_begin(void);
> void __arch_rare_write(void *dest, const void *source, size_t len);
> void __arch_rare_write_end(void);

Based on your and Mark's feedback from last year, I'd probably create
rare_write() as a macro that examines types and calls some other the
macro that has the above parameters but enforces the
builtin_const-ness of "len", before ultimately resolving to
__arch_rare_write() as above, just to be as type-safe as we can
manage...

#define __rare_write_n(dst, src, len)    ({ \
    BUILD_BUG(!builtin_const(len));      \
    __arch_rare_write((dst), (src), (len);  \
})
#define __rare_write(var, val)     __rare_write_n(&(var), &(val), sizeof(var))

> Now a generic implementation could work by allocating a percpu
> mm_struct that contains a single giant VMA.  __arch_rare_write_begin()
> switches to that mm.  __arch_rare_write pokes some PTEs into the mm
> and calls copy_to_user().  __arch_rare_write_end() switches back to
> the original mm.  An x86 implementation could just fiddle with CR0.WP.

If that works for Russell and Mark, cool by me. :) I'll reorganize my
series with the new API...

-Kees

-- 
Kees Cook
Pixel Security
