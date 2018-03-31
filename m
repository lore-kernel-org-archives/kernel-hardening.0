MIME-Version: 1.0
In-Reply-To: <20180330103411.5ed25f43@gandalf.local.home>
References: <1522399988-8815-1-git-send-email-s.mesoraca16@gmail.com> <20180330103411.5ed25f43@gandalf.local.home>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sat, 31 Mar 2018 11:55:16 +0200
Message-ID: <CAJHCu1+9NJ0onfjETfwn+XSL_d1Zxo0P=5RpWUkxnXO597BA5g@mail.gmail.com>
Subject: Re: [v2] ftrace: drop a VLA in module_exists()
Content-Type: text/plain; charset="UTF-8"
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

2018-03-30 16:34 GMT+02:00 Steven Rostedt <rostedt@goodmis.org>:
> On Fri, 30 Mar 2018 10:53:08 +0200
> Salvatore Mesoraca <s.mesoraca16@gmail.com> wrote:
>
> Couple of things. First, "PATCH" was dropped from the subject. If my
> inbox was busy today, I probably would have missed this email.

Aargh, I'm sorry for this, I didn't notice it.

>> Avoid a VLA[1] by using a real constant expression instead of a variable.
>> The compiler should be able to optimize the original code and avoid using
>> an actual VLA. Anyway this change is useful because it will avoid a false
>> positive with -Wvla, it might also help the compiler generating better
>> code.
>>
>> [1] https://lkml.org/lkml/2018/3/7/621
>
> Second, do not use lkml.org, use http://lkml.kernel.org/r/<messageid>
>
> Search for "Link:" tags in git log to see examples.

Thank you for the suggestion.

> Other than that, the patch looks fine to me and I can pull it for the
> next merge window.

Thank you very much,

Salvatore
