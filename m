Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <n1iirh$q7o$1@ger.gmane.org>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
	<n1iirh$q7o$1@ger.gmane.org>
Date: Fri, 6 Nov 2015 10:15:25 -0800
Message-ID: <CAGXu5j+ponF+a3aoCnLqEVfBy545BsxT4w=8KGikNCb_24ZgyQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: Kernel Self Protection Project
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Nov 6, 2015 at 8:00 AM, Quentin Casasnovas
<quentin.casasnovas@oracle.com> wrote:
> On 2015-11-05, Kees Cook <keescook@chromium.org> wrote:
>> I'm organizing a community of people to work on the various kernel
>> self-protection technologies (most of which are found in PaX and
>> Grsecurity). I'm building on the presentation I gave at Kernel Summit
>> where I sought to convince the other upstream Linux kernel developers
>> that security is more than fixing bugs, and that we need to bring in
>> proactive defenses:
>> http://lwn.net/Articles/662219/
>>
>
> Great initiative!
>
>>
>> For now, I'm going to focus on taking a look at the PAX_SIZE_OVERFLOW
>> gcc plugin, which will also get us the gcc plugin infrastructure.
>> Other people, please speak up on what you'd like to tackle.
>>
>
> Not that it's complex but I already have a branch with the gcc plugin
> infrastructure split up if you're interested and you reckon that can save
> you some time.

Sure, what's the URL?

I actually think that just splitting out features might be a good
first step all around. Most folks aren't very familiar with the
PaX/Grsec patches, and they, in their monolithic nature, can be hard
to understand. Many depend on each other, but some are separable.

I'm also hoping Emese Revfy[1] might be interested in driving
PAX_SIZE_OVERFLOW too, which would be terrific, since she's way more
qualified than me to do it. /me awaits emails. :)

-Kees

[1] https://github.com/ephox-gcc-plugins/size_overflow

-- 
Kees Cook
Chrome OS Security
