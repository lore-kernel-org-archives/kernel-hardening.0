MIME-Version: 1.0
In-Reply-To: <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org>
 <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com>
 <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
 <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com> <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
From: Djalal Harouni <tixxdz@gmail.com>
Date: Tue, 28 Nov 2017 22:10:24 +0100
Message-ID: <CAEiveUehNyZ3mFwzvuu1fj87_37QR+rRyQ9pBLzj-V6yshP1-g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Theodore Ts'o <tytso@mit.edu>, Jonathan Corbet <corbet@lwn.net>, James Morris <james.l.morris@oracle.com>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Geo Kozey <geokozey@mailfence.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 9:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Nov 28, 2017 at 12:20 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>> So what's the right path forward for allowing a way to block
>> autoloading? Separate existing request_module() calls into "must be
>> privileged" and "can be unpriv" first, then rework the series to deal
>> with the "unpriv okay" subset?
>
> So once we've taken care of the networking ones that check their own
> different capability bit, maybe we can then make the regular
> request_module() do a rate-limited warning for non-CAP_SYS_MODULE uses
> that prints which module it's loading.

Alright, I can start by those.


> And then just see what people report.
>
> Because maybe it's just a very small handful that matters, and we can
> say "those are ok".

The ones that are in the cover letter, etc may not have the
appropriate context, the request_module_dev() sure can be made since
if you can open you already have the context.


> And maybe that is too optimistic, and we have a lot of device driver
> ones because people still have a static /dev and don't have udev
> populating modules and device nodes, and then maybe we need to
> introduce a "request_module_dev()" where the rule is that you had to
> at least have privileges to open the device node.
>
> Because I really am *not* interested in these security flags that are
> off by default and then get turned on by special cases. I think it's
> completely unacceptable to say "we're insecure by default but then you
> can do X and be secure". It doesn't work. It doesn't fix anything.

this still leaves all the cases where we don't have the appropriate
context and other implicit loads that are triggered by another
implicit load, etc.

Also the simple local flag is easy to grasp, with real users for it,
and we can abstract on top with load "newfeatures" of course this does
not mean that we should say "we-re insecure by default". I want it to
be more allow newfeatures or not for apps and users... requiring caps
may give users the idea to pass CAP_SYS_MODULE or other caps for
something that used to work, they may start giving it if we break lot
of usecases, and yeh the caps are much broader and do much more
harm...

Ok, so beside updating with request_module_cap() I will investigate
request_module_dev() and we can see

Thanks!

>                  Linus



-- 
tixxdz
