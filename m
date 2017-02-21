MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170220124531.GH9003@leverpostej>
References: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
 <1487498660-16600-7-git-send-email-hoeun.ryu@gmail.com> <CAKv+Gu9umycZm_UP99ZUifLUBb8MuOZHXgU9nB6XioVMa4eeVw@mail.gmail.com>
 <20170220124531.GH9003@leverpostej>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 21 Feb 2017 12:38:03 -0800
Message-ID: <CAGXu5jKFEB5bno40TdMTmsfqHOWK92mmpK3KMnd05VnQNmHypQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC 7/7] arm64: map seperately rodata sections for
 __ro_mostly_after_init section
To: Mark Rutland <mark.rutland@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Laura Abbott <labbott@redhat.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jeremy Linton <jeremy.linton@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 20, 2017 at 4:45 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> On Sun, Feb 19, 2017 at 11:35:51AM +0000, Ard Biesheuvel wrote:
>> On 19 February 2017 at 10:04, Hoeun Ryu <hoeun.ryu@gmail.com> wrote:
>> > Map rodata sections seperately for the new __ro_mostly_after_init section.
>> > Attribute of memory for __ro_mostly_after_init section can be changed later
>> > so we need a dedicated vmalloced region for set_memory_rw/ro api.
>
>> While it is correct that you are splitting this into three separate
>> segments (otherwise we would not be able to change the permissions
>> later without risking splitting to occur), I think this leads to
>> unnecessary fragmentation.
>>
>> If there is demand for this feature (but you still need to make the
>> argument for that), I wonder if it wouldn't be sufficient, and much
>> more straightforward, to redefine the __ro_after_init semantics to
>> include the kind of subsystem registration and module init context you
>> are targeting, and implement some hooks to temporarily lift the
>> __ro_after_init r/o permission restrictions in a controlled manner.
>
> From a look over the series, I think this is just __write_rarely in
> disguise. I personally think that we should keep __write_rarely and
> __ro_after_init separate, the later being a strictly one-shot affair.

That's my thinking too.

> I had some ideas [1] as to how we could implement __write_rarely without
> carving up the kernel mapping further (and keeping the RW permissions
> local to the thread needing it), but I have not had the time to look
> into that further.

I'm working on a series to do this for x86, but I keep getting
distracted. I hope to get an RFC posted this week.

-Kees

-- 
Kees Cook
Pixel Security
