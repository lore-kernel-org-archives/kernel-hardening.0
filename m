MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFwDfBnMVGfBVkrFFr26tp1y8CUpSf154AuXH+sWyeY5FA@mail.gmail.com>
References: <1511803118-2552-1-git-send-email-tixxdz@gmail.com>
 <1511803118-2552-6-git-send-email-tixxdz@gmail.com> <CA+55aFxfO1i1LS9dPTTCf50ovWPXcq6BE9mKiq_FxWSm4iE8Mg@mail.gmail.com>
 <CAEiveUcvKbuJMB5801jdRosxYn+CZ4E=pfvXNrhuOrXXbw4ZBQ@mail.gmail.com>
 <CA+55aFzx2eM+wVrjQEfkE-G8E9OVLcdo6vk0fDMwZNu2sh1oCQ@mail.gmail.com>
 <1100603534.56586.1511871419952@ichabod.co-bxl> <20171128193243.4fymnjk7fplqw62x@thunk.org>
 <CAGXu5jLtBjLSe5mbe5sYSao1o67ezkkQq_u3md9646rRfi3cCQ@mail.gmail.com>
 <CA+55aFzvaFR1skBFKwT1QPnKqxaLqCuq33FCuYz8DP7MjKkgNg@mail.gmail.com>
 <CAGXu5j+OzbUAcqVBuC8QoY-ZiA9Xw6Uf9kzfzpx9MQHQ1LtxVQ@mail.gmail.com>
 <CA+55aFz0t7cCkePJQ1w44Kw_g5nns1tYJLUOL7f-c7vriqkFig@mail.gmail.com>
 <708003731.69563.1511905898471@ichabod.co-bxl> <CA+55aFzxFQeyk6Mrk50=jzevHpZ78BXz_9nHcHabMWBdM6RC6A@mail.gmail.com>
 <CA+55aFyybavkF8ccQKJsoVAF+MG=J5=e9PxXKU=J_hqCQRZnug@mail.gmail.com>
 <CAGXu5jLU8LqTYM9SYQADeH9wm2npVu4AEuSqvYqi3S+qtjC-Qw@mail.gmail.com> <CA+55aFwDfBnMVGfBVkrFFr26tp1y8CUpSf154AuXH+sWyeY5FA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Nov 2017 10:30:30 -0800
Message-ID: <CAGXu5j+Tv4KHytjOtBvG9e53o-pG7h5DjZZkATXbado-HAbKHw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] Re: [PATCH v5 next 5/5] net: modules: use
 request_module_cap() to load 'netdev-%s' modules
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Geo Kozey <geokozey@mailfence.com>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 28, 2017 at 4:50 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Nov 28, 2017 at 4:26 PM, Kees Cook <keescook@chromium.org> wrote:
>>
>>> The model that I am a proponent of is to take a softer approach
>>> initially: don't forbid module loading (because that breaks users),
>>> but instead _warn_ about non-root module loading. And then we can
>>> start fixing the cases that we find.
>>
>> I am totally fine with this. The question I'm hoping to have answered
>> is, "then what?" We already have concrete examples of module
>> autoloading that will still be need to stay unprivileged and as-is in
>> the kernel (even if we remove others). What do you see as the way to
>> allow an admin to turn those off?
>
> Just thinking about the DCCP case, where networking people actually
> knew it was pretty deprecated and had no real maintainer, I think one
> thing to look at would be simply a per-module flag.
>
> That kind of thing should be fairly easy to implement, along the same
> lines as the module license - it just sets a flag in the ELF section
> headers.
>
> With something like that, we literally could make the default be "no
> autoloading except for root", and then just mark the modules that we
> think are ok and well maintained.
>
> Sure, if you then do a lock-down mode that makes that flag parsing
> stricter, then that's a separate thing. But I suspect we definitely
> could be a lot stricter on a per-module basis, and do it in a way
> where a normal user wouldn't even notice that we've limited the
> autoloading.
>
> But the first step would be to just add some noise. And even with the
> per-module flag, at first it would only suppress the noise (ie we'd
> still _allow_ loading other modules, they'd just be noisy). Then, if
> nobody hollers, maybe the next kernel release we'll make it actually
> enforce the flag.
>
> Does that sound reasonable?

Yeah, I think I see the way forward here; thanks for the discussion!

-Kees

-- 
Kees Cook
Pixel Security
