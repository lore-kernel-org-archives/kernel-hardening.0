Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20151108104517.GC8632@chrystal.uk.oracle.com>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
	<n1iirh$q7o$1@ger.gmane.org>
	<CAGXu5j+ponF+a3aoCnLqEVfBy545BsxT4w=8KGikNCb_24ZgyQ@mail.gmail.com>
	<n1khkt$lc7$1@ger.gmane.org>
	<CAGXu5jLuEBUYFNmWOVNvMnTbwyy_+0R1_SywBVhcxkCcm83e-g@mail.gmail.com>
	<20151108104517.GC8632@chrystal.uk.oracle.com>
Date: Mon, 9 Nov 2015 13:29:22 -0800
Message-ID: <CAGXu5jJKYheDSqtwSp=mT-QEug_HphFZ9cbQpK6o4WnVSD+PJQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: Kernel Self Protection Project
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Nov 8, 2015 at 2:45 AM, Quentin Casasnovas
<quentin.casasnovas@oracle.com> wrote:
> On Sat, Nov 07, 2015 at 10:50:04PM -0800, Kees Cook wrote:
>> On Sat, Nov 7, 2015 at 1:52 AM, Quentin Casasnovas
>> <quentin.casasnovas@oracle.com> wrote:
>> >>
>> >> I actually think that just splitting out features might be a good
>> >> first step all around. Most folks aren't very familiar with the
>> >> PaX/Grsec patches, and they, in their monolithic nature, can be hard
>> >> to understand. Many depend on each other, but some are separable.
>> >>
>> >
>> > Agreed, that should be a required step before people can review.
>>
>> Yeah. Does anyone want to also extract PAX_USERCOPY or
>> GRKERNSEC_KSTACKOVERFLOW ? No one has mentioned an interest in those
>> yet.
>>
>
> I could have a look at splitting GRKERNSEC_KSTACKOVERFLOW on my free time
> if no-one beats me to it.

Sounds great! Please keep us posted. :)

-Kees

-- 
Kees Cook
Chrome OS Security
