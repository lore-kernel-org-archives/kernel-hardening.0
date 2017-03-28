MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAK8P3a2Xh3O3j6uAskVj8YHOK=sMNBGvR_o_jSN53RdQp7NyZg@mail.gmail.com>
References: <1485894263-91051-1-git-send-email-keescook@chromium.org>
 <1485894263-91051-2-git-send-email-keescook@chromium.org> <851a0c99-db08-c3a8-f5c6-2e567971e2eb@au1.ibm.com>
 <CAGXu5j+cd8iXAVko_fOFkPLD2Q=1=S0jvCYGAhKjnTunJ=86Zg@mail.gmail.com> <CAK8P3a2Xh3O3j6uAskVj8YHOK=sMNBGvR_o_jSN53RdQp7NyZg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 28 Mar 2017 12:03:07 -0700
Message-ID: <CAGXu5jKNkBr=6uS58e08pimNb2v7Xf-YVGJ7aaHNV3pM859p5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH v5 1/4] gcc-plugins: Add the initify
 gcc plugin
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Donnellan <andrew.donnellan@au1.ibm.com>, LKML <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Josh Triplett <josh@joshtriplett.org>, PaX Team <pageexec@freemail.hu>, Masahiro Yamada <yamada.masahiro@socionext.com>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Sam Ravnborg <sam@ravnborg.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 28, 2017 at 12:49 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Mon, Mar 27, 2017 at 6:14 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Mon, Mar 27, 2017 at 12:38 AM, Andrew Donnellan
>> <andrew.donnellan@au1.ibm.com> wrote:
>>> On 01/02/17 07:24, Kees Cook wrote:
>>>>
>>>> From: Emese Revfy <re.emese@gmail.com>
>>>>
>>>> The kernel already has a mechanism to free up code and data memory that
>>>> is only used during kernel or module initialization.  This plugin will
>>>> teach the compiler to find more such code and data that can be freed
>>>> after initialization.
>>>
>>>
>>> Currently checking whether we can wire this up for powerpc without too many
>>> problems...
>>
>> Cool, thanks. FWIW, note that this plugin is a bit back-burnered at
>> the moment. I've got this in my -next tree still, but it needs some
>> rather large changes to how it does its annotations before Linus will
>> accept it.
>
> I've tried turning it on again a few days ago and still got too many build
> problems with my randconfig tree, so I've turned it off again. I think I've
> already reported most of what I found now, so I did not send out new
> reports.

Hrm, with what's in -next? That's too bad. I thought everything you
reported had been fixed. Dang. :(

-Kees

-- 
Kees Cook
Pixel Security
