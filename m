MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CALCETrW5-BzBnfStyPQScdkwkCUWDHNmTwiP083G=Yaq-YiWdA@mail.gmail.com>
References: <1488228186-110679-1-git-send-email-keescook@chromium.org>
 <1488228186-110679-2-git-send-email-keescook@chromium.org>
 <1488270174.1747.11.camel@gmail.com> <CAGXu5jKvY1VRxBk_F9omixEBhaSTE18tfRWNcPUKhFk303v6iw@mail.gmail.com>
 <20170301104337.GA28874@leverpostej> <CAGXu5jKTunStRbQ0FpuZpE5bXkmbv0wPmHYqJB2HNxnOzUTvXw@mail.gmail.com>
 <CALCETrW21Hx1NiMSo7wu8o3c0TH4WUN_pMx20ZPH_AgwxKJRJw@mail.gmail.com>
 <20170302111920.GB19632@leverpostej> <CALCETrW5-BzBnfStyPQScdkwkCUWDHNmTwiP083G=Yaq-YiWdA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 2 Mar 2017 11:48:39 -0800
Message-ID: <CAGXu5jK99nC42iea9Uq_Z_0zTkrzz0CnwAjokVr+aNE6f9xBGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH 1/8] Introduce rare_write() infrastructure
To: Andy Lutomirski <luto@amacapital.net>
Cc: Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andy Lutomirski <luto@kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 2, 2017 at 8:33 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Thu, Mar 2, 2017 at 3:19 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>> On Wed, Mar 01, 2017 at 01:00:05PM -0800, Andy Lutomirski wrote:
>>> On Wed, Mar 1, 2017 at 12:13 PM, Kees Cook <keescook@chromium.org> wrote:
>>> > On Wed, Mar 1, 2017 at 2:43 AM, Mark Rutland <mark.rutland@arm.com> wrote:
>>> Now a generic implementation could work by allocating a percpu
>>> mm_struct that contains a single giant VMA.  __arch_rare_write_begin()
>>> switches to that mm.  __arch_rare_write pokes some PTEs into the mm
>>> and calls copy_to_user().  __arch_rare_write_end() switches back to
>>> the original mm.  An x86 implementation could just fiddle with CR0.WP.
>>
>> I'd expected that we'd know where the write_rarely data was up-front, so
>> we could set up the mapping statically, and just map it in at map/begin,
>> but otherwise this sounds like what I had in mind.
>>
>
> Duh.  That works too and would be considerably simpler :)

It may be slightly complicated by needing to track the module .rodata
areas, but ultimately, yeah, it seems like that could work.

-Kees

-- 
Kees Cook
Pixel Security
