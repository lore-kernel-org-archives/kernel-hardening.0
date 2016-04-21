Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jLKBD=CUPR7mHspzS6Oy99C+gXq+sLnHSbCJT6hXQGOXg@mail.gmail.com>
References: <CAGXu5jJXpnaKsG_W_xzwr0SBkKSEtUqEC0LR3-ZByPx9NAj5Lw@mail.gmail.com>
	<565B822B.8000700@nod.at>
	<CAGXu5jLKBD=CUPR7mHspzS6Oy99C+gXq+sLnHSbCJT6hXQGOXg@mail.gmail.com>
Date: Thu, 21 Apr 2016 13:33:15 -0700
Message-ID: <CAGXu5jJXqyN2ABvRxLsjhn3k_qbubw7SDxxk50Wqz=kOsLjSig@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: status: GRKERNSEC_BRUTE
To: Richard Weinberger <richard@nod.at>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 30, 2015 at 12:15 PM, Kees Cook <keescook@chromium.org> wrote:
> On Sun, Nov 29, 2015 at 2:54 PM, Richard Weinberger <richard@nod.at> wrote:
>> Am 24.11.2015 um 20:19 schrieb Kees Cook:
>>> Hi,
>>>
>>> While not strictly a _kernel_ self-protection mechanism, it's still
>>> something that I'd love to see upstream, so I'll ping about its status
>>> here too. :) Any updates on the brute force detector? (Last week I had
>>> someone suggest making this a "respawn cgroup" or something, if it's
>>> not workable as-is.) Anything we can help with?
>>
>> I can revive my patch and resend. Maybe it helps to collect
>> new ideas (or NAKs ;)).
>
> That would be great. Start by sending the series to kernel-hardening.
> We can comment on it before you send a version to lkml. (i.e. try to
> avoid NAKs...) :)

Hi!

Any updates on this? I think with the latest userspace ASLR
improvements from Android, this is becoming a more urgently needed
features. :)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
