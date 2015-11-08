Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu9x8LL+7hhdgux4EP1kXAWz_kodiZ208EBz7P=TvGpn8w@mail.gmail.com>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
	<CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
	<20151107002508.GA2605@cloud>
	<CAKv+Gu9x8LL+7hhdgux4EP1kXAWz_kodiZ208EBz7P=TvGpn8w@mail.gmail.com>
Date: Sun, 8 Nov 2015 11:09:34 +0100
Message-ID: <CA+rthh_2bc86wL0ke5J7MAzsuC+Ly73MvW+cCXK0BmzTY_N+Rw@mail.gmail.com>
From: Mathias Krause <minipli@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection features
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Theodore Tso <tytso@google.com>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 7 November 2015 at 13:41, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 7 November 2015 at 01:25, Josh Triplett <josh@joshtriplett.org> wrote:
>> On Fri, Nov 06, 2015 at 03:30:39PM -0800, Kees Cook wrote:
>>> On Fri, Nov 6, 2015 at 2:55 PM, Emese Revfy <re.emese@gmail.com> wrote:
>>> >  * initify: This plugin isn't security related either.
>>> >     It moves string constants (__func__ and function string arguments
>>> >     marked by the nocapture attribute) only referenced in
>>> >     __init/__exit functions to __initconst/__exitconst sections.
>>> >     It reduces memory usage (many kB), I think it may be important for
>>> >     embedded systems.
>>>
>>> I bet the Tinification project ( https://tiny.wiki.kernel.org/ ) would
>>> be interested in this! (CCing Josh for thoughts.)
>>
>> I'd be quite interested.
>>
>> Could the plugin operate in a mode where it emits warnings to add such
>> annotations explicitly in the code, rather than just automatically
>> moving the data?
>>
>
> Well, I suppose this operates primarily on string literals and
> initializers, for which there really isn't a way to annotate them
> other than doing something like
>
> #define INITSTR(x) ({ static char const __initconst __str[] = #x; __str; })
>
> which unfortunately breaks the concatenation of string literals (e.g.,
> 'printk(KERN_ERR INITSTR(foo))' will not work)

There were multiple attempts in the past to do this kind of annotation
on a source code level. The last one being [1], attempting to provide
pr_<LVL>() style of helpers for this. But it was shot down by Ingo
[2].

So I don't think a mode were the plugin generates patches is of much
use as those won't be accepted anyway. It's nice to get a feeling for
the coverage, but not so much for actual code changes.


Regards,
Mathias

[1] https://lkml.org/lkml/2014/8/21/255
[2] https://lkml.org/lkml/2014/8/21/290
