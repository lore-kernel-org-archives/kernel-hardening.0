Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <n1khkt$lc7$1@ger.gmane.org>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
	<n1iirh$q7o$1@ger.gmane.org>
	<CAGXu5j+ponF+a3aoCnLqEVfBy545BsxT4w=8KGikNCb_24ZgyQ@mail.gmail.com>
	<n1khkt$lc7$1@ger.gmane.org>
Date: Sat, 7 Nov 2015 22:50:04 -0800
Message-ID: <CAGXu5jLuEBUYFNmWOVNvMnTbwyy_+0R1_SywBVhcxkCcm83e-g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: Kernel Self Protection Project
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Nov 7, 2015 at 1:52 AM, Quentin Casasnovas
<quentin.casasnovas@oracle.com> wrote:
> On 2015-11-06, Kees Cook <keescook@chromium.org> wrote:
>> On Fri, Nov 6, 2015 at 8:00 AM, Quentin Casasnovas
>><quentin.casasnovas@oracle.com> wrote:
>>>>
>>>> For now, I'm going to focus on taking a look at the PAX_SIZE_OVERFLOW
>>>> gcc plugin, which will also get us the gcc plugin infrastructure.
>>>> Other people, please speak up on what you'd like to tackle.
>>>>
>>>
>>> Not that it's complex but I already have a branch with the gcc plugin
>>> infrastructure split up if you're interested and you reckon that can save
>>> you some time.
>>
>> Sure, what's the URL?
>>
>
> I've pushed the three of them onto:
>
>   https://github.com/casasnovas/linux/commits/quentin-spk-gcc-plugin

Excellent, thanks for putting that up. I'll take a look.

Given Emese's comments in the other thread, I may actually pass on
this as my first piece to tackle. I may wait to see the constify
plugin go in first.

>
> It lacks Documentation for now, but you can have a look at the branch
> quentin-fuzz-gccplugin which adds an instrumentation plugin (converted from
> the gcc patch[1] Dmitry Vyukov wrote for syzkaller[2]).

syzkaller has been producing some very interesting bugs lately!

>
> Adding a plugin should be simple, add its name to $(HOSTLIBS)-y, and use
> the regular kbuild system way to specify from which source files it is
> built, CFLAGS, etc.
>
>   $(HOSTLIBS)-y = foo.so
>   foo-objs = foo.c bar.c
>
> And then to have some compilations units be compiled using foo.so, they
> just need the following in their CFLAGS:
>
>  -fplugin=$(objtree)/path/to/foo.so
>
>
>   [1] https://codereview.appspot.com/267910043
>   [2] https://github.com/google/syzkaller
>
> All of this is taken from the grsecurity/PaX Team patchset.
>
>>
>> I actually think that just splitting out features might be a good
>> first step all around. Most folks aren't very familiar with the
>> PaX/Grsec patches, and they, in their monolithic nature, can be hard
>> to understand. Many depend on each other, but some are separable.
>>
>
> Agreed, that should be a required step before people can review.

Yeah. Does anyone want to also extract PAX_USERCOPY or
GRKERNSEC_KSTACKOVERFLOW ? No one has mentioned an interest in those
yet.

-Kees

>
>> I'm also hoping Emese Revfy[1] might be interested in driving
>> PAX_SIZE_OVERFLOW too, which would be terrific, since she's way more
>> qualified than me to do it. /me awaits emails. :)
>>
>> -Kees
>>
>> [1] https://github.com/ephox-gcc-plugins/size_overflow
>>
>
> Quentin
>



-- 
Kees Cook
Chrome OS Security
