MIME-Version: 1.0
In-Reply-To: <20170302111920.GB19632@leverpostej>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-2-git-send-email-keescook@chromium.org>
 <1488270174.1747.11.camel@gmail.com> <CAGXu5jKvY1VRxBk_F9omixEBhaSTE18tfRWNcPUKhFk303v6iw@mail.gmail.com>
 <20170301104337.GA28874@leverpostej> <CAGXu5jKTunStRbQ0FpuZpE5bXkmbv0wPmHYqJB2HNxnOzUTvXw@mail.gmail.com>
 <CALCETrW21Hx1NiMSo7wu8o3c0TH4WUN_pMx20ZPH_AgwxKJRJw@mail.gmail.com> <20170302111920.GB19632@leverpostej>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 2 Mar 2017 08:33:00 -0800
Message-ID: <CALCETrW5-BzBnfStyPQScdkwkCUWDHNmTwiP083G=Yaq-YiWdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH 1/8] Introduce rare_write() infrastructure
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 2, 2017 at 3:19 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Wed, Mar 01, 2017 at 01:00:05PM -0800, Andy Lutomirski wrote:
>> On Wed, Mar 1, 2017 at 12:13 PM, Kees Cook <keescook@chromium.org> wrote:
>> > On Wed, Mar 1, 2017 at 2:43 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>> >> The RW alias write_write(var, val) approach only relies on what arches
>> >> already have to implement for userspace to work, so if we can figure out
>> >> how to make that work API-wise, we can probably implement that
>> >> generically with switch_mm() and {get,put}_user().
>> >
>> > With a third mm? I maybe misunderstood what you meant about userspace...
>>
>> I think I'd like this series a lot better if the arch hooks were
>> designed in such a way that a generic implementation could be backed
>> by kmap, use_mm, or similar.  This would *require* that the arch hooks
>> be able to return a different address.  Also, I see no reason that the
>> list manipulation needs to be particularly special.  If the arch hook
>> sets up an alias, couldn't the generic code just call it twice.
>
> I completely agree.
>
> There's some fun to be had with switch_mm/use_mm (e.g. with arm64's
> TTBR0_SW_PAN), but I think we can solve that generically.
>
>> So here's a new proposal for how the hooks could look:
>
>> void __arch_rare_write_begin(void);
>> void __arch_rare_write(void *dest, const void *source, size_t len);
>> void __arch_rare_write_end(void);
>
> I think we're on the same page, API-wise.
>
> Modulo naming, and the len argument to the write function, this is
> exactly the same as my original proposal.
>
> I had assumed that we could derive the len argument implicitly from the
> object being assigned to, but it doesn't really matter either way.

I think we can, but I was imagining that this kind of logic would live
in generic code that called __arch_rare_write (or whatever it's
called).

>
>> Now a generic implementation could work by allocating a percpu
>> mm_struct that contains a single giant VMA.  __arch_rare_write_begin()
>> switches to that mm.  __arch_rare_write pokes some PTEs into the mm
>> and calls copy_to_user().  __arch_rare_write_end() switches back to
>> the original mm.  An x86 implementation could just fiddle with CR0.WP.
>
> I'd expected that we'd know where the write_rarely data was up-front, so
> we could set up the mapping statically, and just map it in at map/begin,
> but otherwise this sounds like what I had in mind.
>

Duh.  That works too and would be considerably simpler :)

--Andy
