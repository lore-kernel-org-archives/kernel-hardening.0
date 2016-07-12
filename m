Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1468351439.32683.1.camel@gmail.com>
References: <20160705013928.396ce4a7cbbc40e6c09efc43@gmail.com>
 <20160705014209.caca7667ac0984c2975b4f41@gmail.com> <CAGXu5jKKd-VcuLooiRV-ktbnYuB_EaOtUbQOOy7e5VGNgWBU-A@mail.gmail.com>
 <1468351439.32683.1.camel@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 12 Jul 2016 15:47:18 -0400
Message-ID: <CAGXu5jKOa3h=Q40j4q_-mTK5v335PUyp6KZ4RF=bX90Ug02_GQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH v2 2/3] Mark functions with the
 __nocapture attribute
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>, Karsten Keil <isdn@linux-pingi.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 12, 2016 at 3:23 PM, Daniel Micay <danielmicay@gmail.com> wrote:
> On Tue, 2016-07-12 at 15:08 -0400, Kees Cook wrote:
>> On Mon, Jul 4, 2016 at 7:42 PM, Emese Revfy <re.emese@gmail.com>
>> wrote:
>> >
>> > The nocapture gcc attribute can be on functions only.
>> > The attribute takes one or more unsigned integer constants as
>> > parameters
>> > that specify the function argument(s) of const char* type to
>> > initify.
>> > If the marked argument is a vararg then the plugin initifies
>> > all vararg arguments.
>>
>> Why is this called "nocapture"? Not captured by what? It seems like
>> it
>> means "initify this if possible". Am I misunderstanding its purpose?
>
> It means they don't escape via that function, i.e. they aren't stored
> anywhere to be used in any way after the call.

Ah, those arguments are confirmed to not be "captured" by that
function, leaving them available to be moved to .init. Got it, thanks!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
