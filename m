Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <565B822B.8000700@nod.at>
References: <CAGXu5jJXpnaKsG_W_xzwr0SBkKSEtUqEC0LR3-ZByPx9NAj5Lw@mail.gmail.com>
	<565B822B.8000700@nod.at>
Date: Mon, 30 Nov 2015 12:15:56 -0800
Message-ID: <CAGXu5jLKBD=CUPR7mHspzS6Oy99C+gXq+sLnHSbCJT6hXQGOXg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: status: GRKERNSEC_BRUTE
To: Richard Weinberger <richard@nod.at>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Nov 29, 2015 at 2:54 PM, Richard Weinberger <richard@nod.at> wrote:
> Am 24.11.2015 um 20:19 schrieb Kees Cook:
>> Hi,
>>
>> While not strictly a _kernel_ self-protection mechanism, it's still
>> something that I'd love to see upstream, so I'll ping about its status
>> here too. :) Any updates on the brute force detector? (Last week I had
>> someone suggest making this a "respawn cgroup" or something, if it's
>> not workable as-is.) Anything we can help with?
>
> I can revive my patch and resend. Maybe it helps to collect
> new ideas (or NAKs ;)).

That would be great. Start by sending the series to kernel-hardening.
We can comment on it before you send a version to lkml. (i.e. try to
avoid NAKs...) :)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
