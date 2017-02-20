Date: Mon, 20 Feb 2017 12:45:32 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170220124531.GH9003@leverpostej>
References: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
 <1487498660-16600-7-git-send-email-hoeun.ryu@gmail.com>
 <CAKv+Gu9umycZm_UP99ZUifLUBb8MuOZHXgU9nB6XioVMa4eeVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9umycZm_UP99ZUifLUBb8MuOZHXgU9nB6XioVMa4eeVw@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC 7/7] arm64: map seperately rodata sections for
 __ro_mostly_after_init section
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Hoeun Ryu <hoeun.ryu@gmail.com>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Laura Abbott <labbott@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jeremy Linton <jeremy.linton@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 19, 2017 at 11:35:51AM +0000, Ard Biesheuvel wrote:
> On 19 February 2017 at 10:04, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
> > Map rodata sections seperately for the new __ro_mostly_after_init section.
> > Attribute of memory for __ro_mostly_after_init section can be changed later
> > so we need a dedicated vmalloced region for set_memory_rw/ro api.

> While it is correct that you are splitting this into three separate
> segments (otherwise we would not be able to change the permissions
> later without risking splitting to occur), I think this leads to
> unnecessary fragmentation.
> 
> If there is demand for this feature (but you still need to make the
> argument for that), I wonder if it wouldn't be sufficient, and much
> more straightforward, to redefine the __ro_after_init semantics to
> include the kind of subsystem registration and module init context you
> are targeting, and implement some hooks to temporarily lift the
> __ro_after_init r/o permission restrictions in a controlled manner.

>From a look over the series, I think this is just __write_rarely in
disguise. I personally think that we should keep __write_rarely and
__ro_after_init separate, the later being a strictly one-shot affair.

I had some ideas [1] as to how we could implement __write_rarely without
carving up the kernel mapping further (and keeping the RW permissions
local to the thread needing it), but I have not had the time to look
into that further.

Thanks,
Mark.

[1] http://www.openwall.com/lists/kernel-hardening/2016/11/18/3
