Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161018133439.GE15639@leverpostej>
References: <20161018060950.GM19531@linaro.org> <20161018133439.GE15639@leverpostej>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 18 Oct 2016 11:06:43 -0700
Message-ID: <CAGXu5jKc54ovPvhcHCcJhRDDfZvV+3u22Yc=G9WrorVVJ2mUKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [RFC] module: add 'module_ronx=off' boot
 cmdline parameter to disable ro/nx module mappings
To: Mark Rutland <mark.rutland@arm.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 18, 2016 at 6:34 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> Hi,
>
> On Tue, Oct 18, 2016 at 03:09:51PM +0900, AKASHI Takahiro wrote:
>> As making CONFIG_DEBUG_RODATA mandatory is a good idea, so will be
>> for CONFIG_SET_MODULE_RONX.
>
> I completely agree, given most distros ship a large number of drivers as
> modules...
>
>> This patch adds a command line parameter, "module_ronx=," in order to
>> make this configuration always on in the future, but still allowing for
>> disabling read-only module mappings at boot time as "rodata=" does.
>>
>> I have, however, some concerns on this prototype:
>> (1) should we use a separate parameter like "module_ronx=," or
>>     unify it with "rodata="?
>
> I think this should be merged with "rodata=".

Agreed: it's really just a development artifact that these configs are
separate to begin with, so I think we should continue to consolidate
and merge it with "rodata=".

-Kees

-- 
Kees Cook
Nexus Security
