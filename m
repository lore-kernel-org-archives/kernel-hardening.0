MIME-Version: 1.0
In-Reply-To: <20171112235451.GB11398@eros>
References: <1509580240-28314-1-git-send-email-me@tobin.cc>
 <CAGXu5jLGLAWeQ28t3TiRswbfHM9F0odZia-f=-c5sVpYm+-0UA@mail.gmail.com>
 <CAKwvOdm72j2MQPbXY5eYLj5r-9toOJd+GB2=P6z1_L7SghazZg@mail.gmail.com> <20171112235451.GB11398@eros>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 13 Nov 2017 08:50:25 -0800
Message-ID: <CAKwvOdnMTdb856v9xCJ_cBQZUy+zYmZT9=dvQQDNsisYM37CGg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC] vla: add VLA macro and testing
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, Josh Poimboeuf <jpoimboe@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

Variable Length Array In Struct, a GNU C extension.

Think of a variable length array, as a member of a struct, but not as
the final member.

On Sun, Nov 12, 2017 at 3:54 PM, Tobin C. Harding <me@tobin.cc> wrote:
> On Wed, Nov 08, 2017 at 03:04:25PM -0800, Nick Desaulniers wrote:
>> On Wed, Nov 8, 2017 at 2:58 PM, Kees Cook <keescook@chromium.org> wrote:
>> > While I'd certainly like to see SOME kind of sanity checking for VLAs,
>> > my preference would be to entirely eliminate them at get -Werror=vla
>> > added to the Makefile. Even Linus has expressed irritation over the
>> > idea of VLAs in structs in the past:
>> >
>> > https://lkml.org/lkml/2013/9/23/500
>>
>> VLAIS makes it difficult (impossible) to compile allyesconfig with
>> clang.  VLA on the stack is fine, but VLAIS is not.
>
> What is VLAIS please? I don't get any results when grepping the kernel
> tree.
>
> $ git grep VLAIS
>
> thanks,
> Tobin.



-- 
Thanks,
~Nick Desaulniers
