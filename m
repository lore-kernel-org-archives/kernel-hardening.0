MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <87inmujz49.fsf@rasmusvillemoes.dk>
References: <1485894263-91051-1-git-send-email-keescook@chromium.org>
 <1485894263-91051-2-git-send-email-keescook@chromium.org> <851a0c99-db08-c3a8-f5c6-2e567971e2eb@au1.ibm.com>
 <CAGXu5j+cd8iXAVko_fOFkPLD2Q=1=S0jvCYGAhKjnTunJ=86Zg@mail.gmail.com> <87inmujz49.fsf@rasmusvillemoes.dk>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 27 Mar 2017 12:33:23 -0700
Message-ID: <CAGXu5jKSU+Nw37EoHsPYAL2_CHVffgML2Vi0aJkRCK4PxATUXQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 1/4] gcc-plugins: Add the initify gcc plugin
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Donnellan <andrew.donnellan@au1.ibm.com>, LKML <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, PaX Team <pageexec@freemail.hu>, Masahiro Yamada <yamada.masahiro@socionext.com>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Sam Ravnborg <sam@ravnborg.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 27, 2017 at 12:31 PM, Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
> On Mon, Mar 27 2017, Kees Cook <keescook@chromium.org> wrote:
>
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
> Why not just hardcode the annotations in the plugin itself? I'd expect
> just making it know about mem*, str*, and the various *printf/printk
> functions would get 90% of the benefits. The prototypes of these
> aren't gonna change anytime soon, so there's no compelling reason to
> keep the annotations with the declarations. The plugin can still do
> its sanity checking when it compiles a function with one of these names.

Yup, I think that's another entirely workable solution too. I just
meant to say that I don't have time at the moment to look at it (if
you want to, please do), and I think Emese is already happy with how
the annotations work, so I don't think she'd want to work on it either
(but she can correct me if I'm wrong).

-Kees

-- 
Kees Cook
Pixel Security
